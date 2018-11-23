//
//  ViewController.swift
//  JiTa
//
//  Created by Vorona Vyacheslav on 11/23/18.
//  Copyright © 2018 Vorona Vyacheslav. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ViewController: UIViewController {

    @IBOutlet weak var topView: UIView! {
        didSet {
            topView.layer.shadowColor = UIColor.black.cgColor
            topView.layer.shadowOffset = CGSize.zero
            topView.layer.shadowOpacity = 1
            topView.layer.shadowRadius = 3
        }
    }

    @IBOutlet weak var searchView: UIView! {
        didSet {
            searchView.layer.shadowColor = UIColor.black.cgColor
            searchView.layer.shadowOffset = CGSize.zero
            searchView.layer.shadowOpacity = 1
            searchView.layer.shadowRadius = 1
        }
    }

    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchVerbPairs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fetchVerbPairs() {
        let pairs = Realm.getRealm().objects(VerbPairModel.self)
        if !pairs.isEmpty {

        } else {
            if let fileUrl = Bundle.main.url(forResource: "rawString", withExtension: "txt") {
                do {
                    let text = try String(contentsOf: fileUrl, encoding: .utf8)
                    RawStringParser.parseInitialSource(source: text) { () -> Void in
                        let parsedPairs = Realm.getRealm().objects(VerbPairModel.self)
                    }
                }
                catch {/* error handling here */}
            }
        }
    }
}

