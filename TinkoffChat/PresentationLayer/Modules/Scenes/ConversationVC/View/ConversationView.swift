//
//  ConversationView.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/26/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class ConversationView: UIView {
    
    let tableView: UITableView = {
        let tbl = UITableView()
        tbl.rowHeight = UITableViewAutomaticDimension
        tbl.showsVerticalScrollIndicator = false
        tbl.tableFooterView = UIView()
        tbl.contentInset.bottom = 15
        tbl.separatorStyle = .none
        tbl.allowsSelection = false
        tbl.backgroundColor = .white
        return tbl
    }()
    
    let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.isEnabled = true
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    let inputTextField: UITextField = {
        let txtF = UITextField()
        txtF.layer.borderColor = UIColor.lightGray.cgColor
        txtF.layer.borderWidth = 1
        txtF.layer.cornerRadius = 8
        txtF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtF.frame.height))
        txtF.leftViewMode = .always
        txtF.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: txtF.frame.height))
        txtF.rightViewMode = .always
        txtF.textColor = .black
        return txtF
    }()
    
    let titleNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .green
        return lbl
    }()
    
    var sendButtonWidthConstraint = NSLayoutConstraint()
    var sendButtonHeightConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(tableView)
        addSubview(inputTextField)
        addSubview(sendButton)
        workWithConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func workWithConstraints() {
        textFieldConstraints()
        sendButtonConstraints()
        tableViewConstraints()
    }
    
    private func textFieldConstraints() {
        inputTextField.leftAnchor.constraint(equalTo: inputTextField.superview!.leftAnchor, constant: 10).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -10).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: inputTextField.superview!.bottomAnchor, constant: -10).isActive = true
        inputTextField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10).isActive = true
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func sendButtonConstraints() {
        sendButtonHeightConstraint = sendButton.heightAnchor.constraint(equalToConstant: 60)
        sendButtonHeightConstraint.isActive = true
        sendButtonWidthConstraint = sendButton.widthAnchor.constraint(equalToConstant: 60)
        sendButtonWidthConstraint.isActive = true
        sendButton.rightAnchor.constraint(equalTo: sendButton.superview!.rightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: sendButton.superview!.bottomAnchor).isActive = true
        sendButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func tableViewConstraints() {
        tableView.topAnchor.constraint(equalTo: tableView.superview!.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: tableView.superview!.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: sendButton.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: tableView.superview!.leftAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
