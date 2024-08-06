//
//  FilterController.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

class FilterViewController: UIViewController, FilterViewControllerProtocol {
    
    var viewModel: FilterViewModelProtocol?
    
    // UI Bileşenleri
    private let sortButtons: [UIButton] = {
        let oldToNewButton = UIButton(type: .system)
        oldToNewButton.setTitle("Old to New", for: .normal)
        oldToNewButton.tag = 0
        
        let newToOldButton = UIButton(type: .system)
        newToOldButton.setTitle("New to Old", for: .normal)
        newToOldButton.tag = 1
        
        let priceHighToLowButton = UIButton(type: .system)
        priceHighToLowButton.setTitle("Price High to Low", for: .normal)
        priceHighToLowButton.tag = 2
        
        let priceLowToHighButton = UIButton(type: .system)
        priceLowToHighButton.setTitle("Price Low to High", for: .normal)
        priceLowToHighButton.tag = 3
        
        return [oldToNewButton, newToOldButton, priceHighToLowButton, priceLowToHighButton]
    }()
    
    private let brandSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Brands"
        return searchBar
    }()
    
    private let modelSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Models"
        return searchBar
    }()
    
    private let brandTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
        return tableView
    }()
    
    private let modelTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
        return tableView
    }()
    
    private let primaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews()
        setupConstraints()
        
        brandTableView.delegate = self
        brandTableView.dataSource = self
        modelTableView.delegate = self
        modelTableView.dataSource = self
        
        brandSearchBar.delegate = self
        modelSearchBar.delegate = self
        
        sortButtons.forEach { button in
            button.addTarget(self, action: #selector(sortButtonsTapped(_:)), for: .touchUpInside)
        }
        primaryButton.addTarget(self, action: #selector(finisFilterTapped), for: .touchUpInside)
        
        viewModel?.viewDidLoad()
    }
    
    private func setupSubviews() {
        view.addSubview(brandSearchBar)
        view.addSubview(brandTableView)
        view.addSubview(modelSearchBar)
        view.addSubview(modelTableView)
        view.addSubview(primaryButton)
        
        let sortButtonsStackView = UIStackView(arrangedSubviews: sortButtons)
        sortButtonsStackView.axis = .vertical
        sortButtonsStackView.spacing = 10
        view.addSubview(sortButtonsStackView)
        
    }
    
    private func setupConstraints() {
        brandSearchBar.translatesAutoresizingMaskIntoConstraints = false
        brandTableView.translatesAutoresizingMaskIntoConstraints = false
        modelSearchBar.translatesAutoresizingMaskIntoConstraints = false
        modelTableView.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        
        let sortButtonsStackView = view.subviews.first(where: { $0 is UIStackView }) as! UIStackView
        sortButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            brandSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            brandSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            brandSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            sortButtonsStackView.topAnchor.constraint(equalTo: brandSearchBar.bottomAnchor, constant: 20),
            sortButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            brandTableView.topAnchor.constraint(equalTo: sortButtonsStackView.bottomAnchor, constant: 20),
            brandTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            brandTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            brandTableView.heightAnchor.constraint(equalToConstant: 200),
            
            modelSearchBar.topAnchor.constraint(equalTo: brandTableView.bottomAnchor, constant: 20),
            modelSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            modelSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            modelTableView.topAnchor.constraint(equalTo: modelSearchBar.bottomAnchor, constant: 20),
            modelTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            modelTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            modelTableView.heightAnchor.constraint(equalToConstant: 200),
            
            primaryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            primaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            primaryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            primaryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func sortButtonsTapped(_ sender: UIButton) {
        viewModel?.sortButtonsTapped(tag: sender.tag)
        sortButtons.forEach { button in
            button.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        sender.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    }
    
    @objc private func finisFilterTapped() {
        viewModel?.finisFilterTapped()
        dismiss(animated: true)
    }
    
    // FilterViewControllerProtocol Implementasyonu
    func reload() {
        brandTableView.reloadData()
        modelTableView.reloadData()
    }
}

extension FilterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == brandSearchBar {
            viewModel?.brand.searchBarTextDidChange(searchText) { [weak self] in
                self?.brandTableView.reloadData()
            }
        } else if searchBar == modelSearchBar {
            viewModel?.model.searchBarTextDidChange(searchText) { [weak self] in
                self?.modelTableView.reloadData()
            }
        }
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == brandTableView {
            return viewModel?.brand.itemsCount ?? 0
        } else {
            return viewModel?.model.itemsCount ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
        let item: FilterModel
        
        if tableView == brandTableView {
            item = viewModel?.brand.item(at: indexPath.row) ?? FilterModel(name: "", isChecked: false)
        } else {
            item = viewModel?.model.item(at: indexPath.row) ?? FilterModel(name: "", isChecked: false)
        }
        
        cell.setUI(name: item.name, isChecked: item.isChecked)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == brandTableView {
            viewModel?.brand.selectedRow(at: indexPath.row)
        } else {
            viewModel?.model.selectedRow(at: indexPath.row)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
