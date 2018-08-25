//
//  TodoTaskCoreDataDataProviderTests.swift
//  SBGTodoListMVCTests
//
//  Created by Tim Fuqua on 8/25/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import XCTest
@testable import SBGTodoListMVC
import CoreData

class TodoTaskCoreDataDataProviderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitializeEmpty() {
        let manager = TodoTaskCoreDataDataProvider()
        
        XCTAssertTrue(manager.getAllTasks(afterFetch: false).isEmpty, "The TodoTaskCoreDataDataProvider initially has no tasks")
    }
    
    func testRemoveAllEmpty() {
        let manager = TodoTaskCoreDataDataProvider()
        
        manager.removeAllTasks()
        let afterInitialRemoveAllTaskCount = manager.getAllTasks().count
        XCTAssertTrue(afterInitialRemoveAllTaskCount == 0, "The TodoTaskCoreDataDataProvider initially has no tasks")
        
        manager.addTask()
        manager.addTask()
        let afterAddTaskCount = manager.getAllTasks().count
        XCTAssertTrue(afterAddTaskCount != 0, "The TodoTaskCoreDataDataProvider should have more than 0 tasks")

        manager.removeAllTasks()
        let afterFinalRemoveAllTaskCount = manager.getAllTasks().count
        XCTAssertTrue(afterFinalRemoveAllTaskCount == 0, "The TodoTaskCoreDataDataProvider initially has no tasks")
    }
    
    func testAddIncreasesCountByOne() {
        let manager = TodoTaskCoreDataDataProvider()
        
        let initialTaskCount = manager.getAllTasks().count
        
        manager.addTask()
        let afterAddTaskCount = manager.getAllTasks().count
        XCTAssertTrue(afterAddTaskCount == initialTaskCount + 1, "The TodoTaskCoreDataDataProvider should have one more task than before")
    }
    
    func testRemoveDecreasesCountByOne() {
        let manager = TodoTaskCoreDataDataProvider()
        
        let initialTaskCount = manager.getAllTasks().count
        
        manager.addTask()
        let afterAddTaskCount = manager.getAllTasks().count
        XCTAssertTrue(afterAddTaskCount == initialTaskCount + 1, "The TodoTaskCoreDataDataProvider should have one more task than before")
        
        let removeResult = manager.removeTask()
        let afterRemoveTaskCount = manager.getAllTasks().count
        XCTAssertTrue(removeResult, "The remove operation should succeed")
        XCTAssertTrue(afterRemoveTaskCount == afterAddTaskCount - 1, "The TodoTaskCoreDataDataProvider should have one less task than before")
        
        let finalTaskCount = manager.getAllTasks().count
        XCTAssertTrue(finalTaskCount == initialTaskCount, "The TodoTaskCoreDataDataProvider should have no tasks after add and remove")
    }
    
}
