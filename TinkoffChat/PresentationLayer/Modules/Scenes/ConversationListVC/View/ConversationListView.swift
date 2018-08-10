//
//  ConversationListView.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/26/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class ConversationListView: UIView {
    
    let tableView: UITableView = {
        let tbl = UITableView()
        tbl.sectionHeaderHeight = 40
        tbl.rowHeight = 80
        tbl.showsVerticalScrollIndicator = false
        tbl.tableFooterView = UIView()
        return tbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(tableView)
        workWithConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func workWithConstraints() {
        tableViewConstraints()
    }
    
    private func tableViewConstraints() {
        tableView.topAnchor.constraint(equalTo: tableView.superview!.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: tableView.superview!.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: tableView.superview!.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: tableView.superview!.leftAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

}
