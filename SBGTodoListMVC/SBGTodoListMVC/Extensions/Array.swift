//
//  Array.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/23/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import Foundation


extension Array {
    mutating func removeIf(predicate: (Element) -> Bool) -> [Element] {
        let groups = self.separate(predicate: predicate)
        self = groups.notMatching
        return groups.matching
    }
}
