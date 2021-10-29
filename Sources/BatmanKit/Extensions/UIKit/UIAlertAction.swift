//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 28.10.2021.
//

import Foundation
import UIKit

extension UIAlertAction {
    
    open  var textColor: UIColor? {
        set { setValue(newValue, forKey: "titleTextColor") }
        get { return value(forKey: "titleTextColor") as? UIColor }
    }
}
