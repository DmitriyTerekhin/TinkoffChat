//
//  Class+Extensions.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 12.04.2020.
//  Copyright © 2020 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}
