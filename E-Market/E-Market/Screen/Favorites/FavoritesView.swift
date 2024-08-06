//
//  FavoritesView.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

class FavoritesView: UIView {
    
    // MARK: - UI Components
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
        backgroundColor = .white
        addSubview(tableView)
        addSubview(totalLabel)
        
        // Konumlandırma için `anchor` fonksiyonlarını kullanıyoruz
        tableView.anchor(top: topAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor, right: rightAnchor,
                         paddingTop: 0,
                         paddingLeft: 0,
                         paddingBottom: 200)
        
        totalLabel.anchor(left: leftAnchor, bottom: bottomAnchor,
                          right: rightAnchor,
                          paddingLeft: 16, paddingBottom: 100,
                          paddingRight: 16,
                          height: 44)
    }
    
    func updateTotalFavorites(with total: String) {
        totalLabel.text = "Favorites: \(total)"
    }
}
