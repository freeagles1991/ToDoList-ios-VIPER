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
    
    init(presenter: ListPresenter? = nil, networkClient: NetworkClientProtocol) {
        self.presenter = presenter
        self.networkClient = networkClient
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
        
        loadData()
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
            case .success(let todos):
                guard let self else {return}
                print("Загружено \(todos.todos.count) задач")
            case .failure(let error):
                print("Ошибка при загрузке \(error)")
            }
        }
    }

}

// MARK: - UITableViewDataSource
extension ListViewControllerImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.Constants.identifier, for: indexPath) as? ListCell else {return UITableViewCell()}
        cell.configure(title: "Название", description: "Описание", date: "01/01/2020", isCompleted: false)
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