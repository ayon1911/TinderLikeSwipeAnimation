//
//  SettingsViewModel.swift
//  TinderLikeSwipeAnimation
//
//  Created by krAyon on 20.12.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import Foundation

struct AgeRange {
    let min: Int
    let max: Int
}

class SettingsViewModel {
    var ageRange: AgeRange = AgeRange(min: 18, max: 40)
    var bindableAge = Bindable<AgeRange>()
    
    var minAge: Int {
        set(newValue) {
            if newValue > ageRange.max { maxAge = newValue + 1 }
            ageRange = AgeRange(min: max(18, newValue), max: ageRange.max)
            bindableAge.value = ageRange
        }
        get {
            return ageRange.min
        }
    }
    var maxAge: Int {
        set(newValue) {
            if newValue < ageRange.min { minAge = newValue - 1 }
            ageRange = AgeRange(min: ageRange.min, max: min(100, newValue))
            bindableAge.value = ageRange
        }
        get {
            return ageRange.max
        }
    }
    
    
}
