//
//  SubscriptionService.swift
//  CamelApp
//
//  Created by Igor Ryazancev on 5/9/19.
//  Copyright © 2019 Igor Ryazancev. All rights reserved.
//

import Foundation
import StoreKit

class SubscriptionServie: NSObject {
    static let shared = SubscriptionServie()
    
    var options: [Subscription]? {
        didSet {
           // NotificationCenter.default.post(name: SubscriptionService.optionsLoadedNotification, object: options)
        }
    }
    
    func loadSubscriptionOptions() {
        //SKPaymentQueue.default().add(self)
        let productIDPrefix = Bundle.main.bundleIdentifier! + "."
        
        let oneMonth = "camel_purchase_month"
        let threeMonth  =  "purchase_camel_3month"
        let allAccessMonthly = "purchase_camel_forever"
        
        let productIDs = Set([oneMonth, threeMonth, allAccessMonthly])
        
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
}

extension SubscriptionServie: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        options = response.products.map { Subscription(product: $0) }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKProductsRequest {
            print("Subscription Options Failed Loading: \(error.localizedDescription)")
        }
    }
}

extension SubscriptionServie {
//    func uploadReceipt(completion: ((_ success: Bool) -> Void)? = nil) {
//        if let receiptData = loadReceipt() {
//            SelfieService.shared.upload(receipt: receiptData) { [weak self] (result) in
//                guard let strongSelf = self else { return }
//                switch result {
//                case .success(let result):
//                    strongSelf.currentSessionId = result.sessionId
//                    strongSelf.currentSubscription = result.currentSubscription
//                    completion?(true)
//                case .failure(let error):
//                    print("🚫 Receipt Upload Failed: \(error)")
//                    completion?(false)
//                }
//            }
//        }
//    }
    
    private func loadReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading receipt data: \(error.localizedDescription)")
            return nil
        }
    }
}
