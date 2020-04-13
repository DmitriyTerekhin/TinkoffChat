//
//  ImagesLibraryCollectionViewCell.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 04/05/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class ImagesLibraryCollectionViewCell: UICollectionViewCell, ReusableView {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "placeholder-image")
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        contentView.addSubview(imageView)
        workWithConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = #imageLiteral(resourceName: "placeholder-image")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func workWithConstraints() {
        imageViewConstraints()
    }
    
    private func imageViewConstraints() {
        imageView.topAnchor.constraint(equalTo: imageView.superview!.topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: imageView.superview!.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageView.superview!.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: imageView.superview!.leftAnchor).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
}
