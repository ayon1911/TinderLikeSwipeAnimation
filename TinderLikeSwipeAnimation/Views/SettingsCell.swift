//
//  SettingsCell.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 22.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    let textField: settingsTextField = {
       let tf = settingsTextField()
        tf.placeholder = "Enter Name"
        return tf
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class settingsTextField: UITextField {
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 44)
        }
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 16, dy: 0)
        }
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 16, dy: 0)
        }
    }
    
}
