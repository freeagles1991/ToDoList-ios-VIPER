//
//  DataLoader.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 29.11.2024.
//

import Foundation

final class DataLoader {
    let networkClient: NetworkClientProtocol
    let todoStore: TodoStore

    init(networkClient: NetworkClientProtocol, todoStore: TodoStore) {
        self.networkClient = networkClient
        self.todoStore = todoStore
    }

    func loadDataFromNetwork(completion: (() -> Void)? = nil) {
        guard let url = URL(string: GlobalConstants.apiUrl) else {
            print("Invalid URL: \(GlobalConstants.apiUrl)")
            completion?()
            return
        }

        print("Starting network request to URL: \(url)")

        networkClient.get(from: url, type: TodosResponse.self) { [weak self] result in
            guard let self else {
                print("Self is nil during network response processing")
                completion?()
                return
            }

            switch result {
            case .success(let todosResponse):
                let todos = todosResponse.toTodos()
                print("Network request successful, received \(todos.count) todos")

                let dispatchGroup = DispatchGroup()

                for (index, todo) in todos.enumerated() {
                    dispatchGroup.enter()
                    if !self.todoStore.contains(todo) {
                        self.todoStore.addTodo(todo) {
                            print("Todo added to store: \(index + 1)/\(todos.count) - \(todo.title)")
                            dispatchGroup.leave()
                        }
                    } else {
                        print("Todo already exists: \(todo.title)")
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    print("All todos processed and added to the store")
                    completion?()
                }

            case .failure(let error):
                print("Failed to fetch data from network: \(error.localizedDescription)")
                completion?()
            }
        }
    }
}
