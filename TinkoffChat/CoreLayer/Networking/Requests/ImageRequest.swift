//
//  ImageRequest.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 10/08/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {
    
    var urlRequest: URLRequest?
    
    init(url: URL) {
        self.urlRequest = URLRequest(url: url)
    }
    
}
