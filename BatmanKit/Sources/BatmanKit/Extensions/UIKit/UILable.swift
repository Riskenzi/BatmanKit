//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 02.07.2021.
//

import Foundation
import UIKit

extension UILabel {
    
   open func shadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 8
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
    }
    
}
extension UILabel {
    
   open func textDropShadow(shadowRadius: CGFloat = 0, shadowOpacity: Float = 1, shadowOffset: CGSize, shadowColor: UIColor) {
        layer.masksToBounds = false
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor.cgColor
    }
}
extension UILabel {
    
    func makeStrocked(text: String, strokeColor: UIColor = .blue, textColor: UIColor = .white, strokeWidth: CGFloat = -6, font: UIFont) {
        let strokeTextAttributes = [.strokeColor : strokeColor,
                                    .foregroundColor : textColor,
                                    .strokeWidth : strokeWidth,
                                    .font : font] as [NSAttributedString.Key : Any]
        let customizedText = NSMutableAttributedString(string: text, attributes: strokeTextAttributes)
        attributedText = customizedText
    }
}
