//
//  TodoTaskInfoDataProviderTests.swift
//  SBGTodoListMVCTests
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import XCTest
@testable import SBGTodoListMVC

class TodoTaskInfoDataProviderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private func createAlphaTask() -> TodoTaskInfo {
        return TodoTaskInfo(title: "Alpha", type: .text, priority: .normal, completed: false)
    }
    
    private func createBetaTask() -> TodoTaskInfo {
        return TodoTaskInfo(title: "Beta", type: .text, priority: .normal, completed: false)
    }
    
    func testRemoveAllIsEmpty() {
        let manager = TodoTaskInfoDataProvider()
        
        manager.removeAll()
        let afterInitialRemoveAllTaskCount = manager.getAll().count
        XCTAssertTrue(afterInitialRemoveAllTaskCount == 0, "no tasks after removing all")
        
        manager.add(createAlphaTask())
        manager.add(createBetaTask())
        let afterAddTaskCount = manager.getAll().count
        XCTAssertTrue(afterAddTaskCount != 0, "should have more than 0 tasks")
        
        manager.removeAll()
        let afterFinalRemoveAllTaskCount = manager.getAll().count
        XCTAssertTrue(afterFinalRemoveAllTaskCount == 0, "initially has no tasks")
    }
    
    func testAddIncreasesCountByOne() {
        let manager = TodoTaskInfoDataProvider()
        
        let initialTaskCount = manager.getAll().count
        
        manager.add(createAlphaTask())
        let afterAddTaskCount = manager.getAll().count
        XCTAssertTrue(afterAddTaskCount == initialTaskCount + 1, "should have one more task than before")
    }
    
    func testRemoveDecreasesCountByOne() {
        let manager = TodoTaskInfoDataProvider()
        
        let initialTaskCount = manager.getAll().count
        
        manager.add(createAlphaTask())
        let afterAddTaskCount = manager.getAll().count
        XCTAssertTrue(afterAddTaskCount == initialTaskCount + 1, "should have one more task than before")
        
        let removeResult = manager.remove(createAlphaTask())
        let afterRemoveTaskCount = manager.getAll().count
        XCTAssertTrue(removeResult, "remove operation should succeed")
        XCTAssertTrue(afterRemoveTaskCount == afterAddTaskCount - 1, "should have one less task than before")
        
        let finalTaskCount = manager.getAll().count
        XCTAssertTrue(finalTaskCount == initialTaskCount, "should have no tasks after add and remove")
    }
    
}
