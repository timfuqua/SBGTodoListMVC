//
//  TodoTaskCoreDataDataProvider.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/25/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit
import CoreData


// MARK:- TodoTaskCoreDataDataProvider
class TodoTaskCoreDataDataProvider: DataProvider {

    typealias T = NSManagedObject
    
    // MARK: CoreData
    private var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    private var managedContext: NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }
    
    private var todoTaskEntity: NSEntityDescription? {
        guard let managedContext = managedContext else { return nil }
        return NSEntityDescription.entity(forEntityName: "TodoTask", in: managedContext)
    }
    
    private let todoFetchRequestForFetch = NSFetchRequest<NSManagedObject>(entityName: "TodoTask")
    private let todoFetchRequestForRemove = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoTask")
    private var deleteAllRequest: NSBatchDeleteRequest {
        return NSBatchDeleteRequest(fetchRequest: todoFetchRequestForRemove)
    }

}


// MARK:- initialize
extension TodoTaskCoreDataDataProvider {
    func fetchAllTasks() -> [NSManagedObject] {
        guard let managedContext = managedContext else { return [] }
        
        do {
            let fetchedTasks = try managedContext.fetch(todoFetchRequestForFetch)
            return fetchedTasks
        } catch let error as NSError {
            debugLog("\(error)")
            return []
        }
    }
}


// MARK:- get
extension TodoTaskCoreDataDataProvider {
    func getAll() -> [NSManagedObject] {
        return fetchAllTasks()
    }
}


// MARK:- add
extension TodoTaskCoreDataDataProvider {
    func add(_ value: NSManagedObject) {
        guard let managedContext = managedContext else { return }

        do {
            try managedContext.save()
        } catch let error as NSError {
            debugLog("\(error)")
        }
    }
    
    func add(_ todoTask: TodoTaskInfo) {
        guard let managedContext = managedContext else { return }
        guard let todoTaskEntity = todoTaskEntity else { return }
        
        let addedTask = NSManagedObject(entity: todoTaskEntity, insertInto: managedContext)
        
        addedTask.setValue(todoTask.title, forKey: "title")
        addedTask.setValue(todoTask.type.rawValue, forKey: "type")
        addedTask.setValue(todoTask.priority.rawValue, forKey: "priority")
        addedTask.setValue(todoTask.completed, forKey: "completed")

        add(addedTask)
    }
}


// MARK:- remove
extension TodoTaskCoreDataDataProvider {
    func remove(_ value: NSManagedObject) -> Bool {
        guard let managedContext = managedContext else { return false }
        
        managedContext.delete(value)
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            debugLog("\(error)")
            return false
        }
    }
    
    func remove(_ todoTask: TodoTaskInfo) -> Bool {
        guard let managedContext = managedContext else { return false }
        
        do {
            let fetchedTasks = try managedContext.fetch(todoFetchRequestForFetch)
            
            for task in fetchedTasks {
                if task == todoTask {
                    return remove(task)
                }
            }
            
            return false
        } catch let error as NSError {
            debugLog("\(error)")
            return false
        }
    }
    
    func removeAll() {
        guard let managedContext = managedContext else { return }
        let deleteAllRequest = NSBatchDeleteRequest(fetchRequest: todoFetchRequestForRemove)
        
        do {
            try managedContext.execute(deleteAllRequest)
            try managedContext.save()
        } catch let error as NSError {
            debugLog("\(error)")
        }
    }
}
