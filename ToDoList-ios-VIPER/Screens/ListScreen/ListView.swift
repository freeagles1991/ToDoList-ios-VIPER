//
//  ListView.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

protocol ListViewController: UIViewController {
    func loadData()
}

final class ListViewControllerImpl: UIViewController, ListViewController {
    // MARK: - Public Properties
    var presenter: ListPresenter?
    let networkClient: NetworkClientProtocol
    let todoStore: TodoStore
    
    enum Constants {
        static var title = "Задачи"
        static var searchBarPlaceholder = "Search"
        static var footerText = "задач"
    }
    
    // MARK: - Private Properties
    private let configurator: ListConfigurator = ListConfiguratorImpl()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarPlaceholder
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.Constants.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        return tableView
    }()
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .yaGray
        footerView.translatesAutoresizingMaskIntoConstraints = false
        return footerView
    }()
    
    private lazy var safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .yaGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.dynamicBlack
        label.font = UIFont.regular11
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNewTaskTapped), for: .touchUpInside)
        return button
    }()
    
    private var tasks: [Todo] = []

    // MARK: - Initializers
    
    init(presenter: ListPresenter? = nil, networkClient: NetworkClientProtocol, todoStore: TodoStore) {
        self.presenter = presenter
        self.networkClient = networkClient
        self.todoStore = todoStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure()
        view.backgroundColor = .systemBackground
        
        setupTodoStore()
        addSubviews()
        setupNavigation()
        setupConstraints()
        
    }
    // MARK: - Actions
    @objc private func addNewTaskTapped() {
        print("Add New Task Tapped")
        openTaskEditVC(for: Todo.newTodo, isNewTask: true)
    }

    // MARK: - Public Methods
    func loadData() {
        todoStore.fetchTodos { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func addSubviews(){
        view.addSubview(tableView)
        view.addSubview(footerView)
        view.addSubview(safeAreaBackgroundView)
        footerView.addSubview(footerLabel)
        footerView.addSubview(addTaskButton)
    }
    
    private func setupNavigation() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
       
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            safeAreaBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            safeAreaBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 50),
            
            footerLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            footerLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            
            addTaskButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            addTaskButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTodoStore() {
        todoStore.onDataUpdate = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.footerLabel.text = "\(self.todoStore.numberOfRows()) \(Constants.footerText)"
            }
        }
    }
    
    private func searchTodos(byTitle title: String) {
        guard !title.isEmpty else {
            todoStore.fetchTodos {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            return
        }
        
        todoStore.searchTodos(byTitle: title) {
            DispatchQueue.main.async {
                if self.todoStore.todos.isEmpty {
                    print("No results found for search query: \(title)")
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private func toggleTodoCompleteState(_ todo: Todo, at indexPath: IndexPath) {
        todoStore.updateTodo(todo) {
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    private func openTaskEditVC(for todo: Todo, isNewTask: Bool, indexPath: IndexPath? = nil) {
        let editVC = TaskEditViewControllerImpl(todo: todo, isNewTask: isNewTask)
        editVC.onDismiss = { [weak self] actionType, todo in
            switch actionType {
            case .created:
                if isNewTask {
                    self?.todoStore.addTodo(todo) {
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
            case .updated:
                if let indexPath = indexPath {
                    self?.todoStore.updateTodo(todo) {
                        DispatchQueue.main.async {
                            self?.tableView.reloadRows(at: [indexPath], with: .fade)
                        }
                    }
                }
            }
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    private func editTodo(_ todo: Todo, at indexPath: IndexPath) {
        print("Editing Todo at \(indexPath): \(todo)")
        openTaskEditVC(for: todo, isNewTask: false, indexPath: indexPath)
    }

    private func shareTodo(_ todo: Todo) {
        print("Sharing Todo: \(todo)")
        // Обработать
    }

    private func removeTodo(at indexPath: IndexPath) {
        todoStore.removeTodo(at: indexPath) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.deleteRows(at: [indexPath], with: .left)
            }
        }
    }
    
    // MARK: - Context Menu Configuration
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let todo = todoStore.object(at: indexPath)
        let config = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ in
            
            let editTodo = UIAction(
                title: "Редактировать",
                identifier: nil
            ) { [weak self] _ in
                guard let self else { return }
                self.editTodo(todo, at: indexPath)
            }
            
            let shareTodo = UIAction(
                title: "Поделиться",
                identifier: nil
            ) { [weak self] _ in
                guard let self else { return }
                self.shareTodo(todo)
            }
        
            let deleteTodo = UIAction(
                title: "Удалить",
                identifier: nil,
                attributes: .destructive
            ) { [weak self] _ in
                guard let self else { return }
                self.removeTodo(at: indexPath)
            }
            return UIMenu(title: "", children: [editTodo, shareTodo, deleteTodo])
        }
        return config
    }
}

// MARK: - UITableViewDataSource
extension ListViewControllerImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(todoStore.numberOfRows())
        return todoStore.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.Constants.identifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        let todo = todoStore.object(at: indexPath)
        
        cell.configure(with: todo) { [weak self] in
            guard let self = self else { return }
            
            guard let currentIndexPath = tableView.indexPath(for: cell) else { return }
            
            print("Checkmark tapped at row: \(currentIndexPath.row)")
            
            let updatedTodo = Todo(
                id: todo.id,
                title: todo.title,
                text: todo.text,
                completed: !todo.completed,
                date: todo.date
            )
            
            self.toggleTodoCompleteState(updatedTodo, at: currentIndexPath)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewControllerImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension ListViewControllerImpl: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        searchTodos(byTitle: searchText)
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        searchTodos(byTitle: "") // Загружаем все данные
    }
}
