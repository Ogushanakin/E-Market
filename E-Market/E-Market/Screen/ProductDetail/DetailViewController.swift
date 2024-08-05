//
//  DetailViewController.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit

class DetailViewController: UIViewController, DetailViewModelDelegate {
    
    private let detailView = DetailView()
    private var viewModel: DetailViewModel!
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupBindings()
        NotificationCenter.default.addObserver(self, selector: #selector(cartDidUpdate), name: CartManager.shared.cartDidUpdateNotification, object: nil)
    }
    
    private func setupUI() {
        view.addSubview(detailView)
        detailView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.safeAreaLayoutGuide.leftAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          right: view.safeAreaLayoutGuide.rightAnchor)
        
        detailView.addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        detailView.configure(with: viewModel)
    }
    
    @objc private func addToCartButtonTapped() {
        viewModel.toggleCartStatus()
    }
    
    @objc private func cartDidUpdate() {
        // Update button title based on current cart status
        let buttonTitle = viewModel.isInCart ? "Remove from Cart" : "Add to Cart"
        detailView.addToCartButton.setTitle(buttonTitle, for: .normal)
    }
    
    func didUpdatePrice(_ price: String) {
        detailView.priceValueLabel.text = price
    }
    
    func didUpdateButtonTitle(_ title: String) {
        detailView.addToCartButton.setTitle(title, for: .normal)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
