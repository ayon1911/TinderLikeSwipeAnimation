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

struct CardViewModel {
    let imageNames: [String]
    let attributedtext: NSAttributedString
    let textAlligenment: NSTextAlignment
}
