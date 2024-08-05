//
//  HomeViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit
import SnapKit

class ProductTableViewCell: UITableViewCell {

    // UI Components
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.sizeToFit()
        return label
    }()

    let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    let increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        return button
    }()

    let decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        return button
    }()

    // Stored Property
    var product: HomeModel?

    // Initializer
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
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(quantityLabel)
        contentView.addSubview(increaseButton)
        contentView.addSubview(decreaseButton)

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        quantityLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(30)
        }

        increaseButton.snp.makeConstraints { make in
            make.leading.equalTo(quantityLabel.snp.trailing).offset(8)
            make.centerY.equalTo(quantityLabel)
            make.height.width.equalTo(50)
        }

        decreaseButton.snp.makeConstraints { make in
            make.trailing.equalTo(quantityLabel.snp.leading).offset(-8)
            make.centerY.equalTo(quantityLabel)
            make.height.width.equalTo(50)
        }
    }
    
    private func setupActions() {
        increaseButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        decreaseButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
    }
    
    // Configure cell with product data
    func configure(with product: HomeModel) {
        self.product = product
        nameLabel.text = product.name
        priceLabel.text = "$\(product.price ?? "0")"
        quantityLabel.text = "\(product.count)"
    }

    @objc private func increaseQuantity() {
        guard var product = product else { return }
        product.count += 1
        CartManager.shared.addToCart(item: product)
        configure(with: product) // Güncel verilerle yeniden yapılandır
    }

    @objc private func decreaseQuantity() {
        guard var product = product else { return }
        if product.count > 1 {
            product.count -= 1
            CartManager.shared.addToCart(item: product)
        } else {
            CartManager.shared.removeFromCart(item: product)
        }
        configure(with: product) // Güncel verilerle yeniden yapılandır
    }
}
