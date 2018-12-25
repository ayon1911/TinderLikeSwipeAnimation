//
//  SendMessageButton.swift
//  TinderLikeSwipeAnimation
//
//  Created by krAyon on 24.12.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.9215686275, green: 0.3019607843, blue: 0.2941176471, alpha: 1), rightColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        gradientLayer.frame = rect
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}
