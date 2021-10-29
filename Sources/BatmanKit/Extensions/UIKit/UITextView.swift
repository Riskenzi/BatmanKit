//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import UIKit

public extension UITextView {

    private class PlaceholderLabel: UILabel { }

    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            return label
        }
    }

    var placeholder: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            updatePlaceholderLabel()

            textStorage.delegate = self
        }
    }
    
    var placeholderColor: UIColor? {
        get {
            return placeholderLabel.textColor
        }
        set {
            placeholderLabel.textColor = newValue
        }
    }
    
    var placeholderFont: UIFont? {
        get {
            return subviews.compactMap({ $0 as? PlaceholderLabel }).first?.font
        }
        set {
            placeholderLabel.font = newValue
            updatePlaceholderLabel()
        }
    }
    
    // MARK: - Private
    
    private func updatePlaceholderLabel() {
        let width = frame.width - textContainerInset.left - textContainerInset.right
        let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        placeholderLabel.frame.size.height = size.height
        placeholderLabel.frame.size.width = width
        placeholderLabel.frame.origin = CGPoint(x: textContainerInset.left + textContainer.lineFragmentPadding, y: textContainerInset.top)
    }

}

extension UITextView: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

}
