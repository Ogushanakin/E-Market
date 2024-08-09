//
//  HomeViewController.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit
import UIScrollView_InfiniteScroll

final class HomeViewController: UIViewController {
    
    internal let homeView = HomeView()
    internal var homeViewModel: HomeViewModel!
    private var isLoading = false
    private var cartUpdateObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        fetchMoreData()
        setupInfiniteScroll()
        configureNavBar()
        setupCartUpdateObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBadgeValue()
        homeView.collectionView.reloadData()
        updateEmptyView()
    }

    private func setupView() {
        view.backgroundColor = .systemBlue
        view = homeView
        homeView.collectionView.dataSource = self
        homeView.collectionView.delegate = self
        homeView.searchBar.delegate = self
        homeView.delegate = self
        
        homeView.collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
    }
    
    private func configureNavBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupBindings() {
        let productService: ProductServiceProtocol = ProductService.shared
        homeViewModel = HomeViewModel(productService: productService)
    }
    
    private func updateEmptyView() {
        let isEmpty = homeViewModel.homeModels.isEmpty
        homeView.showEmptyView(isEmpty)
    }

    private func fetchMoreData() {
        guard !isLoading else { return }

        isLoading = true

        homeViewModel.fetchMoreProducts { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success:
                    self.homeView.collectionView.reloadData()
                    self.updateEmptyView()
                    self.homeView.collectionView.finishInfiniteScroll()
                    
                case .failure(let error):
                    print("Failed to fetch more products: \(error.localizedDescription)")
                    self.homeView.collectionView.finishInfiniteScroll()
                }
            }
        }
    }

    func triggerFetchMoreDataForTesting(completion: @escaping () -> Void) {
        fetchMoreData()
        completion()
    }
    
    private func setupInfiniteScroll() {
        homeView.collectionView.addInfiniteScroll { [weak self] _ in
            guard let self = self else { return }
            if !self.isLoading {
                self.fetchMoreData()
            }
        }
    }
    
    private func setupCartUpdateObserver() {
        cartUpdateObserver = NotificationCenter.default.addObserver(forName: CartManager.shared.cartDidUpdateNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateBadgeValue()
        }
    }
    
    private func updateBadgeValue() {
        let cartCount = CartManager.shared.cartItems.count
        if let tabBarItems = tabBarController?.tabBar.items, tabBarItems.indices.contains(1) {
            tabBarItems[1].badgeValue = cartCount > 0 ? "\(cartCount)" : nil
        }
    }
    
    deinit {
        if let observer = cartUpdateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    @objc private func filterButtonTapped() {
        let productService: ProductServiceProtocol = ProductService()
        let filterViewModel = FilterViewModel(productService: productService)
        let filterViewController = FilterViewController(viewModel: filterViewModel)
        filterViewController.modalPresentationStyle = .fullScreen
        present(filterViewController, animated: true, completion: nil)
    }
}

// MARK: - ProductCollectionViewCellDelegate
extension HomeViewController: ProductCollectionViewCellDelegate {
    func didSelectAddToCart(cell: ProductCollectionViewCell) {
        guard let indexPath = homeView.collectionView.indexPath(for: cell) else { return }
        let selectedProduct = homeViewModel.homeModels[indexPath.row]
        
        homeViewModel.addToCart(product: selectedProduct) { [weak self] isAdded in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if isAdded {
                    self.showAlert(message: "Product added to cart!")
                } else {
                    self.showAlert(message: "Product removed from cart!")
                }
                cell.updateButtonTitle(isInCart: isAdded)
                self.homeView.collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    func didSelectFavorite(cell: ProductCollectionViewCell) {
        guard let indexPath = homeView.collectionView.indexPath(for: cell) else { return }
        let selectedProduct = homeViewModel.homeModels[indexPath.row]
        
        homeViewModel.addToFavorites(product: selectedProduct) { [weak self] isFavorite in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if isFavorite {
                    self.showAlert(message: "Product added to favorites!")
                } else {
                    self.showAlert(message: "Product removed from favorites!")
                }
                cell.updateFavoriteButton(isFavorite: isFavorite)
                self.homeView.collectionView.reloadItems(at: [indexPath])
            }
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
        homeViewModel.searchProducts(query: searchText) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.homeView.collectionView.reloadData()
                    self.updateEmptyView()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Search failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Navigation
extension HomeViewController {
    private func navigateToProductDetail(_ selectedProduct: Product) {
        let isInCart = CartManager.shared.isProductInCart(selectedProduct)
        let viewModel = DetailViewModel(product: selectedProduct, isInCart: isInCart)
        let productDetailVC = DetailViewController(viewModel: viewModel)
        productDetailVC.delegate = self
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

// MARK: - DetailViewControllerDelegate
extension HomeViewController: DetailViewControllerDelegate {
    func didUpdateCart() {
        homeView.collectionView.reloadData()
        updateBadgeValue()
    }
    
    func didUpdateFavorites() {
        homeView.collectionView.reloadData()
    }
}

// MARK: - HomeViewDelegate
extension HomeViewController: HomeViewDelegate {
    func didTapFilterButton() {
        let productService: ProductServiceProtocol = ProductService()
        let filterViewModel = FilterViewModel(productService: productService)
        let filterViewController = FilterViewController(viewModel: filterViewModel)
        filterViewController.modalPresentationStyle = .fullScreen
        filterViewController.delegate = self
        present(filterViewController, animated: true, completion: nil)
    }
    
    func didSelectProduct(_ product: Product) {
        navigateToProductDetail(product)
    }
}

// MARK: - FilterViewControllerDelegate
extension HomeViewController: FilterViewControllerDelegate {
    func didSelectSortOption(_ sortOption: String) {
        homeViewModel.sortOption = sortOption
        homeViewModel.applySorting()
        homeView.collectionView.reloadData()
    }

    func didSelectBrands(_ brands: [String]) {
        homeViewModel.filterBrands = brands
        homeViewModel.applySorting()
        homeView.collectionView.reloadData()
    }
}
