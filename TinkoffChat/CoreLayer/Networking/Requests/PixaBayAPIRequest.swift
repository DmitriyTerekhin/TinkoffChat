//
//  AppleRSSRequest.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 07/05/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

class PixaBayAllImagesRequest: IRequest {
    
    private var baseUrl: String = "https://pixabay.com/api/"
    private var limit: Int
    private var apiKey: String
    private var getParameters: [String : String]  {
        return ["key": apiKey,
                "per_page": "\(limit)",
                "format" : "json"]
    }
    
    private var urlString: String {
        let getParams = getParameters.compactMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseUrl + "?" + getParams
    }
    
    // MARK: - IRequest
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    // MARK: - Initialization
    init(limit: Int = 100, apiKey: String) {
        self.limit = limit
        self.apiKey = apiKey
    }
}
