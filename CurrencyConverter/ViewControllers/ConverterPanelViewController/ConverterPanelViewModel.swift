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
}

final class ConverterPanelViewModel: NSObject {
    weak var delegate:      ConverterPanelDelegate?
    weak var floatingPanel: FloatingPanelController?
    
    var position: FloatingPanelState = .half
    var selectedButtonTag = 0
    
    @Published var leadingCurrencyModel:  CurrencyModel?
    @Published var trailingCurrencyModel: CurrencyModel?
    
    @Published var lastUpdatedDateString: String?
    @Published var leadingTextFieldText:  String?
    @Published var trailingTextFieldText: String?
    
    
    //MARK: - Lifecycle
    init(floatingPanel: FloatingPanelController) {
        super.init()
        self.floatingPanel = floatingPanel
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        if let euro = UserManager.shared.currencyList.first(where: { $0.AlphabeticCode == "EUR" }) {
            leadingCurrencyModel = euro
        }
        
        if let usd = UserManager.shared.currencyList.first(where: { $0.AlphabeticCode == "USD" }) {
            trailingCurrencyModel = usd
        }
        
        
    }
    
    func move(to position: FloatingPanelState, animated: Bool = true, handler: (() -> Void)? = nil) {
        floatingPanel?.move(to: position, animated: animated, completion: handler)
        self.position = position
    }
    
    func updateCurrencyRatesDate() {
        let timestamp = UserManager.shared.currencyUpdatedTimestamp
        if !timestamp.isEmpty,
           let timeInterval = TimeInterval(timestamp) {
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
                let convertedValue = Double(round(100 * (value * (devider.value / devisor.value))) / 100)
                trailingTextFieldText = "\(convertedValue)"
                
            } else {
                let convertedValue = Double(round(100 * (value * (devisor.value / devider.value))) / 100)
                leadingTextFieldText = "\(convertedValue)"
            }
        }
    }
    
    
    //MARK: - Actions
    @objc private func keyboardWillShow(_ notification: Notification) {
        floatingPanel?.move(to: .full, animated: true, completion: nil)
        self.position = .full
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        floatingPanel?.move(to: .full, animated: true, completion: nil)
        self.position = .full
    }
}


extension ConverterPanelViewModel: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        UserManager.shared.currencyList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        UserManager.shared.currencyList[row].Currency
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\n Button tag: \(selectedButtonTag)")
        if selectedButtonTag == 0 {
            leadingCurrencyModel = UserManager.shared.currencyList[row]
            
        } else if selectedButtonTag == 1 {
            trailingCurrencyModel = UserManager.shared.currencyList[row]
        }
    }
}
