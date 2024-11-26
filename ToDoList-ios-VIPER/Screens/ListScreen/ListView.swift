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
    private let data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]

    // MARK: - Initializers

    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure()
        view.backgroundColor = .systemBackground
        
        addSubviews()
        setupNavigation()
        setupTableView()
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

}

// MARK: - UITableViewDataSource
extension ListViewControllerImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
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
        print("Selected: \(data[indexPath.row])")
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
