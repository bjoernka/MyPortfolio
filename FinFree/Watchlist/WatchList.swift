//
//  News.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 1/3/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class WatchList: UITableViewController {
    
    var watchListStocks: [String] = []
    var watchListStocksNames: [String] = []
    var watchListStocksSymbols: [String] = []
    var watchListStocksDefault: [String]? = nil
    let helpFunc = HelpFunctions()
    var allWatchListItems: [WatchListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delete unnecessary rows
        tableView.tableFooterView = UIView()
        
        // set BarButtonItems
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onAdd(_:)))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        watchListStocksNames = []
        watchListStocksSymbols = []
        
        for watchListItem in allWatchListItems {
            watchListStocksNames.append(watchListItem.companyName)
            watchListStocksSymbols.append(watchListItem.symbol)
        }
  
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if allWatchListItems.count > 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = watchListStocksNames[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No saved stocks"
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if watchListStocksDefault != nil {
            let destVC = WatchListDetailTabBar()
            print(watchListStocksSymbols[indexPath.row])
            destVC.selectedStock = watchListStocksSymbols[indexPath.row]
            destVC.stockFile = watchListStocksDefault![indexPath.row]
            destVC.title = watchListStocksNames[indexPath.row]
            self.navigationController?.pushViewController(destVC, animated: true)
        } else {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allWatchListItems.count > 0 {
            return allWatchListItems.count
        } else {
            return 1
        }
    }
    
    // Gets called everytime the user wants too add a stock
    @objc func onAdd(_ sender : AnyObject?) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        
        let vc = AddValueForWatchlist()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
