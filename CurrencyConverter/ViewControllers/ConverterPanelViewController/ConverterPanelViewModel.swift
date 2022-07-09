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
        if textField.tag == 0 {
            
            // get leading currency
            // convert leading to trailing
            // update trailing textField
            
        } else if textField.tag == 1 {
            // get trailing currency
            // convert trailing to leading
            // update leading textField
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
        if selectedButtonTag == 0 {
            leadingCurrencyModel = UserManager.shared.currencyList[row]
            
        } else if selectedButtonTag == 1 {
            trailingCurrencyModel = UserManager.shared.currencyList[row]
        }
    }
}
