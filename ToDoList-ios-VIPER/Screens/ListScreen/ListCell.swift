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
    var onCheckmarkTapped: (() -> Void)?
    
    enum Constants {
        static let identifier = "ListCell"
    }

    // MARK: - Private Properties
    private lazy var checkmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let normalImage = UIImage(systemName: "circle")
        let selectedImage = UIImage(systemName: "checkmark.circle")

        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        
        button.tintColor = .white
        button.backgroundColor = .clear
        
        button.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont.regular16
        //label.textColor = .dynamicBlack
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular12
        label.textColor = .dynamicBlack
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular12
        label.textColor = .dynamicGray
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
        onCheckmarkTapped?()
    }
    
    private func updateCellState() {
        updateButtonState()
        updateTextFontStyle()
    }
    
    private func updateButtonState() {
        checkmarkButton.tintColor = checkmarkButton.isSelected ? .systemYellow : .white
    }
    

    private func updateTextFontStyle() {
        descriptionLabel.textColor = checkmarkButton.isSelected ? .dynamicGray : .dynamicBlack
        
        let attributedText = NSAttributedString(
            string: titleLabel.text ?? "",
            attributes: checkmarkButton.isSelected
                ? [
                    .font: UIFont.regular16,
                    .foregroundColor: UIColor.dynamicGray,
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
                : [
                    .font: UIFont.regular16,
                    .foregroundColor: UIColor.dynamicBlack,
                    .strikethroughStyle: 0
                ]
        )
        
        titleLabel.attributedText = attributedText
    }

    // MARK: - Public Methods
    func configure(with todo: Todo, onCheckmarkTapped: @escaping () -> Void) {
        self.onCheckmarkTapped = onCheckmarkTapped
        titleLabel.text = todo.title
        descriptionLabel.text = todo.text
        dateLabel.text = todo.date.toString()
        checkmarkButton.isSelected = todo.completed
        updateCellState()
    }
    

    // MARK: - Private Methods
    private func setupView() {
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            checkmarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            checkmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 24),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 24),

            contentStackView.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
