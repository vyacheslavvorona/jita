//
//  Realm+Ext.swift
//  Biller
//
//  Created by Vorona Vyacheslav on 10/26/17.
//  Copyright © 2017 Vorona Vyacheslav. All rights reserved.
//

import Foundation
import RealmSwift

public extension Realm {
    
    private static var _threadKey = "Biller.RealmObject"
    
    private static var _currentThreadsRealmObject: Realm? {
        get {
            let threadDict = Thread.current.threadDictionary
            return threadDict[_threadKey] as? Realm
        }
        set(newRealm) {
            let threadDict = Thread.current.threadDictionary
            return threadDict[_threadKey] = newRealm
        }
    }
    
    public static func getRealm() -> Realm {
        
        if let r = _currentThreadsRealmObject {
            return r
        }
        do {
            let r = try Realm()
            _currentThreadsRealmObject = r
            return r
        } catch {
            let errorString = "fail to load Realm:\(error)"
            fatalError(errorString)
        }
    }
}
