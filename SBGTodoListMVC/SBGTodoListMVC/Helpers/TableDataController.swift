//
//  TableDataController.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/23/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit


// MARK:- TableDataViewController
class TableDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableData = TableData()
    var tableView: UITableView?
    
    func generateTableData() {
    }
    
}


// MARK:- TableData Declarations
extension TableDataViewController {
    typealias OptionalStringGenerator = () -> String?
    typealias StringGenerator = () -> String
    typealias CGFloatGenerator = () -> CGFloat
    typealias UIFontGenerator = () -> UIFont
    
    typealias TableDataSectionType = IntegerLiteralType
    typealias TableDataItemType = IntegerLiteralType
    
    struct Section: CustomStringConvertible {
        var type: TableDataSectionType
        
        var headerText: OptionalStringGenerator = { nil }
        var headerFont: UIFontGenerator = { UIFont.systemFont(ofSize: 14.0) }
        var headerHeight: CGFloatGenerator = { 30.0 }
        var headerTopMargin: CGFloatGenerator = { 0.0 }
        var headerBottomMargin: CGFloatGenerator = { 0.0 }
        
        var footerText: OptionalStringGenerator = { nil }
        var footerFont: UIFontGenerator = { UIFont.systemFont(ofSize: 12.0) }
        var footerHeight: CGFloatGenerator = { 30.0 }
        var footerTopMargin: CGFloatGenerator = { 0.0 }
        var footerBottomMargin: CGFloatGenerator = { 0.0 }
        
        var items: [Item] = []
        
        var customDescription: OptionalStringGenerator = { nil }
        var description: String {
            return customDescription() ?? "Section Custom Description Not implemented"
        }
    }
    
    struct Item: CustomStringConvertible {
        var type: TableDataItemType
        var identifier: StringGenerator = { "" }
        var estimatedRowHeight: CGFloatGenerator = { 44.0 }
        var rowHeight: CGFloatGenerator = { 44.0 }
        
        var customDescription: OptionalStringGenerator = { nil }
        var description: String {
            return customDescription() ?? "Item Custom Description Not implemented"
        }
    }
    
    struct TableData: CustomStringConvertible {
        var sections = [Section]()
        
        mutating func reset() {
            sections = [Section]()
        }
        
        func section(forIndexPath indexPath: IndexPath) -> Section {
            return sections[indexPath.section]
        }
        
        func section(forSection section: Int) -> Section {
            return sections[section]
        }
        
        func headerText(forSection section: Int) -> String? {
            return sections[section].headerText()
        }
        
        func footerText(forSection section: Int) -> String? {
            return sections[section].footerText()
        }
        
        func item(forIndexPath indexPath: IndexPath) -> Item {
            return sections[indexPath.section].items[indexPath.row]
        }
        
        func cellIdentifier(forIndexPath indexPath: IndexPath) -> String {
            return item(forIndexPath: indexPath).identifier()
        }
        
        func estimatedRowHeight(forIndexPath indexPath: IndexPath) -> CGFloat {
            return item(forIndexPath: indexPath).estimatedRowHeight()
        }
        
        func rowHeight(forIndexPath indexPath: IndexPath) -> CGFloat {
            return item(forIndexPath: indexPath).rowHeight()
        }
        
        var customDescription: OptionalStringGenerator = { nil }
        var description: String {
            return customDescription() ?? "Table Data Custom Description Not implemented"
        }
    }
}

// MARK:- TableDataViewController.Section convenience initializers
extension TableDataViewController.Section {
    init(type: TableDataViewController.TableDataSectionType) {
        self.type = type
    }
    
    init(type: TableDataViewController.TableDataSectionType
        , headerText: TableDataViewController.OptionalStringGenerator? = nil
        , headerFont: TableDataViewController.UIFontGenerator? = nil
        , headerHeight: TableDataViewController.CGFloatGenerator? = nil
        , headerTopMargin: TableDataViewController.CGFloatGenerator? = nil
        , headerBottomMargin: TableDataViewController.CGFloatGenerator? = nil
        , footerText: TableDataViewController.OptionalStringGenerator? = nil
        , footerFont: TableDataViewController.UIFontGenerator? = nil
        , footerHeight: TableDataViewController.CGFloatGenerator? = nil
        , footerTopMargin: TableDataViewController.CGFloatGenerator? = nil
        , footerBottomMargin: TableDataViewController.CGFloatGenerator? = nil
        , items: [TableDataViewController.Item]? = nil
        , customDescription: TableDataViewController.OptionalStringGenerator? = nil
        ) {
        self.type = type
        if let headerText = headerText { self.headerText = headerText }
        if let headerFont = headerFont { self.headerFont = headerFont }
        if let headerHeight = headerHeight { self.headerHeight = headerHeight }
        if let headerTopMargin = headerTopMargin { self.headerTopMargin = headerTopMargin }
        if let headerBottomMargin = headerBottomMargin { self.headerBottomMargin = headerBottomMargin }
        if let footerText = footerText { self.footerText = footerText }
        if let footerFont = footerFont { self.footerFont = footerFont }
        if let footerHeight = footerHeight { self.footerHeight = footerHeight }
        if let footerTopMargin = footerTopMargin { self.footerTopMargin = footerTopMargin }
        if let footerBottomMargin = footerBottomMargin { self.footerBottomMargin = footerBottomMargin }
        if let items = items { self.items = items }
        if let customDescription = customDescription { self.customDescription = customDescription }
    }
}


