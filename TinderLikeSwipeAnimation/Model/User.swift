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
    var name: String?
    var age: Int?
    var profession: String?
//    let imageNames: [String]
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    var minAge: Int?
    var maxAge: Int?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.minAge = dictionary["minAge"] as? Int
        self.maxAge = dictionary["maxAge"] as? Int
        
    }
    
    func toCardViewModel() -> CardViewModel {
        let ageString = age != nil ? "\(age!)" : "N\\A"
        let professionString = profession != nil ? "\(profession!)" : "Not available"
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont(name: "AvenirNext-Bold", size: 24)!])
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont(name: "AvenirNext-Medium", size: 18)!]))
        attributedText.append(NSAttributedString(string: "  \n\(professionString)", attributes: [.font: UIFont(name: "AvenirNext-Medium", size: 16)!]))
        
        var imageUrls = [String]()
        if let url = imageUrl1 { imageUrls.append(url) }
        if let url = imageUrl2 { imageUrls.append(url) }
        if let url = imageUrl3 { imageUrls.append(url) }
        
        return CardViewModel(imageNames: imageUrls, attributedText: attributedText, textAlligenment: .left)
    }
}
