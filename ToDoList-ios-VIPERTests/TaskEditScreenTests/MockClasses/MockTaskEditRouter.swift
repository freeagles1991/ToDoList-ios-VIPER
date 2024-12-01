//
//  MockTaskEditRouter.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 01.12.2024.
//

import Foundation
@testable import ToDoList_ios_VIPER

class MockTaskEditRouter: TaskEditRouter {
    var dismissCalled = false

    func dismiss() {
        dismissCalled = true
    }
}
