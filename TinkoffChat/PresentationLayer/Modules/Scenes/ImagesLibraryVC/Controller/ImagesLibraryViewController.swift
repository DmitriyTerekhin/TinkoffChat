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
    private let model: IImagesLibraryModel
    private var imagesDataSource = [ImageApiModel]() {
        didSet {
            DispatchQueue.main.async {
                self.imageLibraryView.collectionView.reloadData()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    weak var delegate: ImagesLybraryDelegate?
    
    init(model: IImagesLibraryModel) {
        self.model = model
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
        loadImages()
    }
    
    private func setupCollectionView() {
        imageLibraryView.collectionView.dataSource = self
        imageLibraryView.collectionView.delegate = self
        imageLibraryView.collectionView.register(ImagesLibraryCollectionViewCell.self, forCellWithReuseIdentifier: ImagesLibraryCollectionViewCell.cellIdentifier)
    }
    
    private func loadImages() {
        imageLibraryView.spinner.startAnimating()
        model.loadImages() { [weak self] imagesModels, error in
            
            DispatchQueue.main.async {
                self?.imageLibraryView.spinner.stopAnimating()
            }
            
            if let thisError = error {
                print(thisError)
                self?.displayMsg(title: "Ошибка", msg: thisError)
                return
            }
            
            guard let imagesArray = imagesModels else {return}
            
            self?.imagesDataSource = imagesArray
        }
    }

}

//MARK: - UICollectionViewDataSource
extension ImagesLibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesLibraryCollectionViewCell.cellIdentifier, for: indexPath) as! ImagesLibraryCollectionViewCell
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ImagesLibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ImagesLibraryCollectionViewCell
        delegate?.imageDidTapped(cell?.imageView.image ?? UIImage())
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let imageCell = cell as? ImagesLibraryCollectionViewCell, let imageURL = URL(string: imagesDataSource[indexPath.row].webformatURL) {
            model.loadOneImage(from: imageURL) { (data, errorString) in
                guard errorString == nil else {
                    return}
                
                if let imageData = data {
                    DispatchQueue.main.async {
                        imageCell.imageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
