//
//  UIViewController+Extensions.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 3/29/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayMsg(title : String?, msg : String, style: UIAlertControllerStyle = .alert, additionalAction: UIAlertAction? = nil) {
        
        let ac = UIAlertController.init(title: title,
                                        message: msg, preferredStyle: style)
        ac.addAction(UIAlertAction.init(title: "OK",
                                        style: .default, handler: nil))
        
        if let additionalAct = additionalAction {
            ac.addAction(additionalAct)
        }
        
        DispatchQueue.main.async {
            self.present(ac, animated: true, completion: nil)
        }
    }
    
}
