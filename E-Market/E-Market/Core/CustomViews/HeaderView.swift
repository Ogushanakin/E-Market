//
//  HeaderView.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

class HeaderView: UIView {
    
    let titleLabel: UILabel = {
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
