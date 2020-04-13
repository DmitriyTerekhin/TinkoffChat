//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 07/05/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    struct PixaBayAPIRequest {
        static func allImagesConfig() -> RequestConfig<ImagesParser> {
            let request = PixaBayAllImagesRequest(apiKey: "8928766-58bdf4197415976f8d0a71311")
            return RequestConfig<ImagesParser>(request:request, parser: ImagesParser())
        }
        
        static func oneImageConfig(from url: URL) -> RequestConfig<ImageParser> {
            let request =  ImageRequest(url: url)
            return RequestConfig<ImageParser>(request: request, parser: ImageParser())
        }
    }
}
