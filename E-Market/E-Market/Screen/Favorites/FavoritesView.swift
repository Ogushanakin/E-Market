//
//  FavoritesView.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

final class FavoritesView: UIView {
    
    // MARK: - UI Components
    let headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "Favorites"
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoriteProductTableViewCell.self, forCellReuseIdentifier: "favoriteProductCell")
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
    
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let messageLabel = UILabel()
        messageLabel.text = "No Favorites Yet"
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
                         paddingBottom: 150)
        
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
        totalLabel.anchor(left: leftAnchor, bottom: bottomAnchor,
                          right: rightAnchor,
                          paddingLeft: 16, paddingBottom: 100,
                          paddingRight: 16,
                          height: 44)
        
        addSubview(emptyView)
        emptyView.anchor(top: headerView.bottomAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor)
        emptyView.isHidden = true
    }
    
    func updateTotalFavorites(with total: String) {
        totalLabel.text = "Favorites: \(total)"
    }
    
    func updateFavoritesView(isEmpty: Bool) {
        tableView.isHidden = isEmpty
        emptyView.isHidden = !isEmpty
    }
}
