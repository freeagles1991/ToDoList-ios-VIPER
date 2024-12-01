//
//  TaskEditViewControllerTests.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 01.12.2024.
//

import XCTest
@testable import ToDoList_ios_VIPER

final class TaskEditViewControllerTests: XCTestCase {
    private var viewController: TaskEditViewControllerImpl!
    private var mockPresenter: MockTaskEditPresenter!

    override func setUp() {
        super.setUp()
        mockPresenter = MockTaskEditPresenter()
        viewController = TaskEditViewControllerImpl()
        viewController.presenter = mockPresenter
        _ = viewController.view // Загрузка view
    }

    func testViewDidLoad_CallsPresenterViewDidLoad() {
        XCTAssertTrue(mockPresenter.viewDidLoadCalled)
    }

    func testViewWillDisappear_CallsPresenterDidFinishEditing() {
        viewController.viewWillDisappear(false)
        XCTAssertTrue(mockPresenter.didFinishEditingCalled)
    }
}
