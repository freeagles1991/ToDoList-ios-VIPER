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

final class TodoStore: NSObject {
    var todos: [Todo] = []
    
    private var appDelegate: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("UIApplication.shared.delegate is not of type AppDelegate")
        }
        return delegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    private let backgroundQueue = DispatchQueue(label: "com.todoApp.backgroundQueue", qos: .userInitiated)
    
    //MARK: Public
    func numberOfRows() -> Int {
        return todos.count
    }

    func object(at indexPath: IndexPath) -> Todo {
        return todos[indexPath.row]
    }
    
    override init() {
        super.init()
    }
    
    //MARK: Загрузить задачи
    func fetchTodos(completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            do {
                let fetchedObjects = try self.context.fetch(fetchRequest)
                self.todos = fetchedObjects.compactMap { $0.toTodo() }
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                print("Failed to fetch Todos: \(error)")
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
    
    //MARK: Создаем задачу
    func addTodo(_ todo: Todo, completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            let _ = todo.toEntity(context: self.context)
            
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
    
    //MARK: Обновляем задачу
    func updateTodo(_ todo: Todo, completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            
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
    
    //MARK: Удаляем задачу
    func removeTodo(at indexPath: IndexPath, completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            let todo = self.todos[indexPath.row]
            
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
                }
            } catch {
                print("Failed to delete Todo: \(error)")
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
    
    //MARK: Удаляем все данные
    public func removeAllData(completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoEntity")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try self.context.execute(deleteRequest)
                
                try self.context.save()
                
                DispatchQueue.main.async {
                    self.todos.removeAll()
                    completion?()
                }
            } catch {
                print("Failed to delete all data: \(error)")
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
    
    //MARK: Сохраняем контекст
    private func saveChanges(completion: (() -> Void)? = nil) {
        backgroundQueue.async { [weak self] in
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

