//
//  CurrencySelectorTableViewCell.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 30/07/2022.
//

import UIKit

class CurrencySelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    
    var currencyName: String? { didSet {
        configure()
    }}
    
    private func configure() {
        currencyLabel.text = currencyName ?? Constants.LocalizedText.general_notAvaialble.localized()
    }
    
}
