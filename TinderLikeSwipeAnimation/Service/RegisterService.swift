//
//  RegisterService
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 16.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

typealias Success = (_ error: Error?) -> ()

import Foundation
import Firebase

class RegisterService {
    
    static let shared = RegisterService()
    
    func registerUser(email: String, password: String, image: UIImage?, completion: @escaping Success) -> () {
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            if let err = error {
                completion(err)
                return
            }
            self.storeImage(imageData: image, completion: { (error) in
                if let err = error {
                 completion(err)
                }
            })
        }
    }
    
    func storeImage(imageData: UIImage?, completion: @escaping Success) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/image/\(filename)")
        guard let imageData = imageData?.jpegData(compressionQuality: 0.75) else { return }
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