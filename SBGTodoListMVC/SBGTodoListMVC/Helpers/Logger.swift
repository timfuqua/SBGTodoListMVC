//
//  Logger.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/23/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import Foundation

public func debugLog(_ message: String = "", file: String = #file, function: String = #function) {
    guard let lastOccurence = file.indexAfterLastOccurence(of: "/") else { return }
    let shortFile: String = String(file[lastOccurence...])
    let emptyPrint = "\(Date.localTime) *** \(shortFile) *** \(function)"
    print(message.isEmpty ? emptyPrint : "\(emptyPrint) *** \(message)")
}
