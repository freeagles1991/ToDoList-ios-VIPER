//
//  TaskEditInteractorTests.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 01.12.2024.
//

import XCTest
@testable import ToDoList_ios_VIPER

final class TaskEditInteractorTests: XCTestCase {
    private var interactor: TaskEditInteractorImpl!
    private var mockTodoStore: MockTodoStore!
    private var todo: Todo!

    override func setUp() {
        super.setUp()
        todo = Todo(id: UUID(), title: TestConstants.testString, text: nil, completed: false, date: Date())
        mockTodoStore = MockTodoStore()
        interactor = TaskEditInteractorImpl(todo: todo, isNewTask: true, todoStore: mockTodoStore)
    }

    func testCreateTask_CallsAddTodoOnStore() {
        interactor.createTask(title: TestConstants.testString, text: nil) {
            XCTAssertTrue(self.mockTodoStore.addTodoCalled)
        }
    }

    func testUpdateTask_CallsUpdateTodoOnStore() {
        interactor = TaskEditInteractorImpl(todo: todo, isNewTask: false, todoStore: mockTodoStore)
        interactor.updateTask(title: TestConstants.testString, text: TestConstants.testString) {
            XCTAssertTrue(self.mockTodoStore.updateTodoCalled)
        }
    }
}
