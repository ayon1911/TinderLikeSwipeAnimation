//
//  CardViewModel.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 08.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation
import UIKit

protocol ProducesCarViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    //MARK:- variables
    let imageUrls: [String]
    let attributedtext: NSAttributedString
    let textAlligenment: NSTextAlignment
    
    init(imageNames: [String], attributedText: NSAttributedString, textAlligenment: NSTextAlignment) {
        self.imageUrls = imageNames
        self.attributedtext = attributedText
        self.textAlligenment = textAlligenment
    }
    //variable for reactive state change
    var imageIndexObserver: ((Int, String?) -> ())?
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageUrls[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    func advanceToNextImage() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
