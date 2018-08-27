//
//  TodoTaskInfo+CoreData.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import Foundation
import CoreData


func ==(lhs: NSManagedObject, rhs: TodoTaskInfo) -> Bool {
    return TodoTaskInfo(fromNSManagedObject: lhs) == rhs
}

func ==(lhs: TodoTaskInfo, rhs: NSManagedObject) -> Bool {
    return lhs == TodoTaskInfo(fromNSManagedObject: rhs)
}


extension TodoTaskInfo {
    init(fromNSManagedObject object: NSManagedObject) {
        title = (object.value(forKey: "title") as? String) ?? ""
        
        if let typeInt = object.value(forKey: "type") as? Int, let todoTaskType = TodoTaskType(rawValue: typeInt) {
            type = todoTaskType
        } else {
            type = .text
        }
        
        if let priorityInt = object.value(forKey: "priority") as? Int, let todoTaskPriority = TodoTaskPriority(rawValue: priorityInt) {
            priority = todoTaskPriority
        } else {
            priority = .normal
        }
        
        completed = (object.value(forKey: "completed") as? Bool) ?? false
    }
}
