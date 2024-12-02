//
//  MockListInteractor.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 02.12.2024.
//

import Foundation
@testable import ToDoList_ios_VIPER

final class MockListInteractor: ListInteractor {
    var didCallSetupTodoStore: Bool = false
    var searchQuery: String?
    var toggledTodo: Todo?
    var removedIndexPath: IndexPath?
    
    func setupTodoStore() {
        didCallSetupTodoStore = true
    }
    
    func searchTodos(byTitle title: String, completion: @escaping () -> Void) {
        searchQuery = title
        completion()
    }
    
    func toggleTodoCompleteState(_ todo: Todo, at indexPath: IndexPath) {
        toggledTodo = todo
    }
    
    func removeTodo(at indexPath: IndexPath) {
        removedIndexPath = indexPath
    }
    
    func fetchTodos(completion: @escaping () -> Void) {
        completion()
    }
    
    func getTodoStore() -> TodoStore {
        return TodoStore()
    }
    
    func numberOfTodos() -> Int {
        return 0
    }
    
    func getTodo(at indexPath: IndexPath) -> Todo {
        return Todo.defaultTodo
    }
}
