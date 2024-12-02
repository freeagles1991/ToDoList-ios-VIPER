//
//  TaskEditInteractorTests.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 01.12.2024.
//

import XCTest
@testable import ToDoList_ios_VIPER

final class TaskEditInteractorTests: XCTestCase {
    private var interactor: TaskEditInteractorImpl?
    private var mockTodoStore: MockTodoStore?
    private var todo: Todo?
    
    override func setUp() {
        super.setUp()
        todo = Todo(id: UUID(), title: TestConstants.testString, text: nil, completed: false, date: Date())
        mockTodoStore = MockTodoStore()
        guard  let mockTodoStore, let todo else {return}
        interactor = TaskEditInteractorImpl(todo: todo, isNewTask: true, todoStore: mockTodoStore)
    }
    
    func testCreateTask_CallsAddTodoOnStore() {
        guard let interactor = interactor,
              let mockTodoStore = mockTodoStore else {
            XCTFail("Interactor or MockTodoStore is nil")
            return
        }
        
        interactor.createTask(title: TestConstants.testString, text: nil) {
            XCTAssertTrue(mockTodoStore.addTodoCalled, "addTodo should have been called on the store")
        }
    }
    
    func testUpdateTask_CallsUpdateTodoOnStore() {
        guard let mockTodoStore = mockTodoStore,
              let todo = todo else {
            XCTFail("MockTodoStore or Todo is nil")
            return
        }
        interactor = TaskEditInteractorImpl(todo: todo, isNewTask: false, todoStore: mockTodoStore)
        interactor?.updateTask(title: TestConstants.testString, text: TestConstants.testString) {
            XCTAssertTrue(mockTodoStore.updateTodoCalled, "updateTodo should have been called on the store")
        }
    }
}
