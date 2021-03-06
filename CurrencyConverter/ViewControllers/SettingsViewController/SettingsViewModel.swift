//
//  SettingsViewModel.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 24/07/2022.
//

import Foundation

protocol SettingsOutput: AnyObject {
    
}

final class SettingsViewModel {
    weak var output: SettingsOutput?
    
    init(_ output: SettingsOutput) {
        self.output = output
    }
}
