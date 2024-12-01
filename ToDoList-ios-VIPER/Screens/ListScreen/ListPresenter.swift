//
//  ListPresenter.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation

protocol ListPresenter: AnyObject {
    func viewDidLoad()
    func fetchTodos()
    func searchTodos(byTitle title: String)
    func didUpdateTodosCount(with count: Int)
    func toggleTodoCompleteState(_ todo: Todo, at indexPath: IndexPath)
    func didToggleTodoState(at indexPath: IndexPath)
    func removeTodo(at indexPath: IndexPath)
    func didRemovedTodo(at indexPath: IndexPath)
    func openTaskEdit(for todo: Todo, isNewTask: Bool, indexPath: IndexPath?)
    func numberOfTodos() -> Int
    func getTodo(at indexPath: IndexPath) -> Todo
}

final class ListPresenterImpl: ListPresenter {
    enum Constants {
        static var footerText = "задач"
    }
    
    weak var view: ListViewController?
    var interactor: ListInteractor?
    var router: ListRouter?
    
    func viewDidLoad() {
        fetchTodos()
        interactor?.setupTodoStore()
    }
    
    func searchTodos(byTitle title: String) {
        interactor?.searchTodos(byTitle: title) { [weak self] in
            self?.view?.reloadData()
        }
    }
    
    func didUpdateTodosCount(with count: Int) {
        let text = "\(count) \(Constants.footerText)"
        view?.updateFooter(text: text)
    }
    
    func toggleTodoCompleteState(_ todo: Todo, at indexPath: IndexPath) {
        interactor?.toggleTodoCompleteState(todo, at: indexPath)
    }
    
    func didToggleTodoState(at indexPath: IndexPath) {
        view?.reloadRow(at: indexPath)
    }
    
    func removeTodo(at indexPath: IndexPath) {
        interactor?.removeTodo(at: indexPath)
    }
    
    func didRemovedTodo(at indexPath: IndexPath) {
        view?.deleteRow(at: indexPath)
    }
    
    func openTaskEdit(for todo: Todo, isNewTask: Bool, indexPath: IndexPath?) {
        guard let todoStore = interactor?.getTodoStore() else {return}
        router?.navigateToTaskEdit(
            todo: todo,
            todoStore: todoStore,
            isNewTask: isNewTask,
            indexPath: indexPath,
            onTaskCreated: { [weak self] in
                self?.view?.reloadData()
            },
            onTaskUpdated: { [weak self] in
                if let indexPath = indexPath {
                    self?.view?.reloadRow(at: indexPath)
                }
            }
        )
    }
    
    func numberOfTodos() -> Int {
        guard let interactor else {return 0}
        return interactor.numberOfTodos()
    }
    
    func getTodo(at indexPath: IndexPath) -> Todo {
        guard let interactor else {return Todo.defaultTodo}
        return interactor.getTodo(at: indexPath)
    }
    
    func fetchTodos() {
        interactor?.fetchTodos { [weak self] in
            self?.view?.reloadData()
        }
    }
    
    
    
}
