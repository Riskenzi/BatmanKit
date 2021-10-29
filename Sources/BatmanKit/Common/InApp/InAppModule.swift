//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import SnapKit
import StoreKit
import SwiftyStoreKit

public protocol InAppManagedActions {
    func openApp()
    func moduleMessage(message : String)
}

open class InAppPurchases : NSObject {
    public static let selfShared = InAppPurchases()
    
    public struct Configuration {
       public var storeProductIdentifiers : Set<String>
       public var sharedKey : String
    }
    
    private static var configuration : Configuration?
    
    public var storeItems = SKProduct()
    public var restoreValidations : Int = 0
    public var userHaveActivePurchases : Bool = false
    var event : InAppManagedActions? = nil
    fileprivate let messageInvalid : String = "Invalid identifier"
    
   open class func start(_ configuration : Configuration) {
        InAppPurchases.configuration = configuration
    }
    
    private override init() {
        guard let configuration = InAppPurchases.configuration else {
            fatalError("Error - you must call setup before accessing InAppPurchases.shared")
        }
        
        print(configuration)
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    //MARK: - Module Methods
    
    open func featchStoreItems(){
        let request = SKProductsRequest(productIdentifiers: InAppPurchases.configuration!.storeProductIdentifiers)
        request.delegate = self
        request.start()
    }
    
    
    public func pay(){
        if storeItems.productIdentifier == "" {
            self.event?.moduleMessage(message: messageInvalid)
        } else {
            let payment = SKPayment(product: storeItems)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    public func restore(){
        restoreValidations = 0
        restoreSupportedSwiftyStoreKit()
    }
    
    public func transactionUpdateForDelegate(updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                self.completeTransactions()
                event!.openApp()
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                completeRestored()
            case .purchasing,.deferred: break
            default: break
            }
        }
    }
    
    public func productRequestForDelegate(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let requesProducts = response.products
        if response.products.count != 0 {
            if let prod = requesProducts.first {
                storeItems = prod
            }
        }
    }
    
    //MARK: SwiftyStoreKit Extension
    public  func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { transactions in
            for transaction in transactions {
                if transaction.transaction.transactionState == .purchased || transaction.transaction.transactionState == .restored {
                    if transaction.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(transaction.transaction)
                    }
                    NSLog("purchased: \(transaction.productId)")
                }
            }
        }
    }
    
    public func validationSubscription(_ completion: @escaping (Bool) -> Void) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: InAppPurchases.configuration!.sharedKey ) //self.sharedKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                guard let productID = InAppPurchases.configuration?.storeProductIdentifiers.first else { return }
                let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productID, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, _):
                    print(expiryDate > Date())
                    completion(expiryDate > Date())
                    
                case .expired:
                    print("expired")
                    
                    completion(false)
                case .notPurchased:
                    completion(false)
                }
            case .error(let error):
                completion(false)
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    public func completeRestored(){
        if restoreValidations == 0 {
            restoreValidations = 1
            validationSubscription { completeRestore
                in
                if completeRestore {
                    self.event?.openApp()
                }else {
                    self.event?.moduleMessage(message: "Nothing to Restore")
                }
                self.userHaveActivePurchases = completeRestore
            }
        }
    }
    
    
    public func restoreSupportedSwiftyStoreKit(){
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                self.completeRestored()
            }
            else {
                self.event?.moduleMessage(message: "Nothing to Restore")
            }
        }
    }
    
    
    
    
}
