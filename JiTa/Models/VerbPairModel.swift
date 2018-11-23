//
//  VerbPairModel.swift
//  JiTa
//
//  Created by Vorona Vyacheslav on 11/23/18.
//  Copyright © 2018 Vorona Vyacheslav. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public class VerbPairModel: BaseModel, BaseModelProtocol {

    let verbs = List<VerbModel>()

    public convenience init(dummy: Int) {
        self.init()
        self.id = generateUuidString()

    }
}
