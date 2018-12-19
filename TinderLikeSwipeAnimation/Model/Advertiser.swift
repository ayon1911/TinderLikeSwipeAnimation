//
//  Advertiser.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 08.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCarViewModel {
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont(name: "AvenirNext-Bold", size: 30) ?? UIFont.systemFont(ofSize: 30)])
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont(name: "AvenirNext-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24)]))
    
        return CardViewModel(uid: "", imageNames: [posterPhotoName], attributedText: attributedString, textAlligenment: .center)
    }
}
