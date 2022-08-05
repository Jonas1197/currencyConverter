//
//  CurrencyExchangeView.swift
//  CurrencyConverter
//
//  Created by St. John on 11/07/2022.
//

import UIKit
import NotSwiftUI

struct CurrencyExchangeViewModel {
    let valuesToConvert: [String]
}

final class CurrencyExchangeView: UIView {
    
    var model: CurrencyExchangeViewModel?
    
    @IBOutlet weak var tileLabelAndSubtitleVstack: UIStackView!
    
    private (set) var labels: [UIView] = []
    private (set) var labelsVstack: UIView!

    class func instantiateFromNib() -> CurrencyExchangeView {
        UINib(nibName: String(describing: CurrencyExchangeView.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CurrencyExchangeView
    }
    
    func configure(withModel model: CurrencyExchangeViewModel) {
        print("configured")
        self.model = model
        
        createLabels()
        addLabels()
    }
    
//    func update(withNewModel model: CurrencyExchangeViewModel? = nil) {
//        for view in subviews {
//            view.removeFromSuperview()
//        }
//        
//        if let model = model {
//            configure(withModel: model)
//        } else {
//            configure(withModel: self.model ?? .init(valuesToConvert: []))
//        }
//    }
    
    private func createLabels() {
        guard let model = model else { return }
        for currencyCode in model.valuesToConvert {
            if let currencyModel = UserManager.shared.currencyList.first(where: { $0.AlphabeticCode == currencyCode }),
               let value         = UserManager.shared.conversionRates.conversion_rates.first(where: { $0.key == currencyCode }) {
                
                let currencyRateLabel = Object
                    .label(text: "\(currencyModel.Currency ?? Constants.LocalizedText.general_notAvaialble.localized()) - \(Double(round(100 * value.value)) / 100)", textAlignment: .center, backgroundColor: .clear, textColor: Constants.Colors.text!)
                    .create()
                    .fonted(ofType: .custom(Constants.Font.medium), size: 16)
                
                labels.append(currencyRateLabel)
            }
        }
    }
    
    private func addLabels() {
        labelsVstack = labels.vstacked(spacing: 12, alignment: .fill, distribution: .fillProportionally)
        addSubview(labelsVstack)
        NSLayoutConstraint.activate([
            labelsVstack.topAnchor.constraint(equalTo: tileLabelAndSubtitleVstack.bottomAnchor, constant: 20),
            labelsVstack.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsVstack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func convertToUSDollar(from currencyCode: String) -> String {
        guard let devider = UserManager.shared.conversionRates.conversion_rates.first(where: { $0.key == currencyCode }),
              let devisor = UserManager.shared.conversionRates.conversion_rates.first(where: { $0.key == "USD" }) else { return Constants.LocalizedText.general_notAvaialble.localized() }
        
        let convertedValue = Double(round(100 * (1 * (devider.value / devisor.value))) / 100)
        
        return "\(convertedValue)"
    }
}
