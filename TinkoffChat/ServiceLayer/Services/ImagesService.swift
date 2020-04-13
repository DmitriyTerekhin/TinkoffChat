//
//  ImagesService.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 07/05/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

typealias LoadBatchOfImagesCompletionHandler = ([ImageApiModel]?, String?) -> Void
typealias LoadImageDataCompletionHandler = (Data?, String?, URL) -> Void

protocol IImagesService {
    func loadAllImages(completionHandler: @escaping LoadBatchOfImagesCompletionHandler)
    func loadImage(from url: URL, completionHandler: @escaping LoadImageDataCompletionHandler)
}

class ImagesService: IImagesService {
    
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadAllImages(completionHandler: @escaping LoadBatchOfImagesCompletionHandler) {
        let requestConfig = RequestsFactory.PixaBayAPIRequest.allImagesConfig()
        loadImages(requestConfig: requestConfig, completionHandler: completionHandler)
    }
    
    private func loadImages(requestConfig: RequestConfig<ImagesParser>,
                            completionHandler: @escaping LoadBatchOfImagesCompletionHandler) {
        requestSender.send(requestConfig: requestConfig) { (result: Result<[ImageApiModel]>) in
            switch result {
            case .success(let apps):
                completionHandler(apps, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func loadImage(from url: URL, completionHandler: @escaping LoadImageDataCompletionHandler) {
        let requestConfig = RequestsFactory.PixaBayAPIRequest.oneImageConfig(from: url)
        requestSender.send(requestConfig: requestConfig) { (result: Result<Data>) in
            switch result {
            case .success(let info):
                completionHandler(info, nil, url)
            case .error(let error):
                completionHandler(nil, error, url)
            }
        }
    }
    
}
