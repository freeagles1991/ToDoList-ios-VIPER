//
//  MockListPresenter.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 02.12.2024.
//

import Foundation
@testable import ToDoList_ios_VIPER

final class MockListPresenter: ListPresenter {
    var didReloadData: Bool = false
    
    func viewDidLoad() {
        didReloadData = true
    }
    func fetchTodos() {}
    func searchTodos(byTitle title: String) {}
    func didUpdateTodosCount(with count: Int) {}
    func toggleTodoCompleteState(_ todo: Todo, at indexPath: IndexPath) {}
    func didToggleTodoState(at indexPath: IndexPath) {
        didReloadData = true
    }
    func removeTodo(at indexPath: IndexPath) {}
    func didRemovedTodo(at indexPath: IndexPath) {}
    func openTaskEdit(for todo: Todo, isNewTask: Bool, indexPath: IndexPath?) {}
    func numberOfTodos() -> Int { return 0 }
    func getTodo(at indexPath: IndexPath) -> Todo { return Todo.defaultTodo }
}
