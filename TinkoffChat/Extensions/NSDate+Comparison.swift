//
//  NSDate+Comparison.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 13/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

//extension NSDate: Equatable {}
extension NSDate: Comparable {}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqual(to: rhs as Date)
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs as Date) == .orderedAscending
}
