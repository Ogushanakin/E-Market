//
//  HomeViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemBlue
        return label
    }()

    let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        return label
    }()

    let increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = .systemGroupedBackground
        button.layer.cornerRadius = 5
        return button
    }()

    let decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .darkGray
        button.setTitle("-", for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.layer.cornerRadius = 5
        return button
    }()

    var product: Product?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UI Setup
    private func setupUI() {
        backgroundColor = .white
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(increaseButton)
        contentView.addSubview(decreaseButton)

        nameLabel.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         right: contentView.rightAnchor,
                         paddingTop: 36,
                         paddingLeft: 20,
                         paddingRight: 16)
        
        priceLabel.anchor(top: nameLabel.bottomAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          paddingTop: 4,
                          paddingLeft: 20,
                          paddingRight: 16)
        
        quantityLabel.centerY(inView: contentView)
        quantityLabel.anchor(right: contentView.rightAnchor,
                             paddingRight: 80,
                             width: 50, height: 50)
        
        increaseButton.anchor(left: quantityLabel.rightAnchor,
                              paddingLeft: 0,
                              width: 50,
                              height: 46)
        increaseButton.centerY(inView: quantityLabel)
        
        decreaseButton.anchor(right: quantityLabel.leftAnchor,
                              paddingRight: 0,
                              width: 50,
                              height: 46)
        decreaseButton.centerY(inView: quantityLabel)

    }
    
    private func setupActions() {
        increaseButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        decreaseButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
    }
    
    // Configure cell with product data
    func configure(with product: Product) {
        self.product = product
        nameLabel.text = product.name
        priceLabel.text = "$\(product.price ?? "0")"
        quantityLabel.text = "\(product.count)"
    }

    @objc private func increaseQuantity() {
        guard var product = product else { return }
        product.count += 1
        CartManager.shared.addToCart(item: product)
        configure(with: product) // Update with new data
    }

    @objc private func decreaseQuantity() {
        guard var product = product else { return }
        if product.count > 1 {
            product.count -= 1
            CartManager.shared.removeFromCart(item: product)
        } else {
            CartManager.shared.removeFromCart(item: product)
        }
        configure(with: product)
    }
}
