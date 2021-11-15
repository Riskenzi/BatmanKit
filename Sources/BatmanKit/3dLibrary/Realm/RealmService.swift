//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import UIKit
import RealmSwift

open class RealmService {
    
    // MARK: - Root Realm DataBase
    
  public  static let config = Realm.Configuration(
        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).
        schemaVersion: 1,
        // Set the block which will be called automatically when opening a Realm with
        // a schema version lower than the one set above
        migrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            switch oldSchemaVersion {
            case 1:
                break
            default:
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
                break
            }
        })
    
    // Init realm with configurations for handle migrations.
    // It will make possible to find created and removed properties.
    // Realm will update data base automatical.
    public var realm = try! Realm(configuration: RealmService.config)
    
    // MARK: - Life cycle
    
  public  init() { }
    
    // MARK: - Generic
    
   public func loadTable<T: Object>(ofType: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    
    public func autoID<T: Object>(ofType: T.Type) -> Int {
        let realm = try! Realm()
        return (realm.objects(T.self).max(ofProperty: "primaryKey") as Int? ?? 0) + 1
    }
    
    public func updateObject(_ object: Object, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print("⚠️Failed to update \(object) in realm: \(error.localizedDescription)")
        }
    }
    
    public func setData<T: RealmSwift.Object>(_ data: [T]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(data)
            }
        } catch let error as NSError {
            print("cannot write products \(error)")
        }
    }
    public  func insertObject<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .error)
            }
        } catch {
            print("⚠️Failed to update \(object) in realm: \(error.localizedDescription)")
        }
    }
    
    public  func updateRealm<T: Object>(_ object: T, with dictionary: [String: Any]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print("⚠️Failed to update \(object) in realm: \(error.localizedDescription)")
        }
    }
    
    
    public func deleteRealm<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("⚠️Failed to update \(object) in realm: \(error.localizedDescription)")
        }
    }
    
    
    public  func dropDatabase() -> Bool {
        do {
            try realm.write {
                realm.deleteAll()
            }
            return true
        } catch {
            print("⚠️Failed to delete all")
            return false
        }
    }
}
    
    
