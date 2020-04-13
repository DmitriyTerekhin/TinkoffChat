//
//  ProfileView.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/26/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "placeholder-user")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let addPhotoButton: AddPhotoButton = {
        let btn = AddPhotoButton()
        btn.isEnabled = false
        btn.clipsToBounds = true
        return btn
    }()
    
    let nameTextField: UITextField = {
        let txtF = UITextField()
        txtF.font = UIFont.boldSystemFont(ofSize: 25)
        txtF.isEnabled = false
        txtF.text = "Ваше имя"
        txtF.textColor = .lightGray
        txtF.backgroundColor = .white
        return txtF
    }()
    
    let someInfoAboutUserTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Информация о себе"
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .lightGray
        textView.backgroundColor = .white
        return textView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.isHidden = true
        return ai
    }()
    
    let editButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Редактировать", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        btn.borderWidth = 1
        btn.borderColor = .black
        btn.cornerRadius = 8
        btn.setTitleColor(.black, for: .normal)
        btn.layer.masksToBounds = true
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview(addPhotoButton)
        addSubview(nameTextField)
        addSubview(someInfoAboutUserTextView)
        addSubview(editButton)
        addSubview(activityIndicator)
        workWithConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func workWithConstraints() {
        addPhotoButtonConstraints()
        profileImageViewConstraints()
        nameTextFieldConstraints()
        someInfoAboutMeConstraints()
        editButtonConstraints()
        activityIndicatorConstraints()
    }
    
    private func nameTextFieldConstraints() {
        nameTextField.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 29).isActive = true
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addPhotoButtonConstraints() {
        addPhotoButton.rightAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        addPhotoButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        addPhotoButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        addPhotoButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func profileImageViewConstraints() {
        profileImageView.topAnchor.constraint(equalTo: profileImageView.superview!.safeAreaLayoutGuide.topAnchor, constant: 9).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: profileImageView.superview!.rightAnchor, constant: -28).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: profileImageView.superview!.centerYAnchor, constant: 30).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: profileImageView.superview!.leftAnchor, constant: 28).isActive = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func someInfoAboutMeConstraints() {
        someInfoAboutUserTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8).isActive = true
        someInfoAboutUserTextView.rightAnchor.constraint(equalTo: nameTextField.rightAnchor).isActive = true
        someInfoAboutUserTextView.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        someInfoAboutUserTextView.bottomAnchor.constraint(equalTo: editButton.topAnchor, constant: -8).isActive = true
        someInfoAboutUserTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func editButtonConstraints() {
        editButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        editButton.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        editButton.rightAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        editButton.bottomAnchor.constraint(equalTo: editButton.superview!.bottomAnchor, constant: -20).isActive = true
        editButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func activityIndicatorConstraints() {
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicator.superview!.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicator.superview!.centerYAnchor).isActive = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }

}
