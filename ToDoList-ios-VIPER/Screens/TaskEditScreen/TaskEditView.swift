//
//  TaskEditView.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

enum TodoActionType {
    case created
    case updated
}

protocol TaskEditViewController: UIViewController {
    var onDismiss: ((TodoActionType, Todo) -> Void)? { get set }
}

final class TaskEditViewControllerImpl: UIViewController, TaskEditViewController, UITextFieldDelegate {
    
    // MARK: - Public Properties
    var onDismiss: ((TodoActionType, Todo) -> Void)?

    // MARK: - Private Properties
    private let todo: Todo
    private let isNewTask: Bool
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.bold34
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular12
        label.textColor = .dynamicGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.regular16
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.layer.borderWidth = 0
        textView.layer.shadowOpacity = 0
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = UIEdgeInsets.zero
        return textView
    }()
    
    // MARK: - Initializers
    init(todo: Todo, isNewTask: Bool) {
        self.todo = todo
        self.isNewTask = isNewTask
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let updatedTodo = Todo(
            id: isNewTask ? UUID() : todo.id,
            title: titleTextField.text ?? "",
            text: textView.text,
            completed: todo.completed,
            date: todo.date
        )
        
        let actionType: TodoActionType = isNewTask ? .created : .updated
        print(updatedTodo)
        onDismiss?(actionType, updatedTodo)
    }
    
    // MARK: - Actions

    // MARK: - Public Methods

    // MARK: - Private Methods
    
    private func setupSubviews() {
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(textView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func configure() {
        titleTextField.text = todo.title
        dateLabel.text = todo.date.toString()
        textView.text = todo.text
    }
    
}
