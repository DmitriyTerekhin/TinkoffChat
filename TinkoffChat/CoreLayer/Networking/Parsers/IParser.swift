//
//  IParser.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 07/05/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}
