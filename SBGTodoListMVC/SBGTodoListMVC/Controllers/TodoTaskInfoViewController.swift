//
//  TodoTaskInfoViewController.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit


// MARK:- TodoTaskInfoDelegate
protocol TodoTaskInfoDelegate: class {
    func createOrUpdate(todoTaskInfo: TodoTaskInfo)
    func delete(todoTaskInfo: TodoTaskInfo)
}


// MARK:- TodoTaskInfoViewController sections
private extension TodoTaskInfoViewController {
    enum TodoTaskInfoSection: TableDataSectionType {
        case title = 0
        case type
        case priority
        case complete
        case delete
        
        var debugName: String {
            switch self {
            case .title: return "title"
            case .type: return "type"
            case .priority: return "priority"
            case .complete: return "complete"
            case .delete: return "delete"
            }
        }
        
        var sectionTitle: String {
            switch self {
            case .title: return ""
            case .type: return "Type"
            case .priority: return "Priority"
            case .complete: return "Completion Status"
            case .delete: return ""
            }
        }
    }
    
    enum TodoTaskInfoItem: TableDataItemType {
        case labelCell = 0
        case textFieldCell
        case segmentedCell
        case labelAndSwitchCell
        case buttonCell
        
        var debugName: String {
            switch self {
            case .labelCell: return "labelCell"
            case .textFieldCell: return "textFieldCell"
            case .segmentedCell: return "segmentedCell"
            case .labelAndSwitchCell: return "labelAndSwitchCell"
            case .buttonCell: return "buttonCell"
            }
        }
    }
    
    func getSectionAndItem(forIndexPath indexPath: IndexPath) -> (TodoTaskInfoSection,TodoTaskInfoItem)? {
        guard let section = TodoTaskInfoSection(rawValue: tableData.section(forIndexPath: indexPath).type) else { return nil }
        guard let item = TodoTaskInfoItem(rawValue: tableData.item(forIndexPath: indexPath).type) else { return nil }
        return (section,item)
    }
}


// MARK:- TodoTaskInfoViewController
class TodoTaskInfoViewController: TableDataViewController {
    
    // MARK: injected vars
    var todoTaskInfo: TodoTaskInfo!
    weak var delegate: TodoTaskInfoDelegate?

    // MARK: vars
    private var isNewTodoTask: Bool = false
    private var edited: Bool = false
    
    private weak var titleTextField: TextFieldTableViewCell!
    private weak var typeSegmentedControl: SegmentedTableViewCell!
    private weak var prioritySegmentedControl: SegmentedTableViewCell!
    private weak var completionStatusLabelAndSwitch: LabelAndSwitchTableViewCell!
    private weak var deleteButton: ButtonTableViewCell!

    // MARK: @IBOutlets
    @IBOutlet weak var todoTaskInfoTableView: UITableView!
    
    // MARK: TableDataViewController generator
    override func generateTableData() {
        debugLog()
        tableData.reset()
        
        // Title
        tableData.sections.append(generateTitleSection())
        
        // Type
        tableData.sections.append(generateTypeSection())
        
        // Priority
        tableData.sections.append(generatePrioritySection())
        
        // Completion Status
        tableData.sections.append(generateCompleteSection())
        
        // Delete
        if isNewTodoTask == false {
            tableData.sections.append(generateDeleteSection())
        }
        
//        debugLog("\n\(tableData)")
    }
    
}


