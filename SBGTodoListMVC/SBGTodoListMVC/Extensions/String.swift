//
//  String.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/23/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import Foundation


extension String {
    func indexAfterLastOccurence(of char: Character) -> String.Index? {
        for (idx, value) in reversed().enumerated() {
            if value == char { return index(endIndex, offsetBy: -idx) }
        }
        
        return nil
    }
}
