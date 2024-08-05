//
//  HomeCell.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit
import SDWebImage
import SnapKit

protocol ProductCollectionViewCellDelegate: AnyObject {
    func didSelectFavorite(cell: ProductCollectionViewCell)
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ProductCell"
    
    // UI Components
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .blue
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: ProductCollectionViewCellDelegate?
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI Setup
    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addToCartButton)
        
        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(with model: HomeModel?) {
        nameLabel.text = model?.name
        priceLabel.text = "$\(model?.price ?? "")"
        
        if let imageUrl = model?.image, let url = URL(string: imageUrl) {
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
        
        updateButtonTitle(isInCart: CartManager.shared.isProductInCart(model!))
    }
    
    func updateButtonTitle(isInCart: Bool) {
        let title = isInCart ? "Remove from Cart" : "Add to Cart"
        addToCartButton.setTitle(title, for: .normal)
    }
    
    @objc private func addToCartButtonTapped() {
        delegate?.didSelectFavorite(cell: self)
    }
}
