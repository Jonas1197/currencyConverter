//
//  Constants.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 02/07/2022.
//

import UIKit


enum Constants {
    
    enum Web: String {
        case currenciesUrl = "https://datahub.io/core/currency-codes/r/codes-all.json"
        
        var url: URL { .init(string: rawValue)! }
    }
    
    enum Colors {
        static let deepBlue            = UIColor(named: "deepBlue")
        static let background          = UIColor(named: "background")
        static let textFieldBackground = UIColor(named: "textFieldBackground")
        static let text                = UIColor(named: "text")
        static let titleLabel          = UIColor(named: "titleLabel")
    }
    
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
}
