//
//  TodoTaskInfo.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/24/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import Foundation


// MARK:- TodoTaskInfo
struct TodoTaskInfo {
    
    enum TodoTaskType {
        case text
        case taskList
    }
    
    enum TodoTaskPriority {
        case urgent
        case high
        case normal
    }
    
    var title: String
    var type: TodoTaskType
    var priority: TodoTaskPriority
    var completed: Bool
    
}
