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
    
    func testTodoTaskManagerInitializeEmpty() {
        let todoTaskManager = TodoTaskManager()
        
        XCTAssertTrue(todoTaskManager.getAllTasks().isEmpty, "The TodoTaskManager initially has no tasks")
    }
    
}
