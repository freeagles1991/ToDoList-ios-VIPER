//
//  MockListRouter.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 02.12.2024.
//

import Foundation
@testable import ToDoList_ios_VIPER

final class MockListRouter: ListRouter {
    var didNavigateToTaskEdit = false
    
    func navigateToTaskEdit(todo: Todo, todoStore: TodoStore, isNewTask: Bool, indexPath: IndexPath?, onTaskCreated: @escaping () -> Void, onTaskUpdated: @escaping () -> Void) {
        didNavigateToTaskEdit = true
    }
}
