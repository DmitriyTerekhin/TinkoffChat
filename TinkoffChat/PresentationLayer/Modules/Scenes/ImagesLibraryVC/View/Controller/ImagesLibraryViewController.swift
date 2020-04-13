//
//  ImagesViewController.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 04/05/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

protocol ImagesLybraryDelegate: class {
    func imageDidTapped(_ image: UIImage)
}

class ImagesLibraryViewController: UIViewController {
    
    private let imageLibraryView = ImagesLibraryView(frame: UIScreen.main.bounds)
    private var c = [UIImage]()
    private let presenter: IImagesLibraryPresenter
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    weak var delegate: ImagesLybraryDelegate?
    
    init(presenter: IImagesLibraryPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = imageLibraryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        presenter.attachView(self)
        presenter.loadImages()
    }
    
    private func setupCollectionView() {
        imageLibraryView.collectionView.dataSource = self
        imageLibraryView.collectionView.delegate = self
        imageLibraryView.collectionView.register(ImagesLibraryCollectionViewCell.self, forCellWithReuseIdentifier: ImagesLibraryCollectionViewCell.defaultReuseIdentifier)
    }

    deinit {
        print("ImageLibrary deinit")
    }
}

//MARK: - View
extension ImagesLibraryViewController: IImagesLibraryView {
    
    func displayMessage(title: String, msg: String) {
        displayMsg(title: title, msg: msg)
    }
    
    func startSpinner() {
        imageLibraryView.spinner.startAnimating()
    }
    
    func stopSpinner() {
        imageLibraryView.spinner.stopAnimating()
    }
    
    func updateCollectionView() {
        imageLibraryView.collectionView.reloadData()
    }
    
}

//MARK: - UICollectionViewDataSource
extension ImagesLibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesLibraryCollectionViewCell.defaultReuseIdentifier, for: indexPath) as! ImagesLibraryCollectionViewCell
        presenter.loadOneImage(for: cell, indexPath: indexPath)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}


//MARK: - CollectionView Delegates
extension ImagesLibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ImagesLibraryCollectionViewCell
        delegate?.imageDidTapped(cell?.imageView.image ?? UIImage())
        dismiss(animated: true, completion: nil)
    }
}
