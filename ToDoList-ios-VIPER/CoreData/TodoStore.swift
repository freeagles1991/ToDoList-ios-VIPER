//
//  TodosStore.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 26.11.2024.
//

import Foundation

import Foundation
import CoreData
import UIKit

class TodoStore: NSObject {
    var todos: [Todo] = [] {
        didSet {
            onDataUpdate?()
        }
    }
    var onDataUpdate: (() -> Void)?
    
    @MainActor
    private var appDelegate: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("UIApplication.shared.delegate is not of type AppDelegate")
        }
        return delegate
    }
    
    @MainActor
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    private let backgroundQueue = DispatchQueue(label: "com.todoApp.backgroundQueue", qos: .userInitiated)
    
    //MARK: Public
    func numberOfRows() -> Int {
        return todos.count
    }

    func object(at indexPath: IndexPath) -> Todo {
        guard indexPath.row >= 0 && indexPath.row < todos.count else {
            fatalError("Index out of range: \(indexPath.row), but todos count is \(todos.count)")
        }
        return todos[indexPath.row]
    }
    
    override init() {
        super.init()
    }
    
    //MARK: Загрузить задачи
    func fetchTodos(completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
            guard let self = self else {
                print("Error: Self is nil during fetchTodos task")
                return
            }
            
            
            DispatchQueue.main.async {
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
                do {
                    let fetchedObjects = try self.context.fetch(fetchRequest)
                    self.todos = fetchedObjects.compactMap { $0.toTodo() }
                    
                    DispatchQueue.main.async {
                        print("Todos fetched successfully, count: \(self.todos.count)")
                        completion?()
                    }
                } catch {
                    print("Error: Failed to fetch Todos: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
    
    //MARK: Содержит ли задачу
    
    @MainActor
    func contains(_ todo: Todo) -> Bool {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check existence of Todo: \(error.localizedDescription)")
            return false
        }
    }
    
    //MARK: Поиск задачи
    @MainActor
    public func searchTodos(byTitle title: String, completion: @escaping () -> Void) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "title BEGINSWITH[cd] %@", title)
                
                do {
                    let results = try self.context.fetch(fetchRequest)
                    self.todos = results.compactMap { $0.toTodo() }
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Failed to search Todos by title: \(error)")
                    
                    DispatchQueue.main.async {
                        self.todos = []
                        completion()
                    }
                }
            }
        }
    }
    
    //MARK: Создаем задачу
    func addTodo(_ todo: Todo, completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
            DispatchQueue.main.async {
                
                guard let self = self else { return }
                
                do {
                    try self.context.save()
                    DispatchQueue.main.async {
                        self.todos.append(todo)
                        completion?()
                    }
                } catch {
                    print("Failed to save Todo: \(error)")
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
    
    //MARK: Обновляем задачу
    func updateTodo(_ todo: Todo, completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
                
                do {
                    let results = try self.context.fetch(fetchRequest)
                    if let todoEntity = results.first {
                        todoEntity.title = todo.title
                        todoEntity.text = todo.text
                        todoEntity.completed = todo.completed
                        todoEntity.date = todo.date.toString()
                        
                        try self.context.save()
                        
                        DispatchQueue.main.async {
                            if let index = self.todos.firstIndex(where: { $0.id == todo.id }) {
                                self.todos[index] = todo
                            } else {
                                print("Todo not found in todos array for update")
                            }
                            completion?()
                        }
                    } else {
                        print("Todo not found in Core Data for update")
                        DispatchQueue.main.async {
                            completion?()
                        }
                    }
                } catch {
                    print("Failed to update Todo in Core Data: \(error)")
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
    
    //MARK: Удаляем задачу
    func removeTodo(at indexPath: IndexPath, completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
            guard let self = self else {
                print("Error: self is nil")
                return
            }
            
            guard indexPath.row >= 0 && indexPath.row < self.todos.count else {
                print("Error: Invalid indexPath.row \(indexPath.row)")
                return
            }
            
            let todo = self.todos[indexPath.row]
            print("Removing Todo with ID: \(todo.id)")
            
            DispatchQueue.main.async {
                
                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
                
                do {
                    let results = try self.context.fetch(fetchRequest)
                    if let todoEntity = results.first {
                        self.context.delete(todoEntity)
                        try self.context.save()
                        
                        DispatchQueue.main.async {
                            self.todos.remove(at: indexPath.row)
                            completion?()
                        }
                    } else {
                        print("Error: TodoEntity not found for ID: \(todo.id)")
                        DispatchQueue.main.async {
                            completion?()
                        }
                    }
                } catch {
                    print("Error: Failed to delete Todo: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
    
    //MARK: Удаляем все данные
    public func removeAllData(completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
            guard let self = self else {
                print("Error: Self is nil during removeAllData task")
                return
            }
            
            DispatchQueue.main.async {
                
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoEntity")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    try self.context.execute(deleteRequest)
                    try self.context.save()
                    
                    DispatchQueue.main.async {
                        self.todos.removeAll()
                        print("All data removed successfully")
                        completion?()
                    }
                } catch {
                    print("Error: Failed to delete all data: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
    
    //MARK: Сохраняем контекст
    private func saveChanges(completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
            DispatchQueue.main.async {
                
                guard let self = self else { return }
                do {
                    try self.context.save()
                    DispatchQueue.main.async {
                        completion?()
                    }
                } catch {
                    print("Failed to save changes: \(error)")
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
    
}

