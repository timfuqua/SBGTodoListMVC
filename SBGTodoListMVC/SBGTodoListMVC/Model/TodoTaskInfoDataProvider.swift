//
//  TodoTaskInfoDataProvider.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import Foundation


// MARK:- TodoTaskInfoDataProvider
class TodoTaskInfoDataProvider: DataProvider {

    // MARK: DataProvider
    typealias T = TodoTaskInfo
    
    private var coreDataDataProvider: TodoTaskCoreDataDataProvider
//    private var userDefaultsDataProvider: TodoTaskUserDefaultsDataProvider
//    private var cloudDataProvider: TodoTaskCloudDataProvider

    // MARK: init
    init() {
        coreDataDataProvider = TodoTaskCoreDataDataProvider()
    }

}


// MARK:- DataProvider; get
extension TodoTaskInfoDataProvider {
    func getAll() -> [TodoTaskInfo] {
        return coreDataDataProvider.getAll().map { T.init(fromNSManagedObject: $0) }
    }
}


// MARK:- DataProvider; add
extension TodoTaskInfoDataProvider {
    func add(_ value: TodoTaskInfo) {
        coreDataDataProvider.add(value)
    }
}


// MARK:- DataProvider; remove
extension TodoTaskInfoDataProvider {
    @discardableResult func remove(_ value: TodoTaskInfo) -> Bool {
        return coreDataDataProvider.remove(value)
    }
    
    func removeAll() {
        coreDataDataProvider.removeAll()
    }
}
