//
//  MockTodoStore.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 01.12.2024.
//

import Foundation
@testable import ToDoList_ios_VIPER

class MockTodoStore: TodoStore {
    var addTodoCalled = false
    var updateTodoCalled = false

    override func addTodo(_ todo: Todo, completion: (() -> Void)? = nil) {
        addTodoCalled = true
        completion?()
    }

    override func updateTodo(_ todo: Todo, completion: (() -> Void)? = nil) {
        updateTodoCalled = true
        completion?()
    }
}