// MARK:- TableDataViewController.Item convenience initializers
extension TableDataViewController.Item {
    init(type: TableDataViewController.TableDataItemType
        , identifier: TableDataViewController.StringGenerator? = nil
        , estimatedRowHeight: TableDataViewController.CGFloatGenerator? = nil
        , rowHeight: TableDataViewController.CGFloatGenerator? = nil
        ) {
        self.type = type
        if let identifier = identifier { self.identifier = identifier }
        if let estimatedRowHeight = estimatedRowHeight { self.estimatedRowHeight = estimatedRowHeight }
        if let rowHeight = rowHeight { self.rowHeight = rowHeight }
    }
}


// MARK:- UITableViewDataSource
extension TableDataViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = tableData.sections[section]
        return section.items.count
    }
    
    /// Should be overridden by subclass
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData.sections[section].headerText()
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return tableData.sections[section].footerText()
    }
}


// MARK:- UITableViewDelegate
extension TableDataViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableData.rowHeight(forIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = tableData.sections[section]
        if let headerText = section.headerText() {
            let height = headerText.isEmpty == false ? section.headerHeight() : 0.0001
            let topMargin = section.headerTopMargin()
            let bottomMargin = section.headerBottomMargin()
            return height + topMargin + bottomMargin
        } else {
            return 0.0001
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = tableData.sections[section]
        if let footerText = section.footerText() {
            let height = footerText.isEmpty == false ? section.footerHeight() : 0.0001
            let topMargin = section.footerTopMargin()
            let bottomMargin = section.footerBottomMargin()
            return height + topMargin + bottomMargin
        } else {
            return 0.0001
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    private struct SectionColors {
        var backdrop: UIColor
        var background: UIColor
        var text: UIColor
    }
    
    private func generateTableViewHeaderOrFooterView(tableView: UITableView, withTitle title: String?, font: UIFont, colors: SectionColors, height: CGFloat, topMargin: CGFloat, andBottomMargin bottomMargin: CGFloat) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: height + topMargin + bottomMargin))
        view.backgroundColor = colors.backdrop
        
        if let title = title, title.isEmpty == false {
            let labelView = UIView(frame: CGRect(x: 0, y: topMargin, width: tableView.frame.width, height: height))
            labelView.backgroundColor = colors.background
            
            let leftLabelMargin: CGFloat = 10.0
            let rightLabelMargin: CGFloat = 10.0
            let label = UILabel(frame: CGRect(x: leftLabelMargin, y: 0, width: labelView.frame.width - rightLabelMargin, height: labelView.frame.height))
            label.textColor = colors.text
            label.font = font
            label.text = "\(title)"
            label.backgroundColor = UIColor.clear
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            
            labelView.addSubview(label)
            view.addSubview(labelView)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableDataSection = tableData.sections[section]
        let title = tableDataSection.headerText()
        let font = tableDataSection.headerFont()
        let colors = SectionColors(backdrop: UIColor.white, background: UIColor.init(white: 0.95, alpha: 1.0), text: UIColor.black)
        let height = (tableDataSection.headerText() ?? "").isEmpty == false ? tableDataSection.headerHeight() : 0.0
        let topMargin = tableDataSection.headerTopMargin()
        let bottomMargin = tableDataSection.headerBottomMargin()
        
        return generateTableViewHeaderOrFooterView(tableView: tableView, withTitle: title, font: font, colors: colors, height: height, topMargin: topMargin, andBottomMargin: bottomMargin)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let tableDataSection = tableData.sections[section]
        let title = tableDataSection.footerText()
        let font = tableDataSection.footerFont()
        let colors = SectionColors(backdrop: UIColor.white, background: UIColor.white, text: UIColor.black)
        let height = (tableDataSection.footerText() ?? "").isEmpty == false ? tableDataSection.footerHeight() : 0.0
        let topMargin = tableDataSection.footerTopMargin()
        let bottomMargin = tableDataSection.footerBottomMargin()
        
        return generateTableViewHeaderOrFooterView(tableView: tableView, withTitle: title, font: font, colors: colors, height: height, topMargin: topMargin, andBottomMargin: bottomMargin)
    }
}
