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
    
    // MARK: private vars
    private var allTasks: [NSManagedObject] = []
    
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
    func fetchAllTasks() {
        guard let managedContext = managedContext else { return }
        
        do {
            let fetchedTasks = try managedContext.fetch(todoFetchRequestForFetch)
            allTasks = fetchedTasks
        } catch let error as NSError {
            debugLog("\(error)")
        }
    }
}


// MARK:- get
extension TodoTaskCoreDataDataProvider {
    func getAll() -> [NSManagedObject] {
        return getAllTasks()
    }
    
    func getAllTasks(afterFetch fetch: Bool = true) -> [NSManagedObject] {
        if fetch {
            fetchAllTasks()
        }
        
        return allTasks
    }
}


// MARK:- add
extension TodoTaskCoreDataDataProvider {
    func add(_ value: NSManagedObject) {
        addTask()
    }
    
    func addTask() {
        guard let managedContext = managedContext else { return }
        guard let todoTaskEntity = todoTaskEntity else { return }
        let addedTask = NSManagedObject(entity: todoTaskEntity, insertInto: managedContext)
        
        addedTask.setValue("Test", forKey: "title")
        
        do {
            try managedContext.save()
            allTasks.append(addedTask)
        } catch let error as NSError {
            debugLog("\(error)")
        }
    }
}


// MARK:- remove
extension TodoTaskCoreDataDataProvider {
    func remove(_ value: NSManagedObject) -> Bool {
        return removeTask()
    }
    
    func removeTask() -> Bool {
        guard let managedContext = managedContext else { return false }
        
        do {
            let fetchedTasks = try managedContext.fetch(todoFetchRequestForFetch)
            
            if let firstTask = fetchedTasks.first {
                managedContext.delete(firstTask)
                allTasks.removeFirst()
            }
            
            return true
        } catch let error as NSError {
            debugLog("\(error)")
            return false
        }
    }
    
    func removeAll() {
        removeAllTasks()
    }
    
    func removeAllTasks() {
        guard let managedContext = managedContext else { return }
        let deleteAllRequest = NSBatchDeleteRequest(fetchRequest: todoFetchRequestForRemove)
        
        do {
            try managedContext.execute(deleteAllRequest)
            try managedContext.save()
            allTasks.removeAll()
        } catch let error as NSError {
            debugLog("\(error)")
        }
    }
}
