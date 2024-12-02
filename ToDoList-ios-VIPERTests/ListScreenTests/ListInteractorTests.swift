//
//  ListInteractorTests.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 02.12.2024.
//

import XCTest
@testable import ToDoList_ios_VIPER

final class ListInteractorTests: XCTestCase {
    var interactor: ListInteractorImpl?
    var mockPresenter: MockListPresenter?
    var mockTodoStore: MockTodoStoreForList?
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockListPresenter()
        mockTodoStore = MockTodoStoreForList()
        interactor = ListInteractorImpl(presenter: mockPresenter, todoStore: mockTodoStore ?? MockTodoStoreForList())
    }
    
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockTodoStore = nil
        super.tearDown()
    }
    
    func testFetchTodos_UpdatesPresenterOnCompletion() {
        interactor?.fetchTodos {
            XCTAssertTrue(((self.mockPresenter?.didReloadData) != nil))
        }
    }
    
    func testToggleTodoCompleteState_UpdatesTodo() {
        let todo = Todo.defaultTodo
        let indexPath = IndexPath(row: 0, section: 0)
        interactor?.toggleTodoCompleteState(todo, at: indexPath)
        XCTAssertEqual(mockTodoStore?.updatedTodo, todo)
    }
}
