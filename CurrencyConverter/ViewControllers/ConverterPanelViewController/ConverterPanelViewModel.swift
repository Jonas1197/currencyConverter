//
//  ConverterPanelViewModel.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 05/07/2022.
//

import UIKit
import FloatingPanel

protocol ConverterPanelDelegate: AnyObject {
    func findConversionStores()
    func presentCurrencyPicker(leading: Bool)
}


final class ConverterPanelViewModel: NSObject {
    weak var delegate:      ConverterPanelDelegate?
    weak var floatingPanel: FloatingPanelController?
    
    var selectedButtonTag = 0
    
    @Published var leadingCurrencyModel:  CurrencyModel?
    @Published var trailingCurrencyModel: CurrencyModel?
    
    @Published var lastUpdatedDateString: String?
    @Published var leadingTextFieldText:  String?
    @Published var trailingTextFieldText: String?
    @Published var keyboardAppeared:      Bool?
    @Published var floatingPanelState:    FloatingPanelState?
    
    
    //MARK: - Lifecycle
    init(floatingPanel: FloatingPanelController) {
        super.init()
        self.floatingPanel = floatingPanel
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        
        if let leadingCurrencyModelData = UserManager.shared.selectedLeadingCurrencyModelData,
           let leadingCurrencyModel     = try? JSONDecoder().decode(CurrencyModel.self, from: leadingCurrencyModelData) {
            self.leadingCurrencyModel = leadingCurrencyModel
            
        } else if let leadingCurrencyModel = UserManager.shared.selectedLeadingCurrencyModel {
            self.leadingCurrencyModel = leadingCurrencyModel
            
        } else if let euro = UserManager.shared.currencyList.first(where: { $0.AlphabeticCode == "EUR" }) {
            self.leadingCurrencyModel = euro
        }
        
        if let trailingCurrencyModelData = UserManager.shared.selectedTrailingCurrencyModelData,
           let trailingCurrencyModel     = try? JSONDecoder().decode(CurrencyModel.self, from: trailingCurrencyModelData) {
            self.trailingCurrencyModel = trailingCurrencyModel
            
        } else if let trailingCurrencyModel = UserManager.shared.selectedTrailingCurrencyModel {
            self.trailingCurrencyModel = trailingCurrencyModel
            
        } else if let usd = UserManager.shared.currencyList.first(where: { $0.AlphabeticCode == "USD" }) {
            self.trailingCurrencyModel = usd
        }
        
        Constants.NotificationName.currenciesUpdated.observe { [weak self] _ in
            print("\n~~> [ConverterManager] Currencies updated!")
            self?.updateCurrencyRatesDate()
        }
    }
    
    func move(to position: FloatingPanelState, animated: Bool = true, handler: (() -> Void)? = nil) {
        floatingPanel?.move(to: position, animated: animated, completion: handler)
    }
    
    func updateCurrencyRatesDate() {
        let timestamp = UserManager.shared.currencyUpdatedTimestamp
        if !timestamp.isEmpty,
           let timeInterval          = TimeInterval(timestamp) {
            let dateFormatter        = DateFormatter()
            dateFormatter.timeStyle  = .none
            dateFormatter.dateStyle  = .medium
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: .init(timeIntervalSince1970: timeInterval))
            lastUpdatedDateString = dateString
        }
    }
    
    func convert(valueFromTextField textField: UITextField) {
        if let text             = textField.text,
           let value            = Double(text),
           let leadingModel     = leadingCurrencyModel,
           let trailingModel    = trailingCurrencyModel,
           let leadingCurrency  = leadingModel.AlphabeticCode,
           let trailingCurrency = trailingModel.AlphabeticCode,
           let devider          = UserManager.shared.conversionRates.conversion_rates.first(where: { $0.key == trailingCurrency }),
           let devisor          = UserManager.shared.conversionRates.conversion_rates.first(where: { $0.key == leadingCurrency }) {
            
            if textField.tag == 0 {
                let convertedValue    = Double(round(100 * (value * (devider.value / devisor.value))) / 100)
                trailingTextFieldText = "\(convertedValue)"
                
            } else {
                let convertedValue   = Double(round(100 * (value * (devisor.value / devider.value))) / 100)
                leadingTextFieldText = "\(convertedValue)"
            }
        }
    }
    
    func switchCurrencyModels() {
        (leadingCurrencyModel, trailingCurrencyModel) = (trailingCurrencyModel, leadingCurrencyModel)
        (leadingTextFieldText, trailingTextFieldText) = (trailingTextFieldText, leadingTextFieldText)
    }
    
    
    //MARK: - Actions
    @objc private func keyboardWillShow(_ notification: Notification) {
        floatingPanel?.move(to: .full, animated: true, completion: nil)
        keyboardAppeared = true
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        floatingPanel?.move(to: .full, animated: true, completion: nil)
        keyboardAppeared = false
    }
}
