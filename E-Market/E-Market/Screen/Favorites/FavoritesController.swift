//
//  FavoritesController.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    private let viewModel = FavoritesViewModel()
    private let favoritesView = FavoritesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        configureNavBar()
        viewModel.onFavoritesUpdated = { [weak self] in
            guard let self = self else { return }
            self.updateUI()
        }
        updateUI()

        NotificationCenter.default.addObserver(self, selector: #selector(handleRemoveFavoriteNotification(_:)), name: Notification.Name("RemoveFavoriteTapped"), object: nil)
    }
    
    private func setupView() {
        view.addSubview(favoritesView)
        favoritesView.anchor(top: view.topAnchor,
                             left: view.leftAnchor,
                             bottom: view.bottomAnchor,
                             right: view.rightAnchor)
        
        favoritesView.tableView.delegate = self
        favoritesView.tableView.dataSource = self
        
        favoritesView.tableView.register(FavoriteProductTableViewCell.self, forCellReuseIdentifier: "favoriteProductCell")
    }
    
    private func configureNavBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupBindings() {
        favoritesView.tableView.reloadData()
    }
    
    private func updateUI() {
        let isFavoritesEmpty = viewModel.favoriteItems.isEmpty
        favoritesView.updateFavoritesView(isEmpty: isFavoritesEmpty)
        favoritesView.tableView.reloadData()
        let totalFavorites = viewModel.getTotalFavorites()
        favoritesView.updateTotalFavorites(with: totalFavorites)
    }

    @objc private func handleRemoveFavoriteNotification(_ notification: Notification) {
        guard let cell = notification.object as? FavoriteProductTableViewCell,
              let indexPath = favoritesView.tableView.indexPath(for: cell) else { return }
        
        let product = viewModel.favoriteItems[indexPath.row]
        viewModel.toggleFavorite(for: product)
        
        updateUI()
        
        NotificationCenter.default.post(name: Notification.Name("UpdateFavoriteStatus"), object: product)
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteProductCell", for: indexPath) as? FavoriteProductTableViewCell else {
            fatalError("Unable to dequeue FavoriteProductTableViewCell")
        }
        let product = viewModel.favoriteItems[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
