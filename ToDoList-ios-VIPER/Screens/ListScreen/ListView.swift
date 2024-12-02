//
//  ListView.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

protocol ListViewController: UIViewController {
    func reloadData()
    func fetchTodos()
    func updateFooter(text: String)
    func reloadRow(at indexPath: IndexPath)
    func deleteRow(at indexPath: IndexPath)
}

final class ListViewControllerImpl: UIViewController, ListViewController {
    
    // MARK: - Public Properties
    var presenter: ListPresenter?
    
    enum Constants {
        static var title = "Задачи"
        static var searchBarPlaceholder = "Search"
    }
    
    // MARK: - Private Properties
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarPlaceholder
        return searchController
    }()
    
    private lazy var loadingPlaceholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Загрузка данных..."
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
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
        footerView.backgroundColor = .dynamicLightGray
        footerView.translatesAutoresizingMaskIntoConstraints = false
        return footerView
    }()
    
    private lazy var safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .dynamicLightGray
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
        button.tintColor = .dynamicYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNewTaskTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers
    
    init(presenter: ListPresenter? = nil) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupCustomBackButton()
        addSubviews()
        setupNavigation()
        setupConstraints()
        
        toggleLoadingPlaceholder(isLoading: true)
        presenter?.viewDidLoad()
    }
    // MARK: - Actions
    @objc private func addNewTaskTapped() {
        print("Add New Task Tapped")
        openTaskEdit(for: Todo.newTodo, isNewTask: true)
    }
    
    // MARK: - Public Methods
    func fetchTodos() {
        toggleLoadingPlaceholder(isLoading: true)
        presenter?.fetchTodos()
    }
    
    func reloadData() {
        toggleLoadingPlaceholder(isLoading: false)
        tableView.reloadData()
    }
    
    func updateFooter(text: String) {
        self.footerLabel.text = text
    }
    
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func deleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    // MARK: - Private Methods

    private func setupCustomBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        backButton.tintColor = .dynamicYellow
        navigationItem.backBarButtonItem = backButton
    }
    
    private func addSubviews(){
        view.addSubview(tableView)
        view.addSubview(loadingPlaceholderView)
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
            
            loadingPlaceholderView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingPlaceholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingPlaceholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingPlaceholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
    
    private func toggleLoadingPlaceholder(isLoading: Bool) {
        tableView.isHidden = isLoading
        footerView.isHidden = isLoading
        loadingPlaceholderView.isHidden = !isLoading
    }
    
    private func searchTodos(byTitle title: String) {
        presenter?.searchTodos(byTitle: title)
    }
    
    private func toggleTodoCompleteState(_ todo: Todo, at indexPath: IndexPath) {
        presenter?.toggleTodoCompleteState(todo, at: indexPath)
    }
    
    private func openTaskEdit(for todo: Todo, isNewTask: Bool, indexPath: IndexPath? = nil) {
        presenter?.openTaskEdit(for: todo, isNewTask: isNewTask, indexPath: indexPath)
    }
    
    private func editTodo(_ todo: Todo, at indexPath: IndexPath) {
        print("Editing Todo at \(indexPath): \(todo)")
        openTaskEdit(for: todo, isNewTask: false, indexPath: indexPath)
    }

    private func shareTodo(_ todo: Todo) {
        print("Sharing Todo: \(todo)")
        // Обработать
    }

    private func removeTodo(at indexPath: IndexPath) {
        presenter?.removeTodo(at: indexPath)
    }
    
    // MARK: - Context Menu Configuration
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let todo = presenter?.getTodo(at: indexPath) else { return nil}
        
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
        return presenter?.numberOfTodos() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.Constants.identifier, for: indexPath) as? ListCell,
              let todo = presenter?.getTodo(at: indexPath) 
        else {
            return UITableViewCell()
        }
        
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
        searchTodos(byTitle: "")
    }
}
