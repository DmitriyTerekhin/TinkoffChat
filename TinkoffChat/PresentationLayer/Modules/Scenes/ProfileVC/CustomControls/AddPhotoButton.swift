//
//  AddPhotoButton.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 06/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

@IBDesignable
class AddPhotoButton: UIButton, NibLoadable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    //For using custom view in IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
}
