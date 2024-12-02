//
//  ListViewControllerTests.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 02.12.2024.
//

import XCTest
@testable import ToDoList_ios_VIPER

final class ListViewControllerTests: XCTestCase {
    var view: ListViewControllerImpl?
    var mockPresenter: MockListPresenter?
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockListPresenter()
        view = ListViewControllerImpl(presenter: mockPresenter)
        view?.loadViewIfNeeded()
    }
    
    override func tearDown() {
        view = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    func testViewDidLoad_CallsPresenterViewDidLoad() {
        guard let mockPresenter, let view else {return}
        view.viewDidLoad()
        XCTAssertTrue(mockPresenter.didReloadData, "Expected didReloadData to be true, but it was not.")
    }
}
