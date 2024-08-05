//
//  DetailView.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit
import SDWebImage

class DetailView: UIView {
    
    // UI Elements
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Price:"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Add subviews
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(horizontalStackView)
        
        // Add subviews to the horizontal stack view
        horizontalStackView.addArrangedSubview(priceStackView)
        horizontalStackView.addArrangedSubview(addToCartButton)
        
        // Add subviews to the vertical stack view
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceValueLabel)
        
        // Set constraints using anchor method
        imageView.anchor(top: topAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         paddingTop: 40,
                         paddingLeft: 20,
                         paddingRight: 20,
                         height: 200)
        
        titleLabel.anchor(top: imageView.bottomAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          paddingTop: 20,
                          paddingLeft: 20,
                          paddingRight: 20)
        
        descriptionLabel.anchor(top: titleLabel.bottomAnchor,
                                left: leftAnchor,
                                right: rightAnchor,
                                paddingTop: 10,
                                paddingLeft: 20,
                                paddingRight: 20)
        
        horizontalStackView.anchor(top: descriptionLabel.bottomAnchor,
                                    left: leftAnchor,
                                   bottom: bottomAnchor, right: rightAnchor,
                                    paddingTop: 20,
                                    paddingLeft: 20,
                                   paddingBottom: 20, paddingRight: 20)
    }
    
    func configure(with viewModel: DetailViewModel) {
        if let imageUrl = URL(string: viewModel.productImageUrl) {
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
        
        titleLabel.text = viewModel.productName
        descriptionLabel.text = viewModel.productDescription
        priceValueLabel.text = viewModel.productPrice
        addToCartButton.setTitle(viewModel.isInCart ? "Remove from Cart" : "Add to Cart", for: .normal)
    }
}