// MARK:- @IBActions
extension TodoTaskInfoViewController {
    private func saveTask() {
        debugLog()
        
        delegate?.createOrUpdate(todoTaskInfo: todoTaskInfo)
        
        if isNewTodoTask {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func deleteTask() {
        debugLog()
        
        delegate?.delete(todoTaskInfo: todoTaskInfo)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancelButtonPressed(_ sender: UIBarButtonItem) {
        debugLog()
        
        if isNewTodoTask {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc private func saveButtonPressed(_ sender: UIBarButtonItem) {
        debugLog()
        
        if todoTaskInfo.title.isEmpty {
            showAlert(withTitle: "Empty Title", withMessage: "Please enter a title for this Todo Task")
        } else {
            saveTask()
        }
    }
}


// MARK:- life cycle
extension TodoTaskInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        determineIfNewTodoTask()
        initializeNavigationButtons()
        updateTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView = todoTaskInfoTableView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateView()
        delay(milliseconds: 200) {
            _ = self.titleTextField?.becomeFirstResponder()
        }
    }
}


// MARK:- initialization
extension TodoTaskInfoViewController {
    private func determineIfNewTodoTask() {
        isNewTodoTask = todoTaskInfo.title.isEmpty
    }
    
    private func initializeNavigationButtons() {
        if isNewTodoTask {
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
            navigationItem.setLeftBarButtonItems([cancelButton], animated: false)
            navigationItem.setRightBarButtonItems([saveButton], animated: false)
        } else {
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
            let updateButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(saveButtonPressed))
            navigationItem.setLeftBarButtonItems([cancelButton], animated: false)
            navigationItem.setRightBarButtonItems([updateButton], animated: false)
        }
    }
    
    private func updateTitle() {
        navigationItem.title = isNewTodoTask ? "Create Todo Task": todoTaskInfo.title
    }
    
    private func initializeTableDataCustomDescription() {
        tableData.customDescription = { [weak self] in "tableData:\n" + (self?.tableData.sections.compactMap({ $0.customDescription() }).joined(separator: "\n") ?? "") }
    }
}


// MARK:- refreshing
extension TodoTaskInfoViewController {
    @objc private func updateView() {
        debugLog()
        generateTableData()
        tableView?.reloadData()
    }
}


// MARK:- navigation
extension TodoTaskInfoViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}


// MARK:- data source generation
extension TodoTaskInfoViewController {
    private func headerText(forSection section: TodoTaskInfoSection) -> OptionalStringGenerator {
        return { section.sectionTitle }
    }
    
    private func headerFont(forSection section: TodoTaskInfoSection) -> UIFontGenerator {
        return { UIFont.systemFont(ofSize: 16.0) }
    }
    
    private func headerHeight(forSection section: TodoTaskInfoSection) -> CGFloatGenerator {
        return { 30.0 }
    }
    
    private func headerTopMargin(forSection section: TodoTaskInfoSection) -> CGFloatGenerator {
        return { 0.0 }
    }
    
    private func headerBottomMargin(forSection section: TodoTaskInfoSection) -> CGFloatGenerator {
        return { 0.0 }
    }
    
    private func footerText(forSection section: TodoTaskInfoSection) -> OptionalStringGenerator {
        return { "" }
    }
    
    private func footerFont(forSection section: TodoTaskInfoSection) -> UIFontGenerator {
        return { UIFont.systemFont(ofSize: 16.0) }
    }
    
    private func footerHeight(forSection section: TodoTaskInfoSection) -> CGFloatGenerator {
        return { 30.0 }
    }
    
    private func footerTopMargin(forSection section: TodoTaskInfoSection) -> CGFloatGenerator {
        return { 0.0 }
    }
    
    private func footerBottomMargin(forSection section: TodoTaskInfoSection) -> CGFloatGenerator {
        return { 10.0 }
    }
    
    private func generateLabelCellItem() -> Item {
        let type = TodoTaskInfoItem.labelCell
        let identifier: StringGenerator = { "labelCell" }
        let estimatedRowHeight: CGFloatGenerator = { 44.0 }
        let rowHeight: CGFloatGenerator = { 44.0 }
        let customDescription: OptionalStringGenerator = { "item type: \(type.debugName), identifier: \(identifier()), estimatedRowHeight: \(estimatedRowHeight()), rowHeight: \(rowHeight())" }
        return Item(type: type.rawValue, identifier: identifier, estimatedRowHeight: estimatedRowHeight, rowHeight: rowHeight, customDescription: customDescription)
    }
    
    private func generateTextFieldCellItem() -> Item {
        let type = TodoTaskInfoItem.textFieldCell
        let identifier: StringGenerator = { "textFieldCell" }
        let estimatedRowHeight: CGFloatGenerator = { 44.0 }
        let rowHeight: CGFloatGenerator = { 44.0 }
        let customDescription: OptionalStringGenerator = { "item type: \(type.debugName), identifier: \(identifier()), estimatedRowHeight: \(estimatedRowHeight()), rowHeight: \(rowHeight())" }
        return Item(type: type.rawValue, identifier: identifier, estimatedRowHeight: estimatedRowHeight, rowHeight: rowHeight, customDescription: customDescription)
    }
    
