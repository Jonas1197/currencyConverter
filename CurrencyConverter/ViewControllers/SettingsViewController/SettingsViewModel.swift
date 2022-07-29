//
//  SettingsViewModel.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 24/07/2022.
//

import Foundation
import StoreKit
import Combine

protocol SettingsOutput: AnyObject {
    func settingsDidDisappear()
    func settingsUpdated()
}

final class SettingsViewModel {
    weak var output: SettingsOutput?
    
    @Published var purchaseComplete: Bool?
    
    init(_ output: SettingsOutput) {
        self.output = output
        subscribeToInAppPurchaseHelper()
    }
    
    private func subscribeToInAppPurchaseHelper() {
        
        InAppPurchaseHelper.shared.subscribe(to: InAppPurchaseHelper.shared.$product) { [weak self] prodcut in
            guard let self    = self,
                  let product = prodcut else { return }
            self.makePurchase(product)
        }
        
        InAppPurchaseHelper.shared.subscribe(to: InAppPurchaseHelper.shared.$purchaseComplete) { [weak self] complete in
            guard let self     = self,
                  let complete = complete else { return }
            
            self.purchaseComplete = complete
        }
    }
    
    func makeDonation() {
        requestDonationProdcut()
    }
    
    private func requestDonationProdcut() {
        InAppPurchaseHelper.shared.requestProduct()
    }
    
    private func makePurchase(_ product: SKProduct) {
        InAppPurchaseHelper.shared.makePurchase(product)
    }
    
}
