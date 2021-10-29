//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import UIKit

protocol CellInterface {
    
    static var identifier: String { get }
    static var nib: UINib { get }
    
}

extension CellInterface {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

