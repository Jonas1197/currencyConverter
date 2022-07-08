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
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "hello"
    }
}
