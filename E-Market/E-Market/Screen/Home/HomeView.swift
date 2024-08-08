//
//  HomeView.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    func didTapFilterButton()
    func didSelectProduct(_ product: Product)
}

final class HomeView: UIView {
    weak var delegate: HomeViewDelegate?
    
    let emptyView: UILabel = {
        let label = UILabel()
        label.text = "No results found.\nYou can search from the search bar."
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    
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
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Filter", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
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
        let view = UIView()
        view.backgroundColor = .white
        addSubview(headerView)
        addSubview(searchBar)
        addSubview(view)
        addSubview(horizontalStackView)
        addSubview(collectionView)
        addSubview(emptyView)

        horizontalStackView.addArrangedSubview(filterLabel)
        horizontalStackView.addArrangedSubview(filterButton)
        
        headerView.anchor(top: safeAreaLayoutGuide.topAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          height: 60)
        view.anchor(top: searchBar.bottomAnchor,
                                          left: leftAnchor,
                                          right: rightAnchor,
                                          paddingTop: 0, height: 100)
        searchBar.anchor(top: headerView.bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor)
        
        horizontalStackView.anchor(top: searchBar.bottomAnchor,
                                   left: leftAnchor,
                                   right: rightAnchor,
                                   paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        
        emptyView.anchor(top: horizontalStackView.bottomAnchor,
                                left: leftAnchor,
                                bottom: bottomAnchor,
                                right: rightAnchor,
                                paddingTop: 20,
                                paddingLeft: 20,
                                paddingBottom: 20,
                                paddingRight: 20)
    
        collectionView.anchor(top: horizontalStackView.bottomAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              right: rightAnchor,
                              paddingTop: 10)
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    func showEmptyView(_ show: Bool) {
        emptyView.isHidden = !show
    }
    @objc private func filterButtonTapped() {
        delegate?.didTapFilterButton()
    }
}
