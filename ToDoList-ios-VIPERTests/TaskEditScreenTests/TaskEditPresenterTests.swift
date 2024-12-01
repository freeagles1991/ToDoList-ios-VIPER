//
//  TaskEditPresenterTests.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 01.12.2024.
//

import XCTest
@testable import ToDoList_ios_VIPER

final class TaskEditPresenterTests: XCTestCase {
    
    private var presenter: TaskEditPresenterImpl!
    private var mockView: MockTaskEditViewController!
    private var mockInteractor: MockTaskEditInteractor!
    private var mockRouter: MockTaskEditRouter!
    private var todo: Todo!
    
    override func setUp() {
        super.setUp()
        
        todo = Todo(id: UUID(), title: TestConstants.testString, text: TestConstants.testString, completed: false, date: Date())
        mockView = MockTaskEditViewController()
        mockInteractor = MockTaskEditInteractor()
        mockRouter = MockTaskEditRouter()
        presenter = TaskEditPresenterImpl(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter,
            todo: todo,
            isNewTask: true,
            onTaskCreated: nil,
            onTaskUpdated: nil
        )
    }
    
    func testViewDidLoad_DisplaysTodoData() {
        presenter.viewDidLoad()
        XCTAssertEqual(mockView.displayedTitle, todo.title)
        XCTAssertEqual(mockView.displayedText, todo.text)
        XCTAssertEqual(mockView.displayedDate, todo.date.toString())
    }
    
    func testDidFinishEditing_CreatesNewTask_WhenIsNewTaskTrue() {
        presenter.didFinishEditing(title: TestConstants.testString, text: TestConstants.testString)
        XCTAssertTrue(mockInteractor.createTaskCalled)
    }
    
    func testDidFinishEditing_UpdatesTask_WhenIsNewTaskFalse() {
        presenter = TaskEditPresenterImpl(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter,
            todo: todo,
            isNewTask: false,
            onTaskCreated: nil,
            onTaskUpdated: nil
        )
        presenter.didFinishEditing(title: TestConstants.testString, text: TestConstants.testString)
        XCTAssertTrue(mockInteractor.updateTaskCalled)
    }
    
    func testDismiss_CallsRouterDismiss() {
        presenter.dismiss()
        XCTAssertTrue(mockRouter.dismissCalled)
    }
    
    
}
