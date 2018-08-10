//
//  ImagesLibraryView.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 04/05/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class ImagesLibraryView: UIView {
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let space: CGFloat = 5.0
        let widthAndHeight = (UIScreen.main.bounds.width - space*4)/3
        flowLayout.itemSize = CGSize(width: widthAndHeight, height: widthAndHeight)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.sectionInset.left = space
        flowLayout.sectionInset.right = space
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .black
        return cv
    }()
    
    let spinner = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(collectionView)
        addSubview(spinner)
        workWithConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func workWithConstraints() {
        collectionViewConstraints()
        spinnerConstraints()
    }
    
    private func collectionViewConstraints() {
        collectionView.topAnchor.constraint(equalTo: collectionView.superview!.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: collectionView.superview!.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: collectionView.superview!.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: collectionView.superview!.leftAnchor).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func spinnerConstraints() {
        spinner.centerXAnchor.constraint(equalTo: spinner.superview!.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: spinner.superview!.centerYAnchor).isActive = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
