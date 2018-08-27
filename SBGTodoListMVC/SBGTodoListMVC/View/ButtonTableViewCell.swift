//
//  ButtonTableViewCell.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit


// MARK:- ButtonTableViewCellDelegate
protocol ButtonTableViewCellDelegate: class {
    func buttonWasPressed(onCell cell: ButtonTableViewCell)
}


// MARK:- ButtonTableViewCell
class ButtonTableViewCell: UITableViewCell {
    
    // MARK: vars
    var buttonText: String {
        get { return button.title(for: .normal) ?? "" }
        set { button.setTitle(newValue, for: .normal) }
    }
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    // MARK: @IBOutlets
    @IBOutlet private weak var button: UIButton!
    
}


// MARK:- initialization
extension ButtonTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        button?.addTarget(self, action: #selector(buttonWasPressed), for: .touchUpInside)
    }
}


// MARK:- configure
extension ButtonTableViewCell {
    func configure(withText text: String, withBackgroundColor backgroundColor: UIColor, withTextColor textColor: UIColor, andDelegate delegate: ButtonTableViewCellDelegate? = nil) {
        buttonText = text
        button?.backgroundColor = backgroundColor
        button?.setTitleColor(textColor, for: .normal)
        self.delegate = delegate
    }
}


// MARK:- UITextFieldDelegate
extension ButtonTableViewCell: UITextFieldDelegate {
    @objc func buttonWasPressed(_ sender: UIButton) {
        delegate?.buttonWasPressed(onCell: self)
    }
}
