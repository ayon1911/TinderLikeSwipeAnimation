//
//  FetchUserService.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 27.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Firebase

class FetchUserService {
    static let shared = FetchUserService()
    
    func fetchCurrentUser (completion: @escaping (User?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let err = error {
                print(err)
            }
            guard let dict = snapshot?.data() else { return }
            let user = User(dictionary: dict)
            completion(user, nil)
        }
    }
}
