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
    
    // MARK: TodoTaskType
    enum TodoTaskType: Int, CaseIterable {
        case text = 0
        case taskList
        
        init(name: String) {
            switch name {
            case "text","Text": self.init(rawValue: 0)!
            case "taskList","TaskList": self.init(rawValue: 1)!
            default: self.init(rawValue: 0)!
            }
        }
        
        var name: String {
            switch self {
            case .text: return "Text"
            case .taskList: return "Task List"
            }
        }
    }
    
    // MARK: TodoTaskPriority
    enum TodoTaskPriority: Int, CaseIterable {
        case urgent = 0
        case high
        case normal
        
        init(name: String) {
            switch name {
            case "urgent","Urgent": self.init(rawValue: 0)!
            case "high","High": self.init(rawValue: 1)!
            case "normal","Normal": self.init(rawValue: 2)!
            default: self.init(rawValue: 2)!
            }
        }
        
        var name: String {
            switch self {
            case .urgent: return "Urgent"
            case .high: return "High"
            case .normal: return "Normal"
            }
        }
    }
    
    var title: String
    var type: TodoTaskType
    var priority: TodoTaskPriority
    var completed: Bool
    
}
