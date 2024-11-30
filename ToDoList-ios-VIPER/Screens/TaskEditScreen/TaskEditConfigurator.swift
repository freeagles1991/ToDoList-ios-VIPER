//
//  TaskEditConfigurator.swift
//  ToDoTaskEdit-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

protocol TaskEditConfigurator {
    static func build(
        todoStore: TodoStore,
        todo: Todo,
        isNewTask: Bool,
        onTaskCreated: (() -> Void)?,
        onTaskUpdated: (() -> Void)?
    ) -> UIViewController
}

final class TaskEditConfiguratorImpl: TaskEditConfigurator {
    static func build(
        todoStore: TodoStore,
            todo: Todo,
            isNewTask: Bool,
            onTaskCreated: (() -> Void)? = nil,
            onTaskUpdated: (() -> Void)? = nil
        ) -> UIViewController {
            let view = TaskEditViewControllerImpl()
            let interactor = TaskEditInteractorImpl(todo: todo, isNewTask: isNewTask, todoStore: todoStore)
            let router = TaskEditRouterImpl(viewController: view)
            let presenter = TaskEditPresenterImpl(
                view: view,
                interactor: interactor,
                router: router,
                todo: todo,
                isNewTask: isNewTask,
                onTaskCreated: onTaskCreated,
                onTaskUpdated: onTaskUpdated
            )
            view.presenter = presenter
            return view
        }
}
