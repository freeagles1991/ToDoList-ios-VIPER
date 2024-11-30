//
//  TaskEditInteractor.swift
//  ToDoTaskEdit-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation

protocol TaskEditInteractor {
    func createTask(title: String, text: String?, completion: @escaping () -> Void)
    func updateTask(title: String, text: String?, completion: @escaping () -> Void)
    
}

final class TaskEditInteractorImpl: TaskEditInteractor {

    // MARK: - Private Properties
    private let todo: Todo
    private let isNewTask: Bool
    private let todoStore: TodoStore
    
    // MARK: - Initializers
    init(todo: Todo, isNewTask: Bool, todoStore: TodoStore) {
        self.todo = todo
        self.isNewTask = isNewTask
        self.todoStore = todoStore
    }
    

    // MARK: - Public Methods
    func createTask(title: String, text: String?, completion: @escaping () -> Void) {
        let newTodo = Todo(
            id: UUID(),
            title: title,
            text: text,
            completed: false,
            date: Date()
        )
        todoStore.addTodo(newTodo) {
            print("Task created: \(newTodo)")
            completion()
        }
    }

    func updateTask(title: String, text: String?, completion: @escaping () -> Void) {
        let updatedTodo = Todo(
            id: todo.id,
            title: title,
            text: text,
            completed: todo.completed,
            date: todo.date
        )
        todoStore.updateTodo(updatedTodo) {
            print("Task updated: \(updatedTodo)")
            completion()
        }
    }
}
