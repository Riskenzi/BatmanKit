//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import UIKit
private class ExampleUsedInAppManager {
    //MARK : Config file
    enum Product : String, CaseIterable {
        case k_productID = "youStoreID"
        case sharedSecret = "ashdbajnsbdsakmdksamksamdkasmdkasm"
    }

    // MARK: SceneDelegate
    class SceneDelegate: UIResponder, UIWindowSceneDelegate {
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            InAppPurchases.start(InAppPurchases.Configuration(storeProductIdentifiers: Set(Product.allCases.compactMap( { $0.rawValue})), sharedKey: Product.sharedSecret.rawValue))
            InAppPurchases.selfShared.featchStoreItems()
            InAppPurchases.selfShared.completeTransactions()
            InAppPurchases.selfShared.validationSubscription { status in
                if status {
                    print("have subs")
                }else {
                    print("not have")
                }
            }
        }
    }

    // MARK: UIViewController
    class UserInterectiveController: BaseController, InAppManagedActions {
        func openApp() {
            print(#function)
        }
        
        func moduleMessage(message: String) {
            self.showToast(message: message)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            InAppPurchases.selfShared.event = self
        }
        
    }

}
