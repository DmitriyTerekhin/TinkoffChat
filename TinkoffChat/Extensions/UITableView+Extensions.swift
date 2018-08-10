//
//  UITableView+Extensions.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 09/08/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height + contentInset.bottom
        setContentOffset(CGPoint(x: 0, y: (y<0) ? 0 : y), animated: animated)
    }
}
