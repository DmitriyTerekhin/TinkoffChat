//
//  ImagesLibraryModel.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 04/05/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol IImagesLibraryModel {
    func loadImages(completionHandler: @escaping LoadBatchOfImagesCompletionHandler)
    func loadOneImage(from url: URL, completionHandler: @escaping LoadImageDataCompletionHandler)
}

class ImagesLibraryModel: IImagesLibraryModel {
    
    private let imagesService: IImagesService
    
    init(imageService: IImagesService) {
        self.imagesService = imageService
    }
    
    func loadImages(completionHandler: @escaping LoadBatchOfImagesCompletionHandler) {
        imagesService.loadAllImages { (imagesArray, error) in
            completionHandler(imagesArray, error)
        }
    }
    
    func loadOneImage(from url: URL, completionHandler: @escaping LoadImageDataCompletionHandler) {
        imagesService.loadImage(from: url) { (data, error) in
            completionHandler(data, error)
        }
    }

}
