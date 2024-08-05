//
//  CartViewController.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit
import SnapKit

class CartViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "productCell")
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotificationObserver()
        updateTotalPrice()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(totalLabel)
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200) // Düzeltilmiş
        }
        
        totalLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100) // Düzeltilmiş
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartDidUpdate), name: CartManager.shared.cartDidUpdateNotification, object: nil)
    }
    
    @objc private func cartDidUpdate() {
        tableView.reloadData()
        updateTotalPrice()
    }
    
    private func updateTotalPrice() {
        let total = CartManager.shared.cartItems.reduce(0.0) { result, item in
            guard let price = Double(item.price ?? "0") else { return result }
            return result + price * Double(item.count)
        }
        totalLabel.text = "Total: $\(String(format: "%.2f", total))"
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let product = CartManager.shared.cartItems[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: product)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
