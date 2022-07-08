//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 08/07/2022.
//

import UIKit
import UniversalHTTP

struct PostModel: Codable {
}

struct CurrencyModel: Codable {
    let AlphabeticCode: String?
    let Currency:       String?
    let Entity:         String?
}

final class NetworkManager {
    static let shared: NetworkManager = {
        .init()
    }()
    
    func fetchWorldCurrencies() async -> [CurrencyModel]? {
        guard let dataRetrieved = await UniversalHTTP<[CurrencyModel]>.performRequest(url: Constants.Web.currenciesUrl.rawValue, bodyModel: PostModel()) else { return nil }
        
        return dataRetrieved.response
    }
}
