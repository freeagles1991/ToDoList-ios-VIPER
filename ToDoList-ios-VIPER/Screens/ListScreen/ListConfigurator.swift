//
//  ListConfigurator.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

final class ListConfigurator {
    static func build(todoStore: TodoStore) -> UIViewController {
        let view = ListViewControllerImpl()
        let router = ListRouterImpl()
        let presenter = ListPresenterImpl()
        let interactor = ListInteractorImpl(presenter: presenter, todoStore: todoStore)

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        view.presenter = presenter
        router.viewController = view

        return view
    }
}

