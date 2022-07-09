//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 08/07/2022.
//

import UIKit
import UniversalHTTP

struct PostModel: Codable {}

struct ConversionModel: Codable {
    var result: String?
    var conversion_rates: [String : Double]
}

final class NetworkManager {
    
    static let key = "3ad6b47b7159b34da65b868e"
    
    static let shared: NetworkManager = {
        .init()
    }()
    
    func fetchWorldCurrencies() async -> [CurrencyModel]? {
        guard let dataRetrieved = await UniversalHTTP<[CurrencyModel]>.performRequest(url: Constants.Web.currenciesUrl.rawValue, bodyModel: PostModel()) else { return nil }
        
        return dataRetrieved.response
    }
    
    func updateConversionRates() async -> ConversionModel? {
        let url = "https://v6.exchangerate-api.com/v6/\(NetworkManager.key)/latest/USD"
        guard let dataRetrieved = await UniversalHTTP<ConversionModel>.performRequest(url: url, bodyModel: PostModel(), debugPrintsEnabled: true) else { return nil }
        return dataRetrieved.response
    }
}
