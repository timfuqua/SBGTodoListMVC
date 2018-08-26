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
        
        type = .text
        priority = .normal
        completed = false
    }
}
