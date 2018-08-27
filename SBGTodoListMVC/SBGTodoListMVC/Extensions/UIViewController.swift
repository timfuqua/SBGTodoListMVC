//
//  UIViewController.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit


typealias VoidBlock = (() -> Void)


// MARK:- UIViewController alerts
extension UIViewController {
    func showAlert(withTitle title: String?, withMessage message: String?, andCompletion completion: VoidBlock? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in completion?() }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showDestructiveAlert(withTitle title: String?, withMessage message: String?, andCompletion completion: VoidBlock? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in completion?() }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
