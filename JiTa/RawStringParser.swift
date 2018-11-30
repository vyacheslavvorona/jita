//
//  RawStringParser.swift
//  JiTa
//
//  Created by Vorona Vyacheslav on 11/23/18.
//  Copyright © 2018 Vorona Vyacheslav. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public class RawStringParser {

    static public func parseInitialSource(source: String, completion: (() -> Void)? = nil) {
        let rawPairsArraw: [String] = source.components(separatedBy: "<pair>")

        for rawPair in rawPairsArraw {
            let realm = Realm.getRealm()

            let newPair = VerbPairModel(dummy: 0)

            var typeCounter = 1

            let rawVerbsArray: [String] = rawPair.components(separatedBy: "<sep>")
            for rawVerb in rawVerbsArray {
                let hiragana = rawVerb.slice(from: "<hiragana>", to: "<_hiragana>")
                let kanji = rawVerb.slice(from: "<kanji>", to: "<_kanji>")

                let enTranslation = rawVerb.slice(from: "<entrans>", to: "<_entrans>")?.trimmingCharacters(in: .whitespacesAndNewlines)

                if let h = hiragana, let et = enTranslation, let ti = TransitiveIntransitive(rawValue: typeCounter) {
                    let newVerb = VerbModel(type: ti, hiragana: h, enTranslation: et)

                    if let k = kanji {
                        newVerb.kanji = k
                    }

                    try! realm.write {
                        realm.add(newVerb)
                        newPair.verbs.append(newVerb)
                    }

                    typeCounter += 1
                }

                try! realm.write {
                    realm.add(newPair)
                }
            }
            typeCounter = 1
        }

        if let c = completion {
            c()
        }
    }
}
