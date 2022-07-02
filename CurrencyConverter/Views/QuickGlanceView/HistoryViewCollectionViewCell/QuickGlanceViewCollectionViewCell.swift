//
//  QuickGlanceViewCollectionViewCell.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 02/07/2022.
//

import UIKit
import NotSwiftUI

struct QuickGlanceViewCollectionViewCellModel {
    let fromCurrency: String
    let fromAmount:   String
    let toCurrency:   String
    let toAmount:     String
    
    static let example = QuickGlanceViewCollectionViewCellModel(fromCurrency: "$", fromAmount: "135", toCurrency: "€", toAmount: "129.45")
}

final class QuickGlanceViewCollectionViewCell: UICollectionViewCell {
    
    var model: QuickGlanceViewCollectionViewCellModel! { didSet {
        configure()
    }}
    
    //MARK: From
    @IBOutlet weak var fromView: UIView!
    
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    
    @IBOutlet weak var fromAmountLabel:   UILabel!
    
    //MARK: To
    @IBOutlet weak var toView: UIView!
    
    @IBOutlet weak var toCurrencyLabel: UILabel!
    
    @IBOutlet weak var toAmountLabel:   UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fromView.rounded(fromView.frame.height / 4)
            .bordered(width: 2, color: .white)
        
        toView.rounded(toView.frame.height / 2)
            .bordered(width: 2, color: .white)
    }
    
    private func configure() {
        fromCurrencyLabel.text = model.fromCurrency
        fromAmountLabel.text   = model.fromAmount
        toCurrencyLabel.text   = model.toCurrency
        toAmountLabel.text     = model.toAmount
    }

}
