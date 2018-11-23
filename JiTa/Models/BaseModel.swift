//
//  BaseModel.swift
//  JiTa
//
//  Created by Vorona Vyacheslav on 11/23/18.
//  Copyright © 2018 Vorona Vyacheslav. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public class BaseModel: Object {

    @objc public dynamic var id: String = ""
    @objc public dynamic var created: Date?
    @objc public dynamic var lastUpdated: Date?

    public override static func primaryKey() -> String? {
        return "id"
    }

    public override convenience init(value: Any) {
        self.init(value: value)
        self.id = generateUuidString()
    }

    public func generateUuidString() -> String {
        return UUID().uuidString
    }
}

public protocol BaseModelProtocol {

    static func relations() -> [RelationshipData]
    static func includeRelations() -> [String : BaseModelProtocol.Type]
    static func excludeSubRelationships() -> [String]
}

public extension BaseModelProtocol where Self: BaseModel {

    static func relations() -> [RelationshipData] {
        return self.includeRelations().map { (name, type) in
            return RelationshipData(name: name, type: type, include: true)
        }
    }

    static func includeRelations() -> [String : BaseModelProtocol.Type] { return [:] }
    static func excludeSubRelationships() -> [String] { return [] }

    // Get an Object by its primary key value
    static func object(_ realm: Realm = Realm.getRealm(), pk pkValue: Any) -> Self? {
        return realm.object(ofType: self, forPrimaryKey: pkValue)
    }

    // Get objects from local realm storage with specified filter conditions.
    static func objects(_ realm: Realm = Realm.getRealm()) -> Results<Self> {
        return realm.objects(Self.self)
    }

    // Create a Realm Object with given values
    static func create(_ realm: Realm = Realm.getRealm(), value: Any = [:], update: Bool = false) throws -> Self {
        return realm.create(Self.self, value: value, update: update)
    }
}

public struct RelationshipData {

    let name: String
    let type: BaseModelProtocol.Type
    let excludeSubs: [String]?      //  don't include this sub-relationship

    var object: Object.Type {
        return type as! Object.Type // swiftlint:disable:this force_cast
    }

    init(name: String, type: BaseModelProtocol.Type, include: Bool, storeAsJson: Bool = false, excludeSubs: [String]? = nil) {
        self.name = name
        self.type = type
        self.excludeSubs = excludeSubs
        assert(type is Object.Type, "we can only support Objects.Type that also have BaseModelProtocol.Type ")
    }
}


