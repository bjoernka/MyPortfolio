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
    let helpFunc = HelpFunctions()
    
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
        
        let defaults = UserDefaults.standard
        let watchListStocksDefault = defaults.stringArray(forKey: "watchListArrayNew1")
        if (watchListStocksDefault == nil) {
            watchListStocksNames = ["No Stocks in Watchlist"]
        } else {
            watchListStocks = defaults.stringArray(forKey: "watchListArrayNew1")!
            for watchListStock in watchListStocks {
                let decoded  = defaults.data(forKey: watchListStock)
                let decodedStock = helpFunc.decodeWatchListObject(fromData: decoded!)
                //let decodedStock = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! WatchListItem
                print(decodedStock!.companyName)
                watchListStocksNames.append(decodedStock!.companyName)
                watchListStocksSymbols.append(decodedStock!.symbol)
            }
        }
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = watchListStocksNames[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destVC = WatchListDetailTabBar()
        print(watchListStocksSymbols[indexPath.row])
        destVC.selectedStock = watchListStocksSymbols[indexPath.row]
        self.navigationController?.pushViewController(destVC, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchListStocksNames.count
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
