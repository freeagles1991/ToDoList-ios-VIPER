//
//  MockTaskEditPresenter.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 01.12.2024.
//

import Foundation
@testable import ToDoList_ios_VIPER

class MockTaskEditPresenter: TaskEditPresenter {
    var viewDidLoadCalled = false
    var didFinishEditingCalled = false
    var dismissCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didFinishEditing(title: String?, text: String?) {
        didFinishEditingCalled = true
    }
    
    func dismiss() {
        dismissCalled = true
    }
}
