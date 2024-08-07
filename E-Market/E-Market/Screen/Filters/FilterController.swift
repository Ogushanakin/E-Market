//
//  FilterController.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectSortOption(_ sortOption: String)
    func didSelectBrands(_ selectedBrands: [String])
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    weak var delegate: FilterViewControllerDelegate?
    private let viewModel: FilterViewModelProtocol
    
    private let sortTitle = UILabel()
    private let brandsTitle = UILabel()
    private let sortingTableView = UITableView()
    private let brandTableView = UITableView()
    private let dismissButton = UIButton(type: .system)
    private let searchBar = UISearchBar()
    private let resetButton = UIButton(type: .system)
    private let headerView = HeaderView()
    
    private let sortOptions = ["Old to New", "New to Old", "Price High to Low", "Price Low to High"]
    private var selectedSortOption: String?
    
    private var brands: [String] = []
    private var filteredBrands: [String] = []
    private var selectedBrands: Set<String> = []
    
    init(viewModel: FilterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        configureTableViews()
        fetchBrands()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(sortTitle)
        view.addSubview(brandsTitle)
        view.addSubview(sortingTableView)
        view.addSubview(brandTableView)
        view.addSubview(dismissButton)
        view.addSubview(searchBar)
        view.addSubview(resetButton)
        
        dismissButton.setImage(UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        dismissButton.tintColor = .black
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        searchBar.delegate = self
        searchBar.placeholder = "Search Brands"
        
        headerView.titleLabel.text = "Filter"
        sortTitle.text = "Sort By"
        sortTitle.textColor = .gray
        brandsTitle.text = "Brands"
        brandsTitle.textColor = .gray
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.red, for: .normal)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        sortingTableView.translatesAutoresizingMaskIntoConstraints = false
        brandTableView.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.anchor(top: view.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          height: 160)
        
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             left: view.leftAnchor,
                             paddingTop: -5,
                             paddingLeft: 16,
                             width: 50, height: 50)
        
        sortTitle.anchor(top: headerView.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 12,
                         paddingLeft: 16,
                         width: 50, height: 20)
        
        sortingTableView.anchor(top: dismissButton.bottomAnchor,
                                left: view.leftAnchor,
                                right: view.rightAnchor,
                                paddingTop: 100,
                                height: 200)
        
        brandsTitle.anchor(top: sortingTableView.bottomAnchor,
                           left: view.leftAnchor,
                           right: view.rightAnchor,
                           paddingTop: 12,
                           paddingLeft: 16,
                           width: 50, height: 20)
        
        searchBar.anchor(top: brandsTitle.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 10)
        
        brandTableView.anchor(top: searchBar.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor)
        
        resetButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                           right: view.rightAnchor,
                           paddingBottom: 20,
                           paddingRight: 20,
                           width: 100, height: 44)
    }
    
    private func configureTableViews() {
        sortingTableView.delegate = self
        sortingTableView.dataSource = self
        sortingTableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "sortCell")
        
        brandTableView.delegate = self
        brandTableView.dataSource = self
        brandTableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "brandCell")
    }
    
    private func fetchBrands() {
        viewModel.fetchBrands { [weak self] result in
            switch result {
            case .success:
                self?.brands = self?.viewModel.brands ?? []
                self?.filteredBrands = self?.brands ?? []
                DispatchQueue.main.async {
                    self?.brandTableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch brands: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func dismissButtonTapped() {
        if let sortOption = selectedSortOption {
            delegate?.didSelectSortOption(sortOption)
        }
        delegate?.didSelectBrands(Array(selectedBrands))
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func resetButtonTapped() {
        searchBar.text = ""
        
        filteredBrands = brands
        
        selectedBrands.removeAll()
        
        sortingTableView.reloadData()
        brandTableView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBrands = searchText.isEmpty ? brands : brands.filter { $0.lowercased().contains(searchText.lowercased()) }
        brandTableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sortingTableView {
            return sortOptions.count
        } else {
            return filteredBrands.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableView == sortingTableView ? "sortCell" : "brandCell", for: indexPath) as! FilterTableViewCell
        if tableView == sortingTableView {
            let sortOption = sortOptions[indexPath.row]
            cell.setUI(name: sortOption, isChecked: sortOption == selectedSortOption)
        } else {
            let brand = filteredBrands[indexPath.row]
            cell.setUI(name: brand, isChecked: selectedBrands.contains(brand))
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sortingTableView {
            let selectedOption = sortOptions[indexPath.row]
            selectedSortOption = selectedOption
            tableView.reloadData()
        } else {
            let selectedBrand = filteredBrands[indexPath.row]
            if selectedBrands.contains(selectedBrand) {
                selectedBrands.remove(selectedBrand)
            } else {
                selectedBrands.insert(selectedBrand)
            }
            tableView.reloadData()
        }
    }
}
