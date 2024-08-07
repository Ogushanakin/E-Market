//
//  FilterController.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectSortOption(_ sortOption: String)
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: FilterViewControllerDelegate?
    private let viewModel: FilterViewModelProtocol

    private let sortingTableView = UITableView()
    private let brandTableView = UITableView()
    private let dismissButton = UIButton(type: .system)

    private let sortOptions = ["Old to New", "New to Old", "Price High to Low", "Price Low to High"]
    private var selectedSortOption: String?

    private var brands: [String] = []  // Brands list

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
        view.addSubview(sortingTableView)
        view.addSubview(brandTableView)
        view.addSubview(dismissButton)

        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.tintColor = .black
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        sortingTableView.translatesAutoresizingMaskIntoConstraints = false
        brandTableView.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false

        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.leftAnchor,
                            paddingTop: 10,
                            paddingLeft: 10,
                            width: 50, height: 50)

        sortingTableView.anchor(top: dismissButton.bottomAnchor,
                                left: view.leftAnchor,
                                right: view.rightAnchor,
                                height: 200) // Adjust height as needed

        brandTableView.anchor(top: sortingTableView.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor)
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
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sortingTableView {
            return sortOptions.count
        } else {
            return brands.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableView == sortingTableView ? "sortCell" : "brandCell", for: indexPath) as! FilterTableViewCell
        if tableView == sortingTableView {
            let sortOption = sortOptions[indexPath.row]
            cell.setUI(name: sortOption, isChecked: sortOption == selectedSortOption)
        } else {
            let brand = brands[indexPath.row]
            cell.setUI(name: brand, isChecked: false)
        }
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sortingTableView {
            let selectedOption = sortOptions[indexPath.row]
            selectedSortOption = selectedOption
            tableView.reloadData()
        }
    }
}
