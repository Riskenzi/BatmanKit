//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 28.10.2021.
//

import Foundation
extension Date {
    
    func isSame(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs:date)
    }
    
    func append(days: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func append(months: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: months, to: self) ?? self
    }
}
