//
//  VerbModel.swift
//  JiTa
//
//  Created by Vorona Vyacheslav on 11/23/18.
//  Copyright © 2018 Vorona Vyacheslav. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public enum TransitiveIntransitive: Int {
    case transitive = 1
    case intransitive = 2
}

public class VerbModel: BaseModel, BaseModelProtocol {

    @objc public dynamic var hiragana: String = ""
    @objc public dynamic var kanji: String = ""
    @objc public dynamic var enTranslation: String = ""
    @objc public dynamic var type = Int()
//    @objc public dynamic var pair: VerbPairModel?

    public convenience init(type: TransitiveIntransitive, hiragana: String, enTranslation: String) {
        self.init()
        self.id = generateUuidString()

        self.type = type.rawValue
        self.hiragana = hiragana
        self.enTranslation = enTranslation
    }
}
