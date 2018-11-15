//
//  RegistrationViewModel.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 15.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    var fullname: String? { didSet { formValidation() }}
    var email: String? { didSet { formValidation() } }
    var password: String? { didSet { formValidation() } }
    
    //Reactive programming
    var isFormValidObserver: ((Bool) -> ())?
    
    fileprivate func formValidation() {
        let isFormValid = fullname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
}
