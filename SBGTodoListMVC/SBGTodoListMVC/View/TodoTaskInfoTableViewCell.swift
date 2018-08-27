//
//  TodoTaskInfoTableViewCell.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit


// MARK:- TodoTaskInfoTableViewCell
class TodoTaskInfoTableViewCell: UITableViewCell {
    
    // MARK: vars
    var title: String? {
        get { return titleLabel?.text }
        set { titleLabel?.text = newValue }
    }
    
    // MARK: @IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    

}


// MARK:- configure
extension TodoTaskInfoTableViewCell {
    func configure(fromTodoTaskInfo todoTaskInfo: TodoTaskInfo) {
        title = todoTaskInfo.title
    }
}
