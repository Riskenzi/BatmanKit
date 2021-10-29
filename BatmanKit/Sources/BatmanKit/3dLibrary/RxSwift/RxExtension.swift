//
//  RxExtension.swift
//  Volt
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import RxCocoa
import RxSwift

extension BehaviorRelay where Element: RangeReplaceableCollection {

    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
}
