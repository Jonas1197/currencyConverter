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
    private var inAppPurchaseHelper: InAppPurchaseHelper!
    
    @Published var purchaseComplete: Bool?
    
    init(_ output: SettingsOutput) {
        self.output = output
        inAppPurchaseHelper = .init()
        subscribeToInAppPurchaseHelper()
    }
    
    private func subscribeToInAppPurchaseHelper() {
        
        inAppPurchaseHelper.subscribe(to: inAppPurchaseHelper.$product) { [weak self] prodcut in
            guard let self    = self,
                  let product = prodcut else { return }
            self.makePurchase(product)
        }
        
        inAppPurchaseHelper.subscribe(to: inAppPurchaseHelper.$purchaseComplete) { [weak self] complete in
            guard let self     = self,
                  let complete = complete else { return }
            
            self.purchaseComplete = complete
        }
    }
    
    func makeDonation() {
        requestDonationProdcut()
    }
    
    private func requestDonationProdcut() {
        inAppPurchaseHelper.requestProduct()
    }
    
    private func makePurchase(_ product: SKProduct) {
        inAppPurchaseHelper.makePurchase(product)
    }
    
}
