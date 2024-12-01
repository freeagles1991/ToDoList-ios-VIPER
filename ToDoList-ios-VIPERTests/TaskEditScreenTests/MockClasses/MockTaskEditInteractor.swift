//
//  MockTaskEditInteractor.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 01.12.2024.
//

import Foundation
@testable import ToDoList_ios_VIPER

class MockTaskEditInteractor: TaskEditInteractor {
    var createTaskCalled = false
    var updateTaskCalled = false

    func createTask(title: String, text: String?, completion: @escaping () -> Void) {
        createTaskCalled = true
        completion()
    }
    
    func updateTask(title: String, text: String?, completion: @escaping () -> Void) {
        updateTaskCalled = true
        completion()
    }
}
