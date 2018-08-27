//
//  LabelAndSwitchTableViewCell.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit


// MARK:- LabelAndSwitchTableViewCellDelegate
protocol LabelAndSwitchTableViewCellDelegate: class {
    func switchDidChange(onCell cell: LabelAndSwitchTableViewCell)
}


// MARK:- LabelAndSwitchTableViewCell
class LabelAndSwitchTableViewCell: UITableViewCell {
    
    // MARK: vars
    var copyText: String {
        get { return copyLabel?.text ?? "" }
        set { copyLabel?.text = newValue }
    }
    
    var isOn: Bool {
        get { return switchControl.isOn }
        set { switchControl.isOn = newValue }
    }
    
    weak var delegate: LabelAndSwitchTableViewCellDelegate?
    
    // MARK: @IBOutlets
    @IBOutlet private weak var copyLabel: UILabel!
    @IBOutlet private weak var switchControl: UISwitch!

}


// MARK:- initialization
extension LabelAndSwitchTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switchControl?.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
    }
}


// MARK:- configure
extension LabelAndSwitchTableViewCell {
    func configure(withText text: String, withInitiallyIsOn isOn: Bool, andDelegate delegate: LabelAndSwitchTableViewCellDelegate? = nil) {
        copyText = text
        self.isOn = isOn
        self.delegate = delegate
    }
}


// MARK:- actions
extension LabelAndSwitchTableViewCell {
    @objc func switchDidChange(_ sender: UISwitch) {
        delegate?.switchDidChange(onCell: self)
    }
}
