//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 02.07.2021.
//

import Foundation
import UIKit

extension UIViewController {
   open func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    open func showAlert(title: String, message : String)-> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension UIViewController {
    
    var bottomPadding: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }
    
    var topPadding: CGFloat {
        return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    }
}
extension UIViewController {
    
    func share(text: String, sourceView: UIView?, sourceRect: CGRect) {
        share(items: [text], sourceView: sourceView, sourceRect: sourceRect)
    }
    
    func share(items: [Any], sourceView: UIView?, sourceRect: CGRect) {
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if UIDevice.isPad {
            activityVC.popoverPresentationController?.sourceView = sourceView
            activityVC.popoverPresentationController?.sourceRect = sourceRect
        }
        present(activityVC, animated: true, completion: nil)
    }
    
    func showToast(message: String) {
        view.makeToast(message)
    }
}

