//
//  Time.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/23/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import Foundation

// MARK:- local time helper
private let currentLocalTimeDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss.SSS"
    dateFormatter.timeZone = TimeZone.current
    return dateFormatter
}()

extension Date {
    static var localTime: String { return currentLocalTimeDateFormatter.string(from: Date()) }
}
