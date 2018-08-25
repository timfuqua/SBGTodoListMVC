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
        
        XCTAssertTrue(todoTaskManager.getAllTasks(afterFetch: false).isEmpty, "The TodoTaskManager initially has no tasks")
    }
    
    func testRemoveAllEmpty() {
        let todoTaskManager = TodoTaskManager()
        
        todoTaskManager.removeAllTasks()
        let afterInitialRemoveAllTaskCount = todoTaskManager.getAllTasks().count
        XCTAssertTrue(afterInitialRemoveAllTaskCount == 0, "The TodoTaskManager initially has no tasks")
        
        todoTaskManager.addTask()
        todoTaskManager.addTask()
        let afterAddTaskCount = todoTaskManager.getAllTasks().count
        XCTAssertTrue(afterAddTaskCount != 0, "The TodoTaskManager should have more than 0 tasks")

        todoTaskManager.removeAllTasks()
        let afterFinalRemoveAllTaskCount = todoTaskManager.getAllTasks().count
        XCTAssertTrue(afterFinalRemoveAllTaskCount == 0, "The TodoTaskManager initially has no tasks")
    }
    
    func testAddIncreasesCountByOne() {
        let todoTaskManager = TodoTaskManager()
        
        let initialTaskCount = todoTaskManager.getAllTasks().count
        XCTAssertTrue(initialTaskCount == 0, "The TodoTaskManager initially has no tasks")
        
        todoTaskManager.addTask()
        let afterAddTaskCount = todoTaskManager.getAllTasks().count
        XCTAssertTrue(afterAddTaskCount == initialTaskCount + 1, "The TodoTaskManager should have one more task than before")
    }
    
    func testRemoveDecreasesCountByOne() {
        let todoTaskManager = TodoTaskManager()
        
        let initialTaskCount = todoTaskManager.getAllTasks().count
        XCTAssertTrue(initialTaskCount == 0, "The TodoTaskManager initially has no tasks")
        
        todoTaskManager.addTask()
        let afterAddTaskCount = todoTaskManager.getAllTasks().count
        XCTAssertTrue(afterAddTaskCount == initialTaskCount + 1, "The TodoTaskManager should have one more task than before")
        
        let removeResult = todoTaskManager.removeTask()
        let afterRemoveTaskCount = todoTaskManager.getAllTasks().count
        XCTAssertTrue(removeResult, "The remove operation should succeed")
        XCTAssertTrue(afterRemoveTaskCount == afterAddTaskCount - 1, "The TodoTaskManager should have one less task than before")
        
        let finalTaskCount = todoTaskManager.getAllTasks().count
        XCTAssertTrue(finalTaskCount == initialTaskCount, "The TodoTaskManager should have no tasks after add and remove")
    }
    
}
