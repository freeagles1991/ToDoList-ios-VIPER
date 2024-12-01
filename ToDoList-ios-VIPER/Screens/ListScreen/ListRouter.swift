//
//  ListRouter.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

protocol ListRouter {
    
}

final class ListRouterImpl: ListRouter {
     weak var viewController: UIViewController?
}
