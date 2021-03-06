//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 10/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController {
    
    private let conversationListView = ConversationListView(frame: UIScreen.main.bounds)
    private var fetchedResultController: NSFetchedResultsController<DBConversation>?
    var conversationsToDisplay = [ConversationsListSection]()
    
    // Dependencies
    private let model: IConversationListModel
    private let presentationAssembly: IPresentationAssembly
    
    override func loadView() {
        view = conversationListView
    }
    
    init(model: IConversationListModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        initialSetupDataSource()
        setupTableView()
        model.delegate = self
        model.setupFRC()
        title = "Tinkoff Chat"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedRowIP = conversationListView.tableView.indexPathForSelectedRow {
            conversationListView.tableView.deselectRow(at: selectedRowIP, animated: true)
        }
    }
    
    private func initialSetupDataSource() {
        conversationsToDisplay = [
            ConversationsListSection(tittle: "Онлайн", rows: [ConversationsListConfiguration]()),
            ConversationsListSection(tittle: "Оффлайн", rows: [ConversationsListConfiguration]())
        ]
    }
    
    private func setupTableView() {
        conversationListView.tableView.dataSource = self
        conversationListView.tableView.delegate = self
        conversationListView.tableView.register(UINib(nibName: ConversationListTableViewCell.xibName, bundle: nil), forCellReuseIdentifier: ConversationListTableViewCell.reuseIdentifier)
    }
    
    private func setupNavigationBarItems() {
        let leftBarButtonItem = UIBarButtonItem(title: "Цвет", style: .plain, target: self, action: #selector(showChooseAppThemeVC))
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        
        let rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "user-Icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showMyProfileVC))
        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
    }
    
    @objc private func showChooseAppThemeVC() {
        let themesVC = presentationAssembly.themesViewController()
        themesVC.model = Themes(value1: .purple, value2: .orange, value3: .gray)
        themesVC.delegate = self
        present(UINavigationController(rootViewController: themesVC), animated: true, completion: nil)
    }
    
    @objc private func showMyProfileVC() {
        present(presentationAssembly.profileViewController(), animated: true, completion: nil)
    }
    
}

//MARK: - UITableViewDataSource methods
extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController?.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = fetchedResultController?.sections?.count else {
            return 0
        }
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let convListCell = tableView.dequeueReusableCell(withIdentifier: ConversationListTableViewCell.reuseIdentifier, for: indexPath) as! ConversationListTableViewCell
        
        if let conversation = fetchedResultController?.object(at: indexPath) {
            
            let message = model.getlastMessageFromConversationsWith(conversation.id)
            
            let convListModel = ConversationList(name: conversation.user.name, userId: conversation.user.id, message: message?.text, date: message?.date, online: conversation.user.isOnline, hasUnreadMessage: conversation.hasUnreadMessage)
            convListCell.configureCell(with: convListModel)
        }
        
        return convListCell
    }
 
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (fetchedResultController?.sections) != nil {
            switch section {
            case 0:
                return "Online"
            case 1:
                return "Offline"
            default: return "Ошибка"
            }
        } else {
            return nil
        }
    }
}

//MARK: - UITableViewDelegate methods
extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conv = fetchedResultController?.object(at: indexPath) else {return}
        navigationController?.pushViewController(presentationAssembly.conversationViewControllerWith(conv.user.id, userName: conv.user.name), animated: true)
    }
}

extension ConversationsListViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
        print("choosen color - " + (selectedTheme.name ?? "undefind"))
        
        //ДЗ №4. 10 пункт (Думаю не имеет особого значения, цвет какого элемента будет меняться. Пусть это будет бэк нав бара.):
        setupAndSaveThemeColor(selectedTheme)
    }
    
    private func setupAndSaveThemeColor(_ color: UIColor) {
        UserDefaults.standard.saveAppThemeColor(color)
        UINavigationBar.appearance().backgroundColor = color
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension ConversationsListViewController: ConversationListModelDelegate {
    func setupView(with frc: NSFetchedResultsController<DBConversation>) {
        fetchedResultController = frc
        fetchedResultController?.delegate = self
        do {
            try fetchedResultController?.performFetch()
        } catch {
            print("Error - \(error), function:" + #function)
        }
    }
    
    func updateFRC() {
        //Когда просто меняешь проперти у уже существующего объеекта, то метод controllerWillChangeContent не срабатывает(и это эппл так сделала:((), поэтому вручную обновляем
        try? fetchedResultController?.performFetch()
        conversationListView.tableView.reloadData()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationListView.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                conversationListView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                conversationListView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                conversationListView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                conversationListView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                conversationListView.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationListView.tableView.endUpdates()
    }
}
