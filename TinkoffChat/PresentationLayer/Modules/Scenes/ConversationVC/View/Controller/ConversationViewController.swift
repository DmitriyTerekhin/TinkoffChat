//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 3/13/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
    
    private let presenter: IConversationPresenter
    private let userName: String
    let conversationView = ConversationView(frame: UIScreen.main.bounds)
    private var fetchedResultController: NSFetchedResultsController<DBMessage>?
    
    override func loadView() {
        view = conversationView
    }
    
    init(presenter: IConversationPresenter, userName: String) {
        self.presenter = presenter
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        setupTableView()
        setupKeyboard()
        setupFRC()
        setupTitle()
        conversationView.sendButton.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        conversationView.tableView.scrollToBottom(animated: false)
    }
    
    private func setupTitle() {
        conversationView.titleNameLabel.text = userName
        navigationItem.titleView = conversationView.titleNameLabel
    }
    
    private func setupTableView() {
        conversationView.tableView.dataSource = self
        conversationView.tableView.delegate = self
        conversationView.tableView.register(UINib(nibName: MessageTableViewCell.xibName, bundle: nil), forCellReuseIdentifier: MessageTableViewCell.defaultReuseIdentifier)
    }
    
    private func setupFRC() {
        presenter.setupFRC(with: presenter.companionUserId)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            var position: CGFloat = 0
            if let keyBoardY = endFrame?.origin.y, keyBoardY >= UIScreen.main.bounds.size.height {
                position = 0
            } else {
                position = -(endFrame?.size.height ?? 0.0)
            }
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.view.frame = CGRect(x: 0, y: position, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }, completion: nil)
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let messageString = conversationView.inputTextField.text, messageString != "" else {return}
        presenter.sendMessage(text: messageString, to: presenter.companionUserId)
    }
}

//MARK: - UITableDataSource methods
extension ConversationViewController: UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.defaultReuseIdentifier) as! MessageTableViewCell
        
        if let message = fetchedResultController?.object(at: indexPath) {

            cell.messageLabel.text = message.text
            let size = CGSize(width: UIScreen.main.bounds.width * 3/4,height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: message.text ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize:18)], context: nil)
            
            if message.isIncoming {
                // По хорошему, конечно, надо бы сделать вычисляемую высоту и ширину, а не  подогнанную
                cell.messageLabel.frame = CGRect(x: 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.bubbleView.frame = CGRect(x: 20, y: 8, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                
                cell.bubbleView.backgroundColor = UIColor.Tinkoff.bubbleGray
                cell.messageLabel.textColor = .black
            } else {
                cell.messageLabel.frame = CGRect(x: 10, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.bubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 8, width: estimatedFrame.width + 16 + 10, height: estimatedFrame.height + 20)
                cell.bubbleView.backgroundColor = UIColor.Tinkoff.bubbleBlue
                cell.messageLabel.textColor = .white
            }
        }

        return cell
    }
    
}

//MARK: - View
extension ConversationViewController: IConversationView {
    
    func displayMessage(title: String, msg: String) {
        displayMsg(title: title, msg: msg)
    }
    
    func clearTextField() {
        conversationView.inputTextField.text = ""
    }
    
    func connectionChanged(with userId: String, on: Bool) {
        self.changeButtonStateOn(isActive: on)
        self.changeTitleStateWithAnimation(isActive: on)
    }
    
    private func changeButtonStateOn(isActive: Bool) {
        let sendBtn = self.conversationView.sendButton

        let newWidthAndHeight: CGFloat = 60 * 1.15
        let oldWidthAndHeight: CGFloat = 60
        
        func showAnimation() {
            UIView.animate(withDuration: 0.25, animations: {
                self.conversationView.layoutIfNeeded()
            }) { (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.conversationView.sendButtonHeightConstraint.constant = oldWidthAndHeight
                    self.conversationView.sendButtonWidthConstraint.constant = oldWidthAndHeight
                    UIView.animate(withDuration: 0.25, animations: {
                        self.conversationView.layoutIfNeeded()
                    })
                })
            }
        }
        
        if isActive {
            sendBtn.isEnabled = true
            sendBtn.backgroundColor = .green
            conversationView.sendButtonHeightConstraint.constant = newWidthAndHeight
            conversationView.sendButtonWidthConstraint.constant = newWidthAndHeight
            showAnimation()
        } else {
            sendBtn.isEnabled = false
            sendBtn.backgroundColor = .black
            conversationView.sendButtonHeightConstraint.constant = newWidthAndHeight
            conversationView.sendButtonWidthConstraint.constant = newWidthAndHeight
            showAnimation()
        }
    }
    
    private func changeTitleStateWithAnimation(isActive: Bool) {
        
        if isActive {
            self.conversationView.titleNameLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            UIView.animate(withDuration: 1.0) {
                self.conversationView.titleNameLabel.textColor = .green
                self.conversationView.titleNameLabel.transform = .identity
            }
        } else {
            self.conversationView.titleNameLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            UIView.animate(withDuration: 1.0) {
                self.conversationView.titleNameLabel.textColor = .black
                self.conversationView.titleNameLabel.transform = .identity
            }
        }
    }
    
    func setupView(with frc: NSFetchedResultsController<DBMessage>) {
        fetchedResultController = frc
        fetchedResultController?.delegate = self
        do {
            try fetchedResultController?.performFetch()
            conversationView.tableView.reloadData()
        } catch {
            print("Error - \(error), function:" + #function)
        }
    }

}

//MARK: - UITableViewDelegate methods
extension ConversationViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let messages = fetchedResultController?.fetchedObjects, let messageText = messages[indexPath.row].text {
            return presenter.getCellHeightForText(messageText)
        }
        return 100
    }
}

//MARK: - NSFetchedResultsControllerDelegate methods
extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationView.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                conversationView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                conversationView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                conversationView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                conversationView.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                conversationView.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationView.tableView.endUpdates()
        scrollToLastCellAnimation()
    }
    
    private func scrollToLastCellAnimation() {
        let currentOffset = conversationView.tableView.contentOffset.y
        let row = fetchedResultController?.fetchedObjects?.count ?? 0
        let cell = conversationView.tableView.cellForRow(at: IndexPath(row: row - 1, section: 0))
        conversationView.tableView.setContentOffset(CGPoint(x: 0, y: currentOffset + (cell?.contentView.bounds.height ?? 0)), animated: true)
    }
}
