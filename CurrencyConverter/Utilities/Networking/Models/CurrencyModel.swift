//
//  CurrencyModel.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 08/07/2022.
//

import Foundation

struct CurrencyModel: Codable, Hashable {
    let AlphabeticCode: String?
    let Currency:       String?
    let Entity:         String?
}
