//
//  CustomTabBar.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

class CustomTabBar: UITabBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var tabBarFrame = frame
        tabBarFrame.size.height = 86
        tabBarFrame.origin.y = UIScreen.main.bounds.size.height - 86
        frame = tabBarFrame
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: -4, width: bounds.width, height: 4))
        layer.shadowPath = shadowPath.cgPath
    }
}
