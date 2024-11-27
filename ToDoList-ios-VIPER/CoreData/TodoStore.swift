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
    
    private var appDelegate: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("UIApplication.shared.delegate is not of type AppDelegate")
        }
        return delegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    var fetchedResultsController: NSFetchedResultsController<TodoEntity>?
    private var lastUsedPredicate: NSPredicate = NSPredicate()
    
    //MARK: Public
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    func object(at indexPath: IndexPath) -> Todo? {
        guard let fetchedResultsController else { return Todo.defaultTodo }
        let todoEntity = fetchedResultsController.object(at: indexPath)
        return todoEntity.toTodo()
    }
    
    override init() {
        super.init()
        let predicate = NSPredicate(value: true)
        setupFetchedResultsController(predicate)
    }
    
    // MARK: Настраиваем FRC
    func setupFetchedResultsController(_ predicate: NSPredicate) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]
        
        lastUsedPredicate = predicate
        
        fetchRequest.predicate = predicate
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Не удалось выполнить выборку данных: \(error)")
        }
    }
    
    // MARK: Обновляем предикат в FRC
    func updateFetchedResultsController(with predicate: NSPredicate, titlePredicate: NSPredicate? = nil) {
        
        lastUsedPredicate = predicate

        let combinedPredicate = combinePredicates(basePredicate: predicate, titlePredicate: titlePredicate)

        fetchedResultsController?.fetchRequest.predicate = combinedPredicate
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Ошибка при выполнении выборки: \(error)")
        }
    }
    
    // MARK: Объединяем предикаты
    private func combinePredicates(basePredicate: NSPredicate, titlePredicate: NSPredicate?) -> NSPredicate {
        if let titlePredicate = titlePredicate {
            return NSCompoundPredicate(andPredicateWithSubpredicates: [basePredicate, titlePredicate])
        } else {
            return basePredicate
        }
    }
    
    //MARK: Все задачи
    public func fetchTodos() -> [Todo]? {
        let predicate = NSPredicate(value: true)
        
        self.updateFetchedResultsController(with: predicate)
        
        guard let fetchedObjects = fetchedResultsController?.fetchedObjects else {
            return []
        }
        
        return fetchedObjects.compactMap { todoEntity in
            todoEntity.toTodo()
        }
    }
    
    //MARK: Создаем задачу
    public func createTodo(with todo: Todo) {
        let todoEntity = todo.toEntity(context: context)
        
        saveChanges()
        print("TodoEntity created and saved: \(todoEntity.title)")
    }
    
    //MARK: Обновляем задачу
    public func updateTodo(for todo: Todo) {
        let predicate = NSPredicate(format: "id == %d", todo.id as CVarArg)

        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = predicate

        do {
            let results = try context.fetch(fetchRequest)
            guard let todoEntity = results.first else {
                print("Todo not found")
                return
            }

            todoEntity.title = todo.title
            todoEntity.completed = todo.completed
            todoEntity.text = todo.text
            todoEntity.date = todo.date.toString()

            saveChanges()
            print("Todo updated successfully: \(todoEntity)")
        } catch {
            print("Failed to update Todo: \(error)")
        }
    }
    
    //MARK: Удаляем задачу
    public func removeTodo(with id: UUID) {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = predicate

        do {
            let results = try context.fetch(fetchRequest)
            guard let todoEntity = results.first else {
                print("Todo not found")
                return
            }

            context.delete(todoEntity)
            saveChanges()
            print("Todo deleted successfully: \(todoEntity)")
        } catch {
            print("Failed to delete Todo: \(error)")
        }
    }
    
    //MARK: Сохраняем контекст
    private func saveChanges() {
        if context.hasChanges {
            do {
                try context.save()
                print("Changes saved successfully.")
            } catch {
                print("Failed to save changes: \(error)")
            }
        }
    }
    
}

