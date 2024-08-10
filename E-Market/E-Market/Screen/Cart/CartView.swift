//
//  CartView.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

final class CartView: UIView {
    
    // MARK: - UI Components
    let headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "Cart"
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "productCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let messageLabel = UILabel()
        messageLabel.text = "Your cart is empty"
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(messageLabel)
        messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let cartManager = CartManager()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .systemBlue
        addSubview(headerView)
        addSubview(tableView)
        
        headerView.anchor(top: safeAreaLayoutGuide.topAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          height: 60)
        
        tableView.anchor(top: headerView.bottomAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor, right: rightAnchor,
                         paddingTop: 0,
                         paddingLeft: 0,
                         paddingBottom: 180)
        
        let view = UIView()
        view.backgroundColor = .white
        addSubview(view)
        view.anchor(top: tableView.bottomAnchor,
                    left: leftAnchor,
                    bottom: bottomAnchor, right: rightAnchor,
                    paddingTop: 0,
                    paddingLeft: 0,
                    paddingBottom: 0)
        
        addSubview(totalLabel)
        addSubview(completeButton)
        totalLabel.anchor(left: leftAnchor, bottom: bottomAnchor,
                          paddingLeft: 10, paddingBottom: 100,
                          width: 164, height: 44)
        
        completeButton.anchor(bottom: bottomAnchor, right: rightAnchor,
                              paddingBottom: 100, paddingRight: 16,
                              width: 140, height: 44)
        
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        addSubview(emptyView)
        emptyView.anchor(top: headerView.bottomAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor)
        emptyView.isHidden = true
    }
    
    func updateTotalPrice(with price: String) {
        totalLabel.text = "Total: $\(price)"
    }
    
    func updateCartView(isEmpty: Bool) {
        tableView.isHidden = isEmpty
        emptyView.isHidden = !isEmpty
    }
    
    @objc private func completeButtonTapped() {
        cartManager.clearCart()
    }
}
