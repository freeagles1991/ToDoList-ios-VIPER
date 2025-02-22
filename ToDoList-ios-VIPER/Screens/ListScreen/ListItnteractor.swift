//
//  ListInteractor.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation

protocol ListInteractor {
    func fetchTodos(completion: @escaping () -> Void)
    func searchTodos(byTitle title: String, completion: @escaping () -> Void)
    func setupTodoStore()
    func toggleTodoCompleteState(_ todo: Todo, at indexPath: IndexPath)
    func removeTodo(at indexPath: IndexPath)
    func getTodoStore() -> TodoStore
    func numberOfTodos() -> Int
    func getTodo(at indexPath: IndexPath) -> Todo
}

final class ListInteractorImpl: ListInteractor {
    weak var presenter: ListPresenter?
    private let todoStore: TodoStore
    
    init(presenter: ListPresenter? = nil, todoStore: TodoStore) {
        self.presenter = presenter
        self.todoStore = todoStore
    }
    
    func fetchTodos(completion: @escaping () -> Void) {
        todoStore.fetchTodos {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func searchTodos(byTitle title: String, completion: @escaping () -> Void) {
        guard !title.isEmpty else {
            print("Search query is empty. Fetching all todos.")
            todoStore.fetchTodos {
                DispatchQueue.main.async {
                    completion()
                }
            }
            return
        }
        
        print("Searching todos with title: \(title)")
        
        DispatchQueue.main.async {
            self.todoStore.searchTodos(byTitle: title) {
                DispatchQueue.main.async {
                    if self.todoStore.todos.isEmpty {
                        print("No results found for search query: \(title)")
                    }
                    completion()
                }
            }
        }
    }
    
    func setupTodoStore() {
        todoStore.onDataUpdate = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                let count = self.todoStore.numberOfRows()
                self.presenter?.didUpdateTodosCount(with: count)
            }
        }
    }
    
    func toggleTodoCompleteState(_ todo: Todo, at indexPath: IndexPath) {
        todoStore.updateTodo(todo) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.presenter?.didToggleTodoState(at: indexPath)
            }
        }
    }
    
    func removeTodo(at indexPath: IndexPath) {
        todoStore.removeTodo(at: indexPath) { [weak self] in
            DispatchQueue.main.async {
                self?.presenter?.didRemovedTodo(at: indexPath)
            }
        }
    }
    
    func getTodoStore() -> TodoStore {
        return self.todoStore
    }
    
    func numberOfTodos() -> Int {
        return todoStore.numberOfRows()
    }
    
    func getTodo(at indexPath: IndexPath) -> Todo {
        return todoStore.object(at: indexPath)
    }
}
