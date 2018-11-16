//
//  Bindable.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 16.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
}
