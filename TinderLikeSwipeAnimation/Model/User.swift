//
//  User.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 08.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation
import UIKit

struct User: ProducesCarViewModel {
    //defining user property
    let name: String
    let age: Int
    let profession: String
    let imageName: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont(name: "AvenirNext-Bold", size: 24)!])
        attributedText.append(NSAttributedString(string: "  \(age)", attributes: [.font: UIFont(name: "AvenirNext-Medium", size: 18)!]))
        attributedText.append(NSAttributedString(string: "  \n\(profession)", attributes: [.font: UIFont(name: "AvenirNext-Medium", size: 16)!]))
        
        return CardViewModel(imageName: imageName, attributedtext: attributedText, textAlligenment: .left)
    }
}
