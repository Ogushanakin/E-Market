//
//  FilterCell.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkBox: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
        checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        checkBox.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstraints()
        checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkBox)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            checkBox.heightAnchor.constraint(equalToConstant: 24),

            nameLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func setUI(name: String, isChecked: Bool) {
        nameLabel.text = name
        checkBox.isSelected = isChecked
    }
    
    @objc private func checkBoxTapped() {
        checkBox.isSelected.toggle()
    }
}
