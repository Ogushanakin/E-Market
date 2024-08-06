//
//  FilterController.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectBrands(_ brands: [String])
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: FilterViewControllerDelegate?
    private let viewModel: FilterViewModelProtocol
    private let tableView = UITableView()
    private let dismissButton = UIButton(type: .system)
    
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
        configureTableView()
        fetchBrands()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(dismissButton)
        
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.tintColor = .black
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             left: view.leftAnchor,
                             paddingTop: 10,
                             paddingLeft: 10,
                             width: 50, height: 50)
        tableView.anchor(top: dismissButton.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 0, paddingBottom: 150, paddingRight: 0)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func fetchBrands() {
        viewModel.fetchBrands { [weak self] result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch brands: \(error)")
            }
        }
    }
    
    @objc private func dismissButtonTapped() {
        delegate?.didSelectBrands(Array(selectedBrands))
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.brands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let brand = viewModel.brands[indexPath.row]
        cell.textLabel?.text = brand
        cell.accessoryType = selectedBrands.contains(brand) ? .checkmark : .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBrand = viewModel.brands[indexPath.row]
        
        if selectedBrands.contains(selectedBrand) {
            selectedBrands.remove(selectedBrand)
        } else {
            selectedBrands.insert(selectedBrand)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
