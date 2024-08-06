//
//  CartView.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

class CartView: UIView {
    
    // MARK: - UI Components
    let headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
                          paddingLeft: 16, paddingBottom: 100,
                          width: 140, height: 44)
        
        completeButton.anchor(bottom: bottomAnchor, right: rightAnchor,
                              paddingBottom: 100, paddingRight: 16,
                              width: 140, height: 44)
        
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    func updateTotalPrice(with price: String) {
        totalLabel.text = "Total: $\(price)"
    }
    @objc private func completeButtonTapped() {
        CartManager.shared.clearCart()
    }
}
