//
//  SegmentedTableViewCell.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit


// MARK:- SegmentedTableViewCellDelegate
protocol SegmentedTableViewCellDelegate: class {
    func segmentSelectionDidChange(onCell cell: SegmentedTableViewCell)
}


// MARK:- SegmentedTableViewCell
class SegmentedTableViewCell: UITableViewCell {
    
    // MARK: vars
    private var selectionIndex: Int {
        return segmentedControl?.selectedSegmentIndex ?? 0
    }
    
    var currentSelection: String {
        get { return segmentedControl?.titleForSegment(at: selectionIndex) ?? "" }
    }
    
    weak var delegate: SegmentedTableViewCellDelegate?
    
    // MARK: @IBOutlets
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
}


// MARK:- initialization
extension SegmentedTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        segmentedControl.removeAllSegments()
        segmentedControl?.addTarget(self, action: #selector(segmentSelectionDidChange), for: .valueChanged)
    }
}


// MARK:- configure
extension SegmentedTableViewCell {
    func configure(withSelectionOptions options: [String], withInitialSelection initialSelection: String, andDelegate delegate: SegmentedTableViewCellDelegate? = nil) {
        var initialSelectionIndex: Int = 0

        for option in options {
            segmentedControl.insertSegment(withTitle: option, at: 0, animated: false)
        }
        
        for (index,option) in options.reversed().enumerated() {
            if initialSelection == option {
                initialSelectionIndex = index
            }
        }
        
        segmentedControl.selectedSegmentIndex = initialSelectionIndex
        self.delegate = delegate
    }
}


// MARK:- actions
extension SegmentedTableViewCell {
    @objc func segmentSelectionDidChange(_ sender: UISegmentedControl) {
        delegate?.segmentSelectionDidChange(onCell: self)
    }
}
