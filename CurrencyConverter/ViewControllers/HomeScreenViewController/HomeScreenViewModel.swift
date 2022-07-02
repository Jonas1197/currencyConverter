//
//  HomeScreenViewModel.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit
import Combine

protocol HomeScreenOutput: AnyObject {
    
}

final class HomeScreenViewModel: NSObject {
    weak var output: HomeScreenOutput?
    
    @Published var isKeyboardShowing: Bool?
    
    init(output: HomeScreenOutput?) {
        super.init()
        self.output = output
    }
    
    func listenToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillDisappear() {
        isKeyboardShowing = false
    }
    
    @objc private func keyboardWillAppear() {
        isKeyboardShowing = true
    }
    
}
