//
//  CartViewController.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit

class CartViewController: UIViewController {
    
    private let viewModel = CartViewModel()
    private let cartView = CartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        viewModel.onCartUpdated = { [weak self] in
            self?.updateUI()
        }
        updateUI()
    }
    
    private func setupView() {
        view.addSubview(cartView)
        cartView.anchor(top: view.topAnchor,
                        left: view.leftAnchor,
                        bottom: view.bottomAnchor,
                        right: view.rightAnchor)
        
        cartView.tableView.delegate = self
        cartView.tableView.dataSource = self
        
        // Register the cell class or nib
        cartView.tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "productCell")
    }
    
    private func setupBindings() {
        // No need to set delegate and dataSource here as it's already done in setupView
        cartView.tableView.reloadData()
    }
    
    private func updateUI() {
        cartView.tableView.reloadData()
        let totalPrice = viewModel.getTotalPrice()
        cartView.updateTotalPrice(with: totalPrice)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductTableViewCell else {
            fatalError("Unable to dequeue ProductTableViewCell")
        }
        let product = viewModel.cartItems[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
