//
//  TaskEditRouter.swift
//  ToDoTaskEdit-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

protocol TaskEditRouter {
    func dismiss()
}

final class TaskEditRouterImpl: TaskEditRouter {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
