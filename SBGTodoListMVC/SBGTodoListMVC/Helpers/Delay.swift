//
//  Delay.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import Foundation


func delay(seconds: Int, closure: @escaping VoidBlock) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
        closure()
    }
}

func delay(milliseconds: Int, closure: @escaping VoidBlock) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds)) {
        closure()
    }
}

func delay(microseconds: Int, closure: @escaping VoidBlock) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(microseconds)) {
        closure()
    }
}

func delay(nanoseconds: Int, closure: @escaping VoidBlock) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(nanoseconds)) {
        closure()
    }
}
