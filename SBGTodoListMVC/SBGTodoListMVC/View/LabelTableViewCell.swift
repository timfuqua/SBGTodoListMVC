//
//  LabelTableViewCell.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit


// MARK:- LabelTableViewCell
class LabelTableViewCell: UITableViewCell {
    
    // MARK: vars
    var copyText: String {
        get { return copyLabel?.text ?? "" }
        set { copyLabel?.text = newValue }
    }
    
    // MARK: @IBOutlets
    @IBOutlet private weak var copyLabel: UILabel!
    
}


// MARK:- configure
extension LabelTableViewCell {
    func configure(withText text: String) {
        copyText = text
    }
}
