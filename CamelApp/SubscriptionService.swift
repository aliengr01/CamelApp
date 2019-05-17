//
//  SubscriptionService.swift
//  CamelApp
//
//  Created by Igor Ryazancev on 5/9/19.
//  Copyright © 2019 Igor Ryazancev. All rights reserved.
//

import Foundation
import StoreKit

class SubscriptionService: NSObject {
    static let dissmissNotification = Notification.Name("SubscriptionServiceSessionDissmissNotification")
    static let optionsLoadedNotification = Notification.Name("SubscriptionServiceOptionsLoadedNotification")
    static let showSubscriptionController = Notification.Name("ShowSubscriptionControllerNotification")

    
    static let shared = SubscriptionService()
    
    var show: Bool = true
    
    var options: [Subscription]? {
        didSet {
            NotificationCenter.default.post(name: SubscriptionService.optionsLoadedNotification, object: options)
        }
    }
    
    func loadSubscriptionOptions() {
        let oneMonth = "camel_purchase_month"
        let threeMonth  =  "purchase_camel_3month"
        let allAccessMonthly = "purchase_camel_forever"
        let productIDs = Set([oneMonth, threeMonth, allAccessMonthly])
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
}

extension SubscriptionService: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        options = response.products.map { Subscription(product: $0) }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKProductsRequest {
            print("Subscription Options Failed Loading: \(error.localizedDescription)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    NotificationCenter.default.post(name: SubscriptionService.dissmissNotification, object: nil)
                case .failed:
                    print("failed")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        if self.show {
                            NotificationCenter.default.post(name: SubscriptionService.showSubscriptionController, object: nil)
                        }
                    }
                    
                case .restored:
                    print("restored")
                    show = false
                    NotificationCenter.default.post(name: SubscriptionService.dissmissNotification, object: nil)
                default: break
                }
            }
        }
    }
    
}

extension SubscriptionService {
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchase(subscription: Subscription) {
        let payment = SKPayment(product: subscription.product)
        SKPaymentQueue.default().add(payment)
    }
    

    func restorePurchases(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