    private func generateSegmentedCellItem() -> Item {
        let type = TodoTaskInfoItem.segmentedCell
        let identifier: StringGenerator = { "segmentedCell" }
        let estimatedRowHeight: CGFloatGenerator = { 44.0 }
        let rowHeight: CGFloatGenerator = { 44.0 }
        let customDescription: OptionalStringGenerator = { "item type: \(type.debugName), identifier: \(identifier()), estimatedRowHeight: \(estimatedRowHeight()), rowHeight: \(rowHeight())" }
        return Item(type: type.rawValue, identifier: identifier, estimatedRowHeight: estimatedRowHeight, rowHeight: rowHeight, customDescription: customDescription)
    }
    
    private func generateLabelAndSwitchCellItem() -> Item {
        let type = TodoTaskInfoItem.labelAndSwitchCell
        let identifier: StringGenerator = { "labelAndSwitchCell" }
        let estimatedRowHeight: CGFloatGenerator = { 44.0 }
        let rowHeight: CGFloatGenerator = { 44.0 }
        let customDescription: OptionalStringGenerator = { "item type: \(type.debugName), identifier: \(identifier()), estimatedRowHeight: \(estimatedRowHeight()), rowHeight: \(rowHeight())" }
        return Item(type: type.rawValue, identifier: identifier, estimatedRowHeight: estimatedRowHeight, rowHeight: rowHeight, customDescription: customDescription)
    }
    
    private func generateButtonCellItem() -> Item {
        let type = TodoTaskInfoItem.buttonCell
        let identifier: StringGenerator = { "buttonCell" }
        let estimatedRowHeight: CGFloatGenerator = { 44.0 }
        let rowHeight: CGFloatGenerator = { 84.0 }
        let customDescription: OptionalStringGenerator = { "item type: \(type.debugName), identifier: \(identifier()), estimatedRowHeight: \(estimatedRowHeight()), rowHeight: \(rowHeight())" }
        return Item(type: type.rawValue, identifier: identifier, estimatedRowHeight: estimatedRowHeight, rowHeight: rowHeight, customDescription: customDescription)
    }
    
    private func generateSection(forType type: TodoTaskInfoSection, andItems items: [Item]) -> Section {
        let headerText: OptionalStringGenerator = self.headerText(forSection: type)
        let headerFont: UIFontGenerator = self.headerFont(forSection: type)
        let headerHeight: CGFloatGenerator = self.headerHeight(forSection: type)
        let headerTopMargin: CGFloatGenerator = self.headerTopMargin(forSection: type)
        let headerBottomMargin: CGFloatGenerator = self.headerBottomMargin(forSection: type)
        
        let footerText: OptionalStringGenerator = self.footerText(forSection: type)
        let footerFont: UIFontGenerator = self.footerFont(forSection: type)
        let footerHeight: CGFloatGenerator = self.footerHeight(forSection: type)
        let footerTopMargin: CGFloatGenerator = self.footerTopMargin(forSection: type)
        let footerBottomMargin: CGFloatGenerator = self.footerBottomMargin(forSection: type)
        
        let customDescription: OptionalStringGenerator = { "section type: \(type)\n\t" + items.compactMap({ $0.customDescription() }).joined(separator: "\n\t") }
        
        return Section(type: type.rawValue
            , headerText: headerText
            , headerFont: headerFont
            , headerHeight: headerHeight
            , headerTopMargin: headerTopMargin
            , headerBottomMargin: headerBottomMargin
            , footerText: footerText
            , footerFont: footerFont
            , footerHeight: footerHeight
            , footerTopMargin: footerTopMargin
            , footerBottomMargin: footerBottomMargin
            , items: items
            , customDescription: customDescription
        )
    }
    
    private func generateTitleSection() -> Section {
        let items: [Item] = {
            var items: [Item] = []
            
            items.append(generateTextFieldCellItem())
            
            return items
        }()
        return generateSection(forType: .title, andItems: items)
    }
    
    private func generateTypeSection() -> Section {
        let items: [Item] = {
            var items: [Item] = []
            
            items.append(generateSegmentedCellItem())
            
            return items
        }()
        return generateSection(forType: .type, andItems: items)
    }
    
    private func generatePrioritySection() -> Section {
        let items: [Item] = {
            var items: [Item] = []
            
            items.append(generateSegmentedCellItem())
            
            return items
        }()
        return generateSection(forType: .priority, andItems: items)
    }
    
    private func generateCompleteSection() -> Section {
        let items: [Item] = {
            var items: [Item] = []
            
            items.append(generateLabelAndSwitchCellItem())
            
            return items
        }()
        return generateSection(forType: .complete, andItems: items)
    }
    
