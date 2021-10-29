//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import StoreKit

//MARK: - StoreKit Delegates
extension InAppPurchases : SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        productRequestForDelegate(request, didReceive: response)
    }
    
    
}
extension InAppPurchases : SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactionUpdateForDelegate(updatedTransactions: transactions)
    }
}
