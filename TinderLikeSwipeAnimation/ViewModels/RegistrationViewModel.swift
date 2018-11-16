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
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            if let err = error {
                completion(err)
                return
            }
            let filename = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/image/\(filename)")
            guard let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) else { return }
            ref.putData(imageData, metadata: nil, completion: { (_, error) in
                if let err = error {
                    completion(err)
                }
                print("Finished uploading picture")
                ref.downloadURL(completion: { (url, error) in
                    if let err = error {
                        completion(err)
                    }
                    print("Download image for our url : \(url?.absoluteString ?? "")")
                })
            })
        }
        
    }
}
