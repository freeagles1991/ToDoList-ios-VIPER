//
//  MockTaskEditViewController.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 01.12.2024.
//

import Foundation
import UIKit
@testable import ToDoList_ios_VIPER

class MockTaskEditViewController: UIViewController, TaskEditViewController {
    var displayedTitle: String?
    var displayedDate: String?
    var displayedText: String?
    
    func displayTodoData(title: String, date: String, text: String?) {
        displayedTitle = title
        displayedDate = date
        displayedText = text
    }
}
