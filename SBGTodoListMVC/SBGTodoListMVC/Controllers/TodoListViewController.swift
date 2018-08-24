//
//  TodoListViewController.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/23/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit
import CoreData


// MARK:- TodoListViewController sections
private extension TodoListViewController {
    enum TodoListSection: TableDataSectionType {
        case noTasks = 0
        case uncompleted
        case completed

        var debugName: String {
            switch self {
            case .noTasks: return "noTasks"
            case .uncompleted: return "uncompleted"
            case .completed: return "completed"
            }
        }
        
        var sectionTitle: String {
            switch self {
            case .noTasks: return ""
            case .uncompleted: return "Uncompleted Tasks"
            case .completed: return "Completed Tasks"
            }
        }
    }
    
    enum TodoListItem: TableDataItemType {
        case noTasks = 0
        case task
        
        var debugName: String {
            switch self {
            case .noTasks: return "noTasks"
            case .task: return "task"
            }
        }
    }
    
    func getSectionAndItem(forIndexPath indexPath: IndexPath) -> (TodoListSection,TodoListItem)? {
        guard let section = TodoListSection(rawValue: tableData.section(forIndexPath: indexPath).type) else { return nil }
        guard let item = TodoListItem(rawValue: tableData.item(forIndexPath: indexPath).type) else { return nil }
        return (section,item)
    }
}


// MARK:- TodoListViewController
class TodoListViewController: TableDataViewController {
    
    // MARK: vars
    private var allTasks: [NSManagedObject] = [] {
        didSet {
            let separatedTasks = allTasks.separate(predicate: { (($0.value(forKey: "title") as? String) ?? "").count % 2 == 0 })
            uncompletedTasks = separatedTasks.matching
            completedTasks = separatedTasks.notMatching
            
            if allTasks.isEmpty && tableView?.isEditing == true {
                exitEditMode()
            }
            
            updateView()
        }
    }
    private var uncompletedTasks: [NSManagedObject] = []
    private var completedTasks: [NSManagedObject] = []

    // MARK: @IBOutlets
    @IBOutlet private weak var todoListTableView: UITableView!
    
    // MARK: TableDataViewController generator
    override func generateTableData() {
        debugLog()
        tableData.reset()
        
        if allTasks.isEmpty {
            tableData.sections.append(generateNoTasksSection())
        } else {
            tableData.sections.append(generateUncompletedSection())
            tableData.sections.append(generateCompletedSection())
        }

//        debugLog("\n\(tableData)")
    }

}


// MARK:- @IBActions
extension TodoListViewController {
    private func enterEditMode() {
        tableView?.setEditing(true, animated: true)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        let removeAllButton = UIBarButtonItem(title: "Remove All", style: .plain, target: self, action: #selector(removeAllButtonPressed))
        navigationItem.leftBarButtonItems = [cancelButton]
        navigationItem.rightBarButtonItems = [removeAllButton]
    }
    
    private func exitEditMode() {
        tableView?.setEditing(false, animated: true)
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.leftBarButtonItems = allTasks.isEmpty ? [] : [editButton]
        navigationItem.rightBarButtonItems = [addButton]
    }
    
    private func newTask() {
        let alert = UIAlertController(title: "New Task", message: "Add a new task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first, let taskTitle = textField.text else { return }
            self.saveTask(withTitle: taskTitle)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func saveTask(withTitle title: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TodoTask", in: managedContext)!
        let todoTask = NSManagedObject(entity: entity, insertInto: managedContext)
        
        todoTask.setValue(title, forKey: "title")
        
        do {
            try managedContext.save()
            allTasks.append(todoTask)
        } catch let error as NSError {
            debugLog("\(error)")
        }
    }
    
    private func remove(_ task: NSManagedObject) {
        if let taskObjectIndex = allTasks.index(of: task) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(task)
            allTasks.remove(at: taskObjectIndex)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                debugLog("\(error)")
            }
        }
    }
    
    @objc private func removeAllTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoTask")
        let deleteAllRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteAllRequest)
            try managedContext.save()
            allTasks.removeAll()
        } catch let error as NSError {
            debugLog("\(error)")
        }
    }
    
    @objc private func editButtonPressed(_ sender: UIBarButtonItem) {
        debugLog()
        enterEditMode()
    }
    
    @objc private func cancelButtonPressed(_ sender: UIBarButtonItem) {
        debugLog()
        exitEditMode()
    }
    
    @objc private func addButtonPressed(_ sender: UIBarButtonItem) {
        debugLog()
        newTask()
    }
    
    @objc private func removeAllButtonPressed(_ sender: UIBarButtonItem) {
        debugLog()
        
        let alert = UIAlertController(title: "Remove All Tasks", message: "Are you sure you want to remove all tasks?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [unowned self] action in
            self.removeAllTasks()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}


// MARK:- life cycle
extension TodoListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        debugLog()
        
        initializeDataSource()
        initializeTableDataCustomDescription()
        intializeTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugLog()
        
        addObservers()
        tableView = todoListTableView
        
        exitEditMode()
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugLog()
        
        removeObservers()
    }
}


// MARK:- initialization
extension TodoListViewController {
    private func intializeTitle() {
        navigationItem.title = "Todo List"
    }
    
    private func initializeDataSource() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TodoTask")

        do {
            allTasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            debugLog("\(error)")
        }
    }
    
    private func initializeTableDataCustomDescription() {
        tableData.customDescription = { [weak self] in "tableData:\n" + (self?.tableData.sections.compactMap({ $0.customDescription() }).joined(separator: "\n") ?? "") }
    }
    
    private func addObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
}


