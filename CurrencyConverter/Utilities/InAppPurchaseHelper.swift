//
//  InAppPurchaseHelper.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 29/07/2022.
//

import Foundation
import StoreKit
import Combine

final class InAppPurchaseHelper: NSObject, Subscribable {
    var cancellable: [AnyCancellable] = []
    
    static var canMakePurchases: Bool {
        SKPaymentQueue.canMakePayments()
    }
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    @Published var purchaseComplete: Bool?
    @Published var product:          SKProduct?
    
    private var productIdentifiers: Set<String> = [Constants.InAppPurchase.smallDonationProductId]
    private var productRequest:     SKRequest?
    
    func makePurchase(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func requestProduct() {
        productRequest?.cancel()
        productRequest           = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest?.delegate = self
        productRequest?.start()
    }
}

//MARK: - SKProductsRequestDelegate
extension InAppPurchaseHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            self.product = product
        } else {
            print("\n~~> [InAppPurchaseHelper] Product was not found,")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("\n~~> [InAppPurchaseHelper] Failed to retrieve product with error: \(error.localizedDescription)")
        productRequest = nil
    }
}

//MARK: - SKPaymentTransactionObserver
extension InAppPurchaseHelper: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing: break
            case .purchased:  complete(transaction)
            case .failed:     fail(transaction)
            case .restored:   break
            case .deferred:   break
            @unknown default: break
            }
        }
    }
    
    private func complete(_ transaction: SKPaymentTransaction) {
        purchaseComplete = true
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(_ transaction: SKPaymentTransaction) {
        purchaseComplete = false
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            print("\n~~> [InAppPurchaseHelper] Transaction error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
