//
//  ListCell.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

final class ListCell: UITableViewCell {
    // MARK: - Public Properties
    enum Constants {
        static let identifier = "ListCell"
    }

    // MARK: - Private Properties
    private lazy var checkmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("◻︎", for: .normal) // Стиль невыбранного чекмарка
        button.setTitle("✔︎", for: .selected) // Стиль выбранного чекмарка
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        checkmarkButton.isSelected = false
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
    }

    // MARK: - Actions
    @objc private func checkmarkTapped() {
        checkmarkButton.isSelected.toggle()
    }

    // MARK: - Public Methods
    func configure(title: String, description: String, date: String, isCompleted: Bool) {
        titleLabel.text = title
        descriptionLabel.text = description
        dateLabel.text = date
        checkmarkButton.isSelected = isCompleted
    }

    // MARK: - Private Methods
    private func setupView() {
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            // Checkmark Button
            checkmarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkmarkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 30),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 30),

            // Content StackView
            contentStackView.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
