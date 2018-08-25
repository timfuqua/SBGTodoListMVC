//
//  DataProvider.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/25/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import Foundation


// MARK:- DataProvider
protocol DataProvider: class {
    associatedtype T
    func getAll() -> [T]
    func add(_ value: T)
    func remove(_ value: T) -> Bool
    func removeAll()
}
