//
//  ImagesParser.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 07/05/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

struct ImageApiModel {
    let webformatURL: String
    let type: String
}

class ImagesParser: IParser {
    typealias Model = [ImageApiModel]
    
    func parse(data: Data) -> [ImageApiModel]? {
        // parse the result as JSON, since that's what the API provides
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
            guard let feed = json["hits"] as? [[String : Any]] else {
                    return nil
            }
            
            var images: [ImageApiModel] = []
            
            for imagesObject in feed {
                guard let type = imagesObject["type"] as? String,
                    let webformatURL = imagesObject["webformatURL"] as? String
                    else { continue }
                images.append(ImageApiModel(webformatURL: webformatURL, type: type))
            }
            
            return images
            
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
    }
}
