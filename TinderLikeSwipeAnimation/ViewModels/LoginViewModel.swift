//
//  LoginViewModel.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 27.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel {
    var isLoggedIn = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()
    
    var email: String? {
        didSet {
            checkFormValidity()
        }
    }
    var password: String? {
        didSet {
           checkFormValidity()
        }
    }
    
    fileprivate func checkFormValidity() {
        let isvalid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isvalid
    }
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        isLoggedIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
            completion(error)
        }
    }
}
