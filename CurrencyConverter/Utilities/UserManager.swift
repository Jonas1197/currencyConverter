//
//  UserManager.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit

struct UserManager {
    static var shared: UserManager = {
        .init()
    }()
    
    /**
     Boolean indicating whether the user has been through the onboarding process or not.
     */
    var didSeeOnboarding = true
    
    var currencyList: [CurrencyModel] = []
}

