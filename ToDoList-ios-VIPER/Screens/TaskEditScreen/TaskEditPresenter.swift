//
//  TaskEditPresenter.swift
//  ToDoTaskEdit-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation

protocol TaskEditPresenter {
    func viewDidLoad()
    func didFinishEditing(title: String?, text: String?)
    func dismiss()
}

final class TaskEditPresenterImpl: TaskEditPresenter {

    // MARK: - Private Properties
    private weak var view: TaskEditViewController?
    private let interactor: TaskEditInteractor
    private let router: TaskEditRouter
    private let todo: Todo
    private let isNewTask: Bool
    private let onTaskCreated: (() -> Void)?
    private let onTaskUpdated: (() -> Void)?
    
    // MARK: - Initializers
    init(
        view: TaskEditViewController,
        interactor: TaskEditInteractor,
        router: TaskEditRouter,
        todo: Todo,
        isNewTask: Bool,
        onTaskCreated: (() -> Void)?,
        onTaskUpdated: (() -> Void)?
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.todo = todo
        self.isNewTask = isNewTask
        self.onTaskCreated = onTaskCreated
        self.onTaskUpdated = onTaskUpdated
    }


    // MARK: - Public Methods
    func viewDidLoad() {
        view?.displayTodoData(title: todo.title, date: todo.date.toString(), text: todo.text)
    }
    
    func didFinishEditing(title: String?, text: String?) {
        guard let title = title, !title.isEmpty else {
            print("Title is empty, task not saved")
            return
        }
        
        let updatedTodo = Todo(
            id: isNewTask ? UUID() : todo.id,
            title: title,
            text: text,
            completed: todo.completed,
            date: todo.date
        )
        
        if isNewTask {
            interactor.createTask(title: title, text: text) { [weak self] in
                self?.onTaskCreated?()
            }
        } else {
            interactor.updateTask(title: title, text: text) { [weak self] in
                self?.onTaskUpdated?()
            }
        }
    }
    
    func dismiss() {
        router.dismiss()
    }
}
