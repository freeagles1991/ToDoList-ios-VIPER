//
//  ListView.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

protocol ListViewController: UIViewController {
    
}

final class ListViewControllerImpl: UIViewController, ListViewController {
    // MARK: - Public Properties
    var presenter: ListPresenter?
    let networkClient: NetworkClientProtocol
    let todoStore: TodoStore
    
    enum Constants {
        static var title = "Задачи"
        static var searchBarPlaceholder = "Search"
    }
    
    // MARK: - Private Properties
    private let configurator: ListConfigurator = ListConfiguratorImpl()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
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
        return tableView
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
        
        addSubviews()
        setupNavigation()
        setupTableView()
        
        //loadData()
    }
    // MARK: - Actions

    // MARK: - Public Methods

    // MARK: - Private Methods
    
    private func addSubviews(){
        view.addSubview(tableView)
    }
    
    private func setupNavigation() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
       
    
    private func setupTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadData() {
        guard let url = URL(string: GlobalConstants.apiUrl) else { return }
        networkClient.get(from: url, type: TodosResponse.self) { [weak self] result in
            switch result {
            case .success(let todosResponse):
                guard let self else {return}
                let todos = todosResponse.toTodos()
                for todo in todos {
                    todoStore.createTodo(with: todo)
                }
            case .failure(let error):
                print("Ошибка при загрузке \(error)")
            }
        }
    }
    
    private func editTodo(_ todo: Todo) {
        print("Editing Todo: \(todo)")
        // Редактируем в отдельном экране
    }

    private func shareTodo(_ todo: Todo) {
        print("Sharing Todo: \(todo)")
        // Обработать
    }

    private func deleteTodo(_ todo: Todo) {
        print("Deleting Todo: \(todo)")
        // Удаляем из БД
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
                self.editTodo(todo)
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
                self.deleteTodo(todo)
            }
            return UIMenu(title: "", children: [editTodo, shareTodo, deleteTodo])
        }
        return config
    }
}

// MARK: - UITableViewDataSource
extension ListViewControllerImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(todoStore.numberOfRowsInSection(section))
        return todoStore.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.Constants.identifier, for: indexPath) as? ListCell else {return UITableViewCell()}
        cell.configure(with: todoStore.object(at: indexPath))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewControllerImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Selected: \(data[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension ListViewControllerImpl: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //guard let searchText = searchController.searchBar.text else { return }
        //обработка фильтрации
    }
}
