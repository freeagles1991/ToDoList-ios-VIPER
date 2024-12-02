//
//  MockTodoStoreForList.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 02.12.2024.
//

import Foundation
@testable import ToDoList_ios_VIPER

final class MockTodoStoreForList: TodoStore {
    var updatedTodo: Todo?
    
    override func updateTodo(_ todo: Todo, completion: (() -> Void)? = nil) {
        updatedTodo = todo
        completion?()
    }
}
