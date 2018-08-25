//
//  TodoTaskManagerTests.swift
//  SBGTodoListMVCTests
//
//  Created by Tim Fuqua on 8/25/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import XCTest
@testable import SBGTodoListMVC
import CoreData

class TodoTaskManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitializeEmpty() {
        let todoTaskManager = TodoTaskManager()
        
        XCTAssertTrue(todoTaskManager.getAllTasks().isEmpty, "The TodoTaskManager initially has no tasks")
    }
    
    func testAddIncreasesCountByOne() {
        let todoTaskManager = TodoTaskManager()
        
        let initialTaskCount = todoTaskManager.getAllTasks().count
        XCTAssertTrue(initialTaskCount == 0, "The TodoTaskManager initially has no tasks")
        
        todoTaskManager.addTask()
        let afterAddTaskCount = todoTaskManager.getAllTasks().count
        XCTAssertTrue(afterAddTaskCount == initialTaskCount + 1, "The TodoTaskManager should have one more task than before")
    }
    
}
