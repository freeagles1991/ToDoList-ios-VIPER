//
//  ListRouter.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

protocol ListRouter {
    func navigateToTaskEdit(
            todo: Todo,
            todoStore: TodoStore,
            isNewTask: Bool,
            indexPath: IndexPath?,
            onTaskCreated: @escaping () -> Void,
            onTaskUpdated: @escaping () -> Void
        )
}

final class ListRouterImpl: ListRouter {
     weak var viewController: UIViewController?
    
    func navigateToTaskEdit(
            todo: Todo,
            todoStore: TodoStore,
            isNewTask: Bool,
            indexPath: IndexPath?,
            onTaskCreated: @escaping () -> Void,
            onTaskUpdated: @escaping () -> Void
        ) {
            let editVC = TaskEditConfiguratorImpl.build(
                todoStore: todoStore,
                todo: todo,
                isNewTask: isNewTask,
                onTaskCreated: onTaskCreated,
                onTaskUpdated: onTaskUpdated
            )
            viewController?.navigationController?.pushViewController(editVC, animated: true)
        }
}
