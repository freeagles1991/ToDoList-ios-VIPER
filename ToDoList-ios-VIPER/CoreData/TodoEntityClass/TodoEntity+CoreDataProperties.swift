//
//  TodoEntity+CoreDataProperties.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 26.11.2024.
//
//

import Foundation
import CoreData


extension TodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoEntity> {
        return NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var date: String
    @NSManaged public var id: UUID
    @NSManaged public var text: String?
    @NSManaged public var title: String

}

extension TodoEntity: Identifiable {
    func toTodo() -> Todo {
        return Todo(
            id: self.id,
            title: self.title,
            text: self.text,
            completed: self.completed,
            date: self.date.toDate())
    }
}

extension Todo {
    func toEntity(context: NSManagedObjectContext) -> TodoEntity {
        let entity = TodoEntity(context: context)
        entity.id = id
        entity.date = date.toString()
        entity.text = text
        entity.title = title
        entity.completed = completed
        return entity
    }
}
