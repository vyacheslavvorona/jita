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

    private var verbPairs: [VerbPairModel] = []
    private var searchPairs: [VerbPairModel] = []

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

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.addTarget(self, action: #selector(performSearch), for: UIControlEvents.allEditingEvents)

        }
    }

    @IBOutlet weak var clearButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.layer.shadowColor = UIColor.black.cgColor
            addButton.layer.shadowOffset = CGSize.zero
            addButton.layer.shadowOpacity = 1
            addButton.layer.shadowRadius = 3
            addButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchVerbPairs()

        searchTextField.delegate = self

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "PairCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fetchVerbPairs() {
        let pairs = Realm.getRealm().objects(VerbPairModel.self).filter(NSPredicate(format: "#verbs.@count == 2"))
        if !pairs.isEmpty {
            verbPairs = Array(pairs)
            tableView.reloadData()
        } else {
            if let fileUrl = Bundle.main.url(forResource: "rawString", withExtension: "txt") {
                do {
                    let text = try String(contentsOf: fileUrl, encoding: .utf8)
                    RawStringParser.parseInitialSource(source: text) { () -> Void in
                        let parsedPairs = Realm.getRealm().objects(VerbPairModel.self).filter(NSPredicate(format: "#verbs.@count == 2"))
                        self.verbPairs = Array(parsedPairs)
                        self.tableView.reloadData()
                    }
                }
                catch {/* error handling here */}
            }
        }
    }

    @objc func performSearch() {
        searchPairs = []
        if searchTextField.text != "" {
            for pair in verbPairs {
                if pair.verbs[0].kanji.lowercased().contains(searchTextField.text!.lowercased()) ||
                    pair.verbs[0].hiragana.lowercased().contains(searchTextField.text!.lowercased()) ||
                    pair.verbs[0].enTranslation.lowercased().contains(searchTextField.text!.lowercased()) ||
                    pair.verbs[1].kanji.lowercased().contains(searchTextField.text!.lowercased()) ||
                    pair.verbs[1].hiragana.lowercased().contains(searchTextField.text!.lowercased()) ||
                    pair.verbs[1].enTranslation.lowercased().contains(searchTextField.text!.lowercased()) {

                    searchPairs.append(pair)
                }
            }
        }
        tableView.reloadData()
    }

    @IBAction func clearButtonTap(_ sender: Any) {
        self.searchTextField.text = ""
        tableView.reloadData()
    }

    @IBAction func addButtonTap(_ sender: Any) {
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTextField.text!.isEmpty {
            return verbPairs.count
        } else {
            return searchPairs.count
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PairCell") as? Cell else {
            return UITableViewCell()
        }

        let cellPair: VerbPairModel?
        if searchTextField.text!.isEmpty {
            cellPair = verbPairs[indexPath.row]
        } else {
            cellPair = searchPairs[indexPath.row]
        }

        if let cp = cellPair {
            for verb in cp.verbs {
                if verb.type == TransitiveIntransitive.transitive.rawValue {
                    cell.taLabel.text = verb.kanji + " - " + verb.hiragana
                    cell.taTranslationLabel.text = verb.enTranslation
                } else {
                    cell.jiLabel.text = verb.kanji + " - " + verb.hiragana
                    cell.jiTranslationLabel.text = verb.enTranslation
                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
