//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import RealmSwift

extension Realm {
    
    static var instance: Realm {
        let configuration = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: false)
        return try! Realm(configuration: configuration)
    }
    
}
extension Realm {
    
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
