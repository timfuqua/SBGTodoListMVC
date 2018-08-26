//
//  TodoTaskInfo.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/24/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import Foundation


func ==(lhs: TodoTaskInfo, rhs: TodoTaskInfo) -> Bool {
    return lhs.title == rhs.title
        && lhs.type == rhs.type
        && lhs.priority == rhs.priority
        && lhs.completed == rhs.completed
}


// MARK:- TodoTaskInfo
struct TodoTaskInfo {
    
    enum TodoTaskType: Int {
        case text = 0
        case taskList
    }
    
    enum TodoTaskPriority: Int {
        case urgent = 0
        case high
        case normal
    }
    
    var title: String
    var type: TodoTaskType
    var priority: TodoTaskPriority
    var completed: Bool
    
}
