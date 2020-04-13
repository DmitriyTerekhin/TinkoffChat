//
//  ImagesLibraryModel.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 04/05/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol IImagesLibraryPresenter {
    var imagesArray: [ImageApiModel] {get set}
    func loadImages()
    func loadOneImage(for cell: ImagesLibraryCollectionViewCell, indexPath: IndexPath)
    func attachView(_ view: IImagesLibraryView)
}

protocol IImagesLibraryView: class {
    func startSpinner()
    func stopSpinner()
    func displayMessage(title: String, msg: String)
    func updateCollectionView()
}

class ImagesLibraryPresenter: IImagesLibraryPresenter {
    
    private let imagesService: IImagesService
    weak private var view: IImagesLibraryView?
    var imagesArray: [ImageApiModel] = []
    
    init(imageService: IImagesService) {
        self.imagesService = imageService
    }
    
    func attachView(_ view: IImagesLibraryView) {
        self.view = view
    }
    
    func loadImages() {
        view?.startSpinner()
        imagesService.loadAllImages { [weak self] (imagesModels, error) in
            
            DispatchQueue.main.async {
                self?.view?.stopSpinner()
                
                if let thisError = error {
                    print(thisError)
                    self?.view?.displayMessage(title: "Ошибка", msg: thisError)
                    return
                }
                guard let imagesArray = imagesModels else {return}
                self?.imagesArray = imagesArray
                self?.view?.updateCollectionView()
            }
        }
    }
    
    func loadOneImage(for cell: ImagesLibraryCollectionViewCell, indexPath: IndexPath) {
        let object = imagesArray[indexPath.row]
        guard let imageURL = URL(string: object.webformatURL) else {return}
        if let imgData = object.imageData {
            cell.imageView.image = UIImage(data: imgData)
        } else {
            imagesService.loadImage(from: imageURL) { [weak self] (data, errorString, url) in
                guard errorString == nil, url == imageURL else {
                    return}
                if let imageData = data {
                    DispatchQueue.main.async {
                        self?.imagesArray[indexPath.row].imageData = imageData
                        cell.imageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
