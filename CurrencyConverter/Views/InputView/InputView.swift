//
//  InputView.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 02/07/2022.
//

import UIKit
import NotSwiftUI

struct InputViewModel {
    var title:               String
    var availableCurrencies: [String]
    var inputPlaceholder:    String
    
    static let example = InputViewModel(title: "Convert title:", availableCurrencies: ["$"], inputPlaceholder: "Tap to convert")
}

struct InputViewValue {
    var amountToConvert: Double
    var currency:        String
}

final class InputView: UIView {
    
    private (set) var availableCurrencies: [String] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var inputBackgroundView: UIView!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var shadowView: UIView!
    
    class func instantiateFromNib() -> InputView {
        UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! InputView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        inputBackgroundView.roundCorners(to: .rounded)
        inputBackgroundView.clipsedToBounds()
    }
    
    
    func configure(withModel model: InputViewModel) {
        inputBackgroundView.bordered(width: 2, color: Constants.Colors.deepGray)
        
        shadowView.shadowed(with: .black, offset: .init(width: 0, height: -3), radius: 12, 0.4)
        
        titleLabel.text            = model.title
        inputTextField.placeholder = model.inputPlaceholder
        availableCurrencies        = model.availableCurrencies
    }
    
    func getValueToConvert() -> InputViewValue? {
        
        if let inputText = inputTextField.text,
           let amountToConvert = Double(inputText),
           let currency = currencyLabel.text {
            return .init(amountToConvert: amountToConvert, currency: currency)
            
        } else {
            print("\n~~> [InputView.swift] Could not retrieve value to convert.")
            return nil
        }
    }
}