    private func generateDeleteSection() -> Section {
        let items: [Item] = {
            var items: [Item] = []
            
            items.append(generateButtonCellItem())
            
            return items
        }()
        return generateSection(forType: .delete, andItems: items)
    }
}


// MARK:- UITableViewDataSource
extension TodoTaskInfoViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionAndItem = getSectionAndItem(forIndexPath: indexPath) else { return UITableViewCell() }
        let tableDataItem = tableData.item(forIndexPath: indexPath)
        
        switch sectionAndItem {
        case let (section,item) where section == .title && item == .textFieldCell:
            // MARK: Title
            let cell: TextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableDataItem.identifier(), for: indexPath) as! TextFieldTableViewCell
            cell.configure(withText: todoTaskInfo.title, withPlaceholderText: "Title Required", andDelegate: self)
            titleTextField = cell
            return cell
        case let (section,item) where section == .type && item == .segmentedCell:
            // MARK: Type
            let cell: SegmentedTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableDataItem.identifier(), for: indexPath) as! SegmentedTableViewCell
            cell.configure(withSelectionOptions: TodoTaskInfo.TodoTaskType.allCases.reversed().map { $0.name }, withInitialSelection: todoTaskInfo.type.name, andDelegate: self)
            typeSegmentedControl = cell
            return cell
        case let (section,item) where section == .priority && item == .segmentedCell:
            // MARK: Priority
            let cell: SegmentedTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableDataItem.identifier(), for: indexPath) as! SegmentedTableViewCell
            cell.configure(withSelectionOptions: TodoTaskInfo.TodoTaskPriority.allCases.reversed().map { $0.name }, withInitialSelection: todoTaskInfo.priority.name, andDelegate: self)
            prioritySegmentedControl = cell
            return cell
        case let (section,item) where section == .complete && item == .labelAndSwitchCell:
            // MARK: Completion Status
            let cell: LabelAndSwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableDataItem.identifier(), for: indexPath) as! LabelAndSwitchTableViewCell
            cell.configure(withText: "Completed?", withInitiallyIsOn: todoTaskInfo.completed, andDelegate: self)
            completionStatusLabelAndSwitch = cell
            return cell
        case let (section,item) where section == .delete && item == .buttonCell:
            // MARK: Delete
            let cell: ButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableDataItem.identifier(), for: indexPath) as! ButtonTableViewCell
            cell.configure(withText: "Delete", withBackgroundColor: UIColor.clear, withTextColor: UIColor.red, andDelegate: self)
            deleteButton = cell
            return cell
        default:
            fatalError()
        }
    }
}


// MARK:- UITableViewDelegate
extension TodoTaskInfoViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


// MARK:- TextFieldTableViewCellDelegate
extension TodoTaskInfoViewController: TextFieldTableViewCellDelegate {
    func textFieldDidChange(onCell cell: TextFieldTableViewCell) {
        debugLog()
        edited = true
        
        todoTaskInfo.title = cell.textFieldText
        updateTitle()
    }
}


// MARK:- SegmentedTableViewCellDelegate
extension TodoTaskInfoViewController: SegmentedTableViewCellDelegate {
    func segmentSelectionDidChange(onCell cell: SegmentedTableViewCell) {
        debugLog()
        edited = true
        
        switch cell {
        case typeSegmentedControl: todoTaskInfo.type = TodoTaskInfo.TodoTaskType(name: cell.currentSelection)
        case prioritySegmentedControl: todoTaskInfo.priority = TodoTaskInfo.TodoTaskPriority(name: cell.currentSelection)
        default: return
        }
    }
}


// MARK:- LabelAndSwitchTableViewCellDelegate
extension TodoTaskInfoViewController: LabelAndSwitchTableViewCellDelegate {
    func switchDidChange(onCell cell: LabelAndSwitchTableViewCell) {
        debugLog()
        edited = true
        
        todoTaskInfo.completed = cell.isOn
    }
}


// MARK:- ButtonTableViewCellDelegate
extension TodoTaskInfoViewController: ButtonTableViewCellDelegate {
    func buttonWasPressed(onCell cell: ButtonTableViewCell) {
        debugLog()

        showDestructiveAlert(withTitle: "Delete Task", withMessage: "Are you sure you want to delete this Todo Task?") { [weak self] in
            self?.deleteTask()
        }
    }
}
