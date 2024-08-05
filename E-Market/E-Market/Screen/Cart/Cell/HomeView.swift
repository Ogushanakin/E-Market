//
//  HomeView.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit

final class HomeView: UIView {

    // MARK: - UI Elements
    let productCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure View
    private func configureView() {
        backgroundColor = .white
        addSubview(productCollection)
        setupConstraints()
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productCollection.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            productCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            productCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            productCollection.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
