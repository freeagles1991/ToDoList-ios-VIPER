//
//  MockListView.swift
//  ToDoList-ios-VIPERTests
//
//  Created by Дима on 02.12.2024.
//

import Foundation
@testable import ToDoList_ios_VIPER
import UIKit

final class MockListView: UIViewController, ListViewController {
    var didReloadData = false
    var footerText: String?
    
    func reloadData() {
        didReloadData = true
    }
    
    func fetchTodos() {}
    
    func updateFooter(text: String) {
        footerText = text
    }
    
    func reloadRow(at indexPath: IndexPath) {}
    
    func deleteRow(at indexPath: IndexPath) {}
}
