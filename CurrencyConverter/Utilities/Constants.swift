//
//  Constants.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 02/07/2022.
//

import UIKit


enum Constants {
    
    //MARK: - General
    enum General {
        static let animationDuration: CGFloat = 0.3
    }
    
    //MARK: - InAppPurchase
    enum InAppPurchase {
        static let smallDonationProductId = "convertySmallDonation"
    }
    
    //MARK: - Web
    enum Web: String {
        case currenciesUrl = "https://datahub.io/core/currency-codes/r/codes-all.json"
        
        var url: URL { .init(string: rawValue)! }
    }
    
    enum Navigation {
        case googleMaps(Double = 0, Double = 0)
        case appleMaps(Double = 0, Double = 0)
        case waze(Double = 0, Double = 0)
        
        var name: String {
            switch self {
            case .googleMaps(_, _):
                return "Google Maps"
            case .appleMaps(_, _):
                return "Apple Maps"
            case .waze(_, _):
                return "Waze"
            }
        }
        
        var url: URL {
            switch self {
            case .appleMaps(let latitude, let longitude):
                return .init(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)")!
                
            case .googleMaps(let latitude, let longitude):
                return .init(string: "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving")!
                
            case .waze(let latitude, let longitude):
                return .init(string: "waze://?ll=\(latitude),\(longitude)&navigate=false")!
            }
        }
    }
    
    //MARK: - Colors
    enum Colors {
        static let deepBlue            = UIColor(named: "deepBlue")
        static let background          = UIColor(named: "background")
        static let textFieldBackground = UIColor(named: "textFieldBackground")
        static let text                = UIColor(named: "text")
        static let titleLabel          = UIColor(named: "titleLabel")
        static let deepYellow          = UIColor(named: "deepYellow")
    }
    
    //MARK: - Identifier
    enum Identifier {
        static let quickGlanceCell = "quickGlanceCell"
        static let annotationId    = "Annotation"
    }
    
    //MARK: - Font
    enum Font {
        static let regular = "Heebo-Regular"
        static let medium  = "Heebo-Medium"
        static let bold    = "Heebo-Bold"
    }
    
    //MARK: - UserDefaults keys
    enum UserDefaultsKeys {
        static let lastUpdatedTimestamp = "lastUpdatedTimestamp"
        static let currencyData         = "currencyData"
        static let conversionRatesData  = "conversionRatesData"
        static let zoomRadius           = "zoomRadius"
    }
    
    //MARK: - Text
    enum Text {
        static let ratesLastUpdatedLabel = "Currency rates last updated: "
    }
    
    //MARK: - Notifications
    enum NotificationName: String {
        case currenciesUpdated
        
        func post(_ userInfo: [String : Any] = [:]) {
            NotificationCenter.default.post(.init(name: .init(rawValue: rawValue), object: nil, userInfo: userInfo))
        }
        
        func observe(_ queue: OperationQueue? = .main, _ handler: @escaping (Notification) -> Void) {
            NotificationCenter.default.addObserver(forName: .init(rawValue: rawValue), object: nil, queue: queue) { notification in
                handler(notification)
            }
        }
    }
}
