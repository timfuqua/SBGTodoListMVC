//
//  TodoTaskInfoViewController.swift
//  SBGTodoListMVC
//
//  Created by Tim Fuqua on 8/26/18.
//  Copyright © 2018 SBGCodeTest. All rights reserved.
//

import UIKit


// MARK:- TodoTaskInfoViewController
class TodoTaskInfoViewController: UIViewController {
    
    // MARK: injected vars
    var todoTaskInfo: TodoTaskInfo!

    // MARK: vars
    
    // MARK: @IBOutlets
    
}


// MARK:- life cycle
extension TodoTaskInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}


// MARK:- initialization
extension TodoTaskInfoViewController {
    func initializeTitle() {
        navigationItem.title = todoTaskInfo.title
    }
}
