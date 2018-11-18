//
//  RegisterService
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 16.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation
import Firebase

class RegisterService {
    static let shared = RegisterService()
    
    var passFullname: ((_ name: String) -> String)?
    
    func registerUser(email: String, password: String, image: UIImage?, completion: @escaping (Error?) -> ()) -> () {
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            if let err = error {
                completion(err)
                return
            }
            self.storeImage(imageData: image, completion: completion)
        }
    }
    
    fileprivate func storeImage(imageData: UIImage?, completion: @escaping (Error?) -> ()) {
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
                    return
                }
                print("Download image for our url : \(url?.absoluteString ?? "")")
                completion(nil)
                self.saveInfoToFireStore(imageUrl: url?.absoluteString ?? "", completion: completion)
            })
        })
    }
    
    fileprivate func saveInfoToFireStore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid, let fullname = passFullname else {
            print("something went wrong")
            return
        }
        let docData = ["fullname":  fullname, "uid": uid, "imageUrl": imageUrl] as [String: Any]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let err = error {
                completion(err)
                return
            }
            completion(nil)
            print("collection was saved into the firestore")
        }
    }
}
