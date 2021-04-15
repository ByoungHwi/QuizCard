//
//  UserData.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import Foundation

@propertyWrapper
struct UserDefaultsBool {
    private let key: String
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: Bool {
        get {
            UserDefaults.standard.bool(forKey: key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class UserData {
    
    static var shared = UserData()
    
    private init() { }
    
    @UserDefaultsBool(key: "ShouldShuffle") var shouldShuffle: Bool
    @UserDefaultsBool(key: "isTutorialOff") var isTutorialOff: Bool
}
