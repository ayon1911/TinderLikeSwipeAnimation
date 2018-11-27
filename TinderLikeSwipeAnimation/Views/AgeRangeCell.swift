//
//  AgeRangeCell.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 26.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    class AgerangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    
    let minSlider: UISlider = {
       let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    let minLabel: AgerangeLabel = {
       let label = AgerangeLabel()
        label.text = "Min 44"
        return label
    }()
    let maxLabel: AgerangeLabel = {
        let label = AgerangeLabel()
        label.text = "Max 88"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        let overallStackView = UIStackView(arrangedSubviews:[
            UIStackView(arrangedSubviews: [minLabel, minSlider]),
            UIStackView(arrangedSubviews: [maxLabel, maxSlider])
            ])
        overallStackView.spacing = 16
        overallStackView.axis = .vertical
        addSubview(overallStackView)
        overallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
