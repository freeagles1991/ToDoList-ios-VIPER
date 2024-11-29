//
//  Task.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 26.11.2024.
//

import Foundation

struct TodoResponse: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

extension TodoResponse {
    func toTodo() -> Todo {
        return Todo(
            id: UUID(),
            title: todo.makeShortTitle(),
            text: todo,
            completed: completed,
            date: Date())
    }
}

struct TodosResponse: Codable {
    let todos: [TodoResponse]
}

extension TodosResponse {
    func toTodos() -> [Todo] {
        return todos.map { $0.toTodo() }
    }
}

struct Todo: Identifiable {
    let id: UUID
    let title: String
    let text: String?
    let completed: Bool
    let date: Date
    
    enum Constants {
        static let defaultTodoTitle = "Default Title"
        static let defaultTodoText = "Default Text"
        static let newTodoTitle = "Новая задача"
        static let newTodoText = "Добавьте описание задачи"
    }
    
    static let defaultTodo: Todo = Todo(id: UUID(), title: Constants.defaultTodoTitle, text: Constants.defaultTodoText, completed: false, date: Date())
    static let newTodo: Todo = Todo(id: UUID(), title: Constants.newTodoTitle, text: Constants.newTodoText, completed: false, date: Date())
}


