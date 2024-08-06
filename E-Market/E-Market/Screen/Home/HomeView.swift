//
//  HomeView.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit

class HeaderView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "E-Market"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        addSubview(titleLabel)
        
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: self)
    }
}

class HomeView: UIView {
    
    let headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .white
        searchBar.barStyle = .black
        return searchBar
    }()
    
    let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filters:"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Filter", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.anchor(width: 140, height: 40)
        return button
    }()
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        addSubview(headerView)
        addSubview(searchBar)
        addSubview(horizontalStackView)
        addSubview(collectionView)
        
        horizontalStackView.addArrangedSubview(filterLabel)
        horizontalStackView.addArrangedSubview(filterButton)
        
        // Set up constraints for headerView
        headerView.anchor(top: safeAreaLayoutGuide.topAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          height: 60)
        
        // Set up constraints for searchBar
        searchBar.anchor(top: headerView.bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor)
        
        // Set up constraints for horizontalStackView
        horizontalStackView.anchor(top: searchBar.bottomAnchor,
                                   left: leftAnchor,
                                   right: rightAnchor,
                                   paddingTop: 0)
        
        // Set up constraints for collectionView
        collectionView.anchor(top: horizontalStackView.bottomAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              right: rightAnchor,
                              paddingTop: 0)
    }
}
