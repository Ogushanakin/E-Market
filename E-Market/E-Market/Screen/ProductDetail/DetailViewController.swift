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
    }
    
    private func setupUI() {
        view.addSubview(detailView)
        
        // Set constraints using SnapKit
        detailView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // Add target for button action
        detailView.addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        detailView.configure(with: viewModel)
    }
    
    @objc private func addToCartButtonTapped() {
        viewModel.toggleCartStatus()
    }
    
    // DetailViewModelDelegate methods
    func didUpdatePrice(_ price: String) {
        detailView.priceValueLabel.text = price
    }
    
    func didUpdateButtonTitle(_ title: String) {
        detailView.addToCartButton.setTitle(title, for: .normal)
    }
}
