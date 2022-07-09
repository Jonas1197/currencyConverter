//
//  UserManager.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit

@propertyWrapper struct UserDefaultsWrapper<Value> {
    let key:          String
    let defaultValue: Value
    var container:    UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        
        set {
            container.set(newValue, forKey: key)
        }
    }
}

struct UserManager {
    static var shared: UserManager = {
        .init()
    }()
    
    /**
     Boolean indicating whether the user has been through the onboarding process or not.
     */
    var didSeeOnboarding = true
    
    
    var currencyList: [CurrencyModel] = []
    
    @UserDefaultsWrapper(key: Constants.UserDefaultsKeys.currencyData, defaultValue: .init())
    var currencyListData: Data
    
    
    @UserDefaultsWrapper(key: Constants.UserDefaultsKeys.lastUpdatedTimestamp, defaultValue: "")
    var currencyUpdatedTimestamp: String
}

