//
//  RegistrationViewModel.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 15.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    var fullname: String? { didSet { formValidation() }}
    var email: String? { didSet { formValidation() } }
    var password: String? { didSet { formValidation() } }
    
    //Reactive programming
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
    fileprivate func formValidation() {
        let isFormValid = fullname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        self.bindableIsRegistering.value = true
        RegisterService.shared.registerUser(email: email, password: password, image: bindableImage.value) { (error) in
            if let err = error {
                completion(err)
            }
            self.bindableIsRegistering.value = false
            //store url to firestore
            completion(nil)
        }
    }
    
    
}
