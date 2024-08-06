//
//  FavoriteProductTableViewCell.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

class FavoriteProductTableViewCell: UITableViewCell {

    // UI Components
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.addTarget(FavoriteProductTableViewCell.self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()

    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI Setup
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(removeButton)

        nameLabel.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         right: contentView.rightAnchor,
                         paddingTop: 8,
                         paddingLeft: 16,
                         paddingRight: 16)
        
        priceLabel.anchor(top: nameLabel.bottomAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          paddingTop: 4,
                          paddingLeft: 16,
                          paddingRight: 16)
        
        removeButton.anchor(top: contentView.topAnchor,
                            right: contentView.rightAnchor,
                            paddingTop: 8,
                            paddingRight: 16)
    }
    
    // Configure cell with product data
    func configure(with product: HomeModel) {
        nameLabel.text = product.name
        priceLabel.text = "$\(product.price ?? "0")"
    }
    
    @objc private func removeButtonTapped() {
        // This will be implemented in the view controller
        NotificationCenter.default.post(name: Notification.Name("RemoveFavoriteTapped"), object: self)
    }
}