// MARK:- refreshing
extension TodoListViewController {
    @objc private func updateView() {
        debugLog()
        generateTableData()
        tableView?.reloadData()
    }
}


// MARK:- data source generation
extension TodoListViewController {
    private func headerText(forSection section: TodoListSection) -> OptionalStringGenerator {
        return { section.sectionTitle }
    }
    
    private func headerFont(forSection section: TodoListSection) -> UIFontGenerator {
        return { UIFont.systemFont(ofSize: 16.0) }
    }
    
    private func headerHeight(forSection section: TodoListSection) -> CGFloatGenerator {
        return { 30.0 }
    }
    
    private func headerTopMargin(forSection section: TodoListSection) -> CGFloatGenerator {
        return { 0.0 }
    }
    
    private func headerBottomMargin(forSection section: TodoListSection) -> CGFloatGenerator {
        return { 0.0 }
    }
    
    private func footerText(forSection section: TodoListSection) -> OptionalStringGenerator {
        return { nil }
    }
    
    private func footerFont(forSection section: TodoListSection) -> UIFontGenerator {
        return { UIFont.systemFont(ofSize: 16.0) }
    }
    
    private func footerHeight(forSection section: TodoListSection) -> CGFloatGenerator {
        return { 30.0 }
    }
    
    private func footerTopMargin(forSection section: TodoListSection) -> CGFloatGenerator {
        return { 0.0 }
    }
    
    private func footerBottomMargin(forSection section: TodoListSection) -> CGFloatGenerator {
        return { 10.0 }
    }
    
    private func generateNoTasksItem() -> Item {
        let type = TodoListItem.noTasks
        let identifier: StringGenerator = { "noTasksCell" }
        let estimatedRowHeight: CGFloatGenerator = { 19.0 }
        let rowHeight: CGFloatGenerator = { UITableViewAutomaticDimension }
        let customDescription: OptionalStringGenerator = { "item type: \(type.debugName), identifier: \(identifier()), estimatedRowHeight: \(estimatedRowHeight()), rowHeight: \(rowHeight())" }
        return Item(type: type.rawValue, identifier: identifier, estimatedRowHeight: estimatedRowHeight, rowHeight: rowHeight, customDescription: customDescription)
    }
    
    private func generateTaskItem() -> Item {
        let type = TodoListItem.task
        let identifier: StringGenerator = { "taskCell" }
        let estimatedRowHeight: CGFloatGenerator = { 19.0 }
        let rowHeight: CGFloatGenerator = { UITableViewAutomaticDimension }
        let customDescription: OptionalStringGenerator = { "item type: \(type.debugName), identifier: \(identifier()), estimatedRowHeight: \(estimatedRowHeight()), rowHeight: \(rowHeight())" }
        return Item(type: type.rawValue, identifier: identifier, estimatedRowHeight: estimatedRowHeight, rowHeight: rowHeight, customDescription: customDescription)
    }
    
    private func generateSection(forType type: TodoListSection, andItems items: [Item]) -> Section {
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
    
    private func generateNoTasksSection() -> Section {
        let items: [Item] = {
            var items: [Item] = []
            
            items.append(generateNoTasksItem())
            
            return items
        }()
        return generateSection(forType: .noTasks, andItems: items)
    }
    
    private func generateUncompletedSection() -> Section {
        let items: [Item] = {
            var items: [Item] = []
            
            if uncompletedTasks.isEmpty {
                items.append(generateNoTasksItem())
            } else {
                uncompletedTasks.forEach { _ in
                    items.append(generateTaskItem())
                }
            }
            
            return items
        }()
        return generateSection(forType: .uncompleted, andItems: items)
    }
    
    private func generateCompletedSection() -> Section {
        let items: [Item] = {
            var items: [Item] = []
            
            if completedTasks.isEmpty {
                items.append(generateNoTasksItem())
            } else {
                completedTasks.forEach { _ in
                    items.append(generateTaskItem())
                }
            }
            
            return items
        }()
        return generateSection(forType: .completed, andItems: items)
    }
}


// MARK:- UITableViewDataSource
extension TodoListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionAndItem = getSectionAndItem(forIndexPath: indexPath) else { return UITableViewCell() }
        let tableDataItem = tableData.item(forIndexPath: indexPath)
        
        switch sectionAndItem {
        case let (section,item) where item == .noTasks:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableDataItem.identifier(), for: indexPath)
            
            switch section {
            case .noTasks:
                cell.textLabel?.text = "No tasks entered"
            case .uncompleted:
                cell.textLabel?.text = "No uncompleted tasks"
            case .completed:
                cell.textLabel?.text = "No completed tasks"
            }
            
            return cell
        case let (section,item) where item == .task:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableDataItem.identifier(), for: indexPath)
            
            switch section {
            case .uncompleted:
                cell.textLabel?.text = uncompletedTasks[indexPath.row].value(forKey: "title") as? String
            case .completed:
                cell.textLabel?.text = completedTasks[indexPath.row].value(forKey: "title") as? String
            default:
                fatalError()
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let sectionAndItem = getSectionAndItem(forIndexPath: indexPath) else { return }

        if editingStyle == .delete {
            if sectionAndItem.0 == .uncompleted {
                remove(uncompletedTasks[indexPath.row])
            } else if sectionAndItem.0 == .completed {
                remove(completedTasks[indexPath.row])
            } else {
                return
            }
        }
    }
}


// MARK:- UITableViewDelegate
extension TodoListViewController {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let sectionAndItem = getSectionAndItem(forIndexPath: indexPath) else { return false }

        switch sectionAndItem {
        case let (_,item) where item == .noTasks:
            return false
        default:
            return true
        }
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        debugLog("section: \(indexPath.section); row: \(indexPath.row)")
    }
}
