//
//  TodoTaskManager.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/25/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit
import CoreData


// MARK:- TodoTaskManager
class TodoTaskManager {
    
    // MARK: private vars
    private var allTasks: [NSManagedObject] = []
    
    // MARK: CoreData
    var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    var managedContext: NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }
    
    var todoTaskEntity: NSEntityDescription? {
        guard let managedContext = managedContext else { return nil }
        return NSEntityDescription.entity(forEntityName: "TodoTask", in: managedContext)
    }
    
}


// MARK:- initialize
extension TodoTaskManager {
    
}


// MARK:- get
extension TodoTaskManager {
    func getAllTasks() -> [NSManagedObject] {
        return allTasks
    }
}


// MARK:- add
extension TodoTaskManager {
    func addTask() {
        guard let managedContext = managedContext else { return }
        guard let todoTaskEntity = todoTaskEntity else { return }
        let addedTask = NSManagedObject(entity: todoTaskEntity, insertInto: managedContext)
        
        addedTask.setValue("Test", forKey: "title")
        allTasks.append(addedTask)
    }
}


// MARK:- remove
extension TodoTaskManager {
    
}
