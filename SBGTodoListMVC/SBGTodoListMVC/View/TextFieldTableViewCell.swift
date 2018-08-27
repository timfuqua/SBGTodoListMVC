//
//  TextFieldTableViewCell.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit


// MARK:- TextFieldTableViewCellDelegate
protocol TextFieldTableViewCellDelegate: class {
    func textFieldDidChange(onCell cell: TextFieldTableViewCell)
}


// MARK:- TextFieldTableViewCell
class TextFieldTableViewCell: UITableViewCell {
    
    // MARK: vars
    var textFieldText: String {
        get { return textField?.text ?? "" }
        set { textField?.text = newValue }
    }
    
    var textFieldPlaceholderText: String? {
        get { return textField?.placeholder }
        set { textField?.placeholder = newValue }
    }
    
    weak var delegate: TextFieldTableViewCellDelegate?
    
    // MARK: @IBOutlets
    @IBOutlet private weak var textField: UITextField!
    
}


// MARK:- initialization
extension TextFieldTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField?.delegate = self
        textField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}


// MARK:- first responder
extension TextFieldTableViewCell {
    override func becomeFirstResponder() -> Bool {
        return textField?.becomeFirstResponder() == true
    }
    
    override func resignFirstResponder() -> Bool {
        return textField?.resignFirstResponder() == true
    }
}


// MARK:- configure
extension TextFieldTableViewCell {
    func configure(withText text: String, withPlaceholderText placeholder: String, andDelegate delegate: TextFieldTableViewCellDelegate? = nil) {
        textFieldText = text
        textFieldPlaceholderText = placeholder
        self.delegate = delegate
    }
}


// MARK:- UITextFieldDelegate
extension TextFieldTableViewCell: UITextFieldDelegate {
    @objc func textFieldDidChange(_ sender: UITextField) {
        delegate?.textFieldDidChange(onCell: self)
    }
}
