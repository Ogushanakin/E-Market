//
//  HomeViewController.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit
import UIScrollView_InfiniteScroll

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private var homeViewModel = HomeViewModel()
    private var isLoading = false
    private var cartUpdateObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        fetchMoreData()
        setupInfiniteScroll()
        setupCartUpdateObserver()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBadgeValue()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(homeView)
        homeView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        left: view.leftAnchor,
                        bottom: view.bottomAnchor,
                        right: view.rightAnchor)
        
        homeView.collectionView.dataSource = self
        homeView.collectionView.delegate = self
        homeView.collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        
        homeView.filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        homeView.searchBar.delegate = self
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.backgroundColor = .systemBlue
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupBindings() {
        // Add any bindings or additional setups for your view and viewModel here
    }
    
    private func fetchMoreData() {
        homeViewModel.fetchMoreProducts {
            DispatchQueue.main.async {
                self.isLoading = false
                self.homeView.collectionView.reloadData()
                self.homeView.collectionView.finishInfiniteScroll()
            }
        }
    }
    
    private func setupInfiniteScroll() {
        homeView.collectionView.addInfiniteScroll { [weak self] _ in
            guard let self = self else { return }
            if !self.isLoading {
                self.isLoading = true
                self.fetchMoreData()
            }
        }
    }
    
    @objc private func filterButtonTapped() {
        // Implement filter functionality
    }
    
    private func setupCartUpdateObserver() {
        cartUpdateObserver = NotificationCenter.default.addObserver(forName: CartManager.shared.cartDidUpdateNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateBadgeValue()
        }
    }
    
    private func updateBadgeValue() {
        let cartCount = CartManager.shared.cartItems.count
        tabBarController?.tabBar.items?[1].badgeValue = cartCount > 0 ? "\(cartCount)" : nil
    }
    
    deinit {
        if let observer = cartUpdateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

// MARK: - ProductCollectionViewCellDelegate
extension HomeViewController: ProductCollectionViewCellDelegate {
    func didSelectFavorite(cell: ProductCollectionViewCell) {
        if let indexPath = homeView.collectionView.indexPath(for: cell) {
            let selectedProduct = homeViewModel.homeModels[indexPath.row]
            let isInCart = CartManager.shared.isProductInCart(selectedProduct)
            
            if isInCart {
                CartManager.shared.removeFromCart(item: selectedProduct)
                showAlert(message: "Product removed from cart!")
                cell.updateButtonTitle(isInCart: false)
            } else {
                CartManager.shared.addToCart(item: selectedProduct)
                showAlert(message: "Product added to cart!")
                cell.updateButtonTitle(isInCart: true)
            }
            
            homeView.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.homeModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = homeViewModel.homeModels[indexPath.item]
        cell.delegate = self
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 60) / 2
        let cellHeight: CGFloat = 300
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = homeViewModel.homeModels[indexPath.item]
        navigateToProductDetail(selectedProduct)
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        homeViewModel.searchProducts(query: searchText) {
            DispatchQueue.main.async {
                self.homeView.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Navigation
extension HomeViewController {
    private func navigateToProductDetail(_ selectedProduct: HomeModel) {
        let isInCart = CartManager.shared.isProductInCart(selectedProduct)
        let viewModel = DetailViewModel(product: selectedProduct, isInCart: isInCart)
        let productDetailVC = DetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
