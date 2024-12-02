//
//  ListPresenterTests.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 02.12.2024.
//

import XCTest
@testable import ToDoList_ios_VIPER

final class ListPresenterTests: XCTestCase {
    var presenter: ListPresenterImpl?
    var mockView: MockListView?
    var mockInteractor: MockListInteractor?
    var mockRouter: MockListRouter?
    
    override func setUp() {
        super.setUp()
        mockView = MockListView()
        mockInteractor = MockListInteractor()
        mockRouter = MockListRouter()
        presenter = ListPresenterImpl()
        presenter?.view = mockView
        presenter?.interactor = mockInteractor
        presenter?.router = mockRouter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testViewDidLoad_CallsSetupTodoStore() {
        guard let presenter, let mockInteractor else {return}
        presenter.viewDidLoad()
        XCTAssertTrue(mockInteractor.didCallSetupTodoStore, "setupTodoStore() should have been called on the interactor")
    }
    
    func testSearchTodos_CallsInteractorAndReloadsData() {
        presenter?.searchTodos(byTitle: "Test")
        XCTAssertEqual(mockInteractor?.searchQuery, "Test")
        XCTAssertTrue(((mockView?.didReloadData) != nil))
    }
    
    func testToggleTodoCompleteState_CallsInteractor() {
        let todo = Todo.defaultTodo
        let indexPath = IndexPath(row: 0, section: 0)
        presenter?.toggleTodoCompleteState(todo, at: indexPath)
        XCTAssertEqual(mockInteractor?.toggledTodo, todo)
    }
    
    func testRemoveTodo_CallsInteractor() {
        let indexPath = IndexPath(row: 0, section: 0)
        presenter?.removeTodo(at: indexPath)
        XCTAssertEqual(mockInteractor?.removedIndexPath, indexPath)
    }
}
