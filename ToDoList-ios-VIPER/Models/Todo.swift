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

struct TodosResponse: Codable {
    let todos: [TodoResponse]
}

struct Todo: Identifiable {
    let id: UUID
    let title: String
    let text: String?
    let completed: Bool
    let date: Date
    
    static let defaultTodo: Todo = Todo(id: UUID(), title: "Default Title", text: nil, completed: false, date: Date())
}


