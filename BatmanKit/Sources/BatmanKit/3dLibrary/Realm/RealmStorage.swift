//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import RealmSwift

protocol Translatable {
    associatedtype ManagedObject: Object
    
    init(object: ManagedObject)
    func toManagedObject() -> ManagedObject
}

protocol StorageProtocol {
    func cachedPlainObjects<T: Translatable>() -> [T]
    func save<T: Translatable>(objects: [T]) throws
    func deleteAll<T: Translatable>(of type: T.Type) throws
    func delete<T: Translatable>(of type: T.Type, byPrimaryKey key: AnyHashable) throws
}

open class Storage: StorageProtocol {
    
    func cachedPlainObjects<T>() -> [T] where T : Translatable {
        let realm = Realm.instance
        let managedObjects = Array(realm.objects(T.ManagedObject.self))
        let translatedObjects = managedObjects.map({ T(object: $0) })
        return translatedObjects
    }
    
    func deleteAll<T>(of type: T.Type) throws where T : Translatable {
        let realm = Realm.instance
        let managedObjects = Array(realm.objects(T.ManagedObject.self))
        try realm.write({
            realm.delete(managedObjects)
        })
    }
    
    func save<T>(objects: [T]) throws where T : Translatable {
        let realm = Realm.instance
        let managedObjects = objects.map({ $0.toManagedObject() })
        try realm.write {
            realm.add(managedObjects, update: .all)
        }
    }
    
    func delete<T>(of type: T.Type, byPrimaryKey key: AnyHashable) throws where T : Translatable {
        let realm = Realm.instance
        guard let managedObject = realm.object(ofType: T.ManagedObject.self, forPrimaryKey: key) else { return }
        try realm.write({
            realm.delete(managedObject)
        })
    }
}

