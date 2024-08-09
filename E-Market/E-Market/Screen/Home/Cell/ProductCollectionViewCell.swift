//
//  HomeCell.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit
import SDWebImage //NSCache

protocol ProductCollectionViewCellDelegate: AnyObject {
    func didSelectAddToCart(cell: ProductCollectionViewCell)
    func didSelectFavorite(cell: ProductCollectionViewCell)
}

final class ProductCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ProductCell"
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .blue
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        return button
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: ProductCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addToCartButton)
        contentView.addSubview(favoriteButton)
        
        productImageView.anchor(top: contentView.topAnchor,
                                left: contentView.leftAnchor,
                                right: contentView.rightAnchor,
                                paddingTop: 0,
                                paddingLeft: 0,
                                paddingRight: 0,
                                height: 160)
        
        priceLabel.anchor(top: productImageView.bottomAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          paddingTop: 4)
        
        nameLabel.anchor(top: priceLabel.bottomAnchor,
                         left: contentView.leftAnchor,
                         right: contentView.rightAnchor,
                         paddingTop: 8)
        
        addToCartButton.anchor(left: contentView.leftAnchor,
                               bottom: contentView.bottomAnchor,
                               right: contentView.rightAnchor,
                               paddingLeft: 7,
                               paddingBottom: 10,
                               paddingRight: 7,
                               height: 36)
        
        favoriteButton.anchor(top: contentView.topAnchor,
                              right: contentView.rightAnchor,
                              paddingTop: 14,
                              paddingRight: 10,
                              width: 40,
                              height: 40)
    }
    
    func configure(with model: Product?) {
        nameLabel.text = model?.name
        priceLabel.text = "$\(model?.price ?? "")"
        
        if let imageUrl = model?.image, let url = URL(string: imageUrl) {
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
        
        updateButtonTitle(isInCart: CartManager.shared.isProductInCart(model!))
        updateFavoriteButton(isFavorite: FavoriteManager.shared.isProductInFavorites(model!))
    }
    
    func updateButtonTitle(isInCart: Bool) {
        let title = isInCart ? "Remove from Cart" : "Add to Cart"
        addToCartButton.setTitle(title, for: .normal)
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "Star 1" : "Star 2"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @objc private func addToCartButtonTapped() {
        delegate?.didSelectAddToCart(cell: self)
    }
    
    @objc private func favoriteButtonTapped() {
        delegate?.didSelectFavorite(cell: self)
    }
}
