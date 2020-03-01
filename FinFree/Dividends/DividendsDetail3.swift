//
//  DividendsDetail3.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 11/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class DividendsDetail3: UITableViewController {

    let userDefaults = UserDefaults.standard
    var dividendNameArray: [String]? = ["No saved Data"]
    var allDividends: [Dividend] = []
    let helpFunc = HelpFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
//        dividendNameArray = userDefaults.stringArray(forKey: "dividendArrayNew")
//        if dividendNameArray == nil {
//            dividendNameArray = ["No saved Data"]
//        } else {
//            for divName in dividendNameArray! {
//                let decoded  = userDefaults.data(forKey: divName)
//                if decoded != nil {
//                    let decodedDividend = helpFunc.decodeDividendObject(fromData: decoded!)
//                    //let decodedDividend = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! Dividend
//                    allDividends.append(decodedDividend!)
//                }
//            }
//        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allDividends.count > 0 {
            return allDividends.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let watchListCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
        
        if allDividends.count > 0 {
            watchListCell.leftLabel.text = allDividends[indexPath.row].companyName
            watchListCell.rightLabel.text = "\(allDividends[indexPath.row].totalPrice)"
            return watchListCell
        } else {
            watchListCell.leftLabel.text = dividendNameArray![indexPath.row]
            return watchListCell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            dividendNameArray?.remove(at: indexPath.row)
            userDefaults.set(dividendNameArray!, forKey: "dividendArrayNew")
            self.tableView.reloadData()
        }
    }
}
