//
//  Settings.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 1/3/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class News: UITableViewController {
    
    var stockNameArray : [String]? = nil
    var defaults : UserDefaults? = nil
    var helpFunc = HelpFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delete unnecessary rows
        tableView.tableFooterView = UIView()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (stockNameArray != nil) {
            return stockNameArray!.count
        } else {
            return 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        defaults = UserDefaults.standard
        stockNameArray = defaults!.stringArray(forKey: "portfolioValues")
        
        self.tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (stockNameArray != nil) {
            let cell = UITableViewCell()
            let stockName = stockNameArray![indexPath.row]
            let userDefaults = UserDefaults.standard
            let decoded  = userDefaults.data(forKey: stockName)
            let decodedStock = helpFunc.decodeStockObject(fromData: decoded!)
            cell.textLabel?.text = decodedStock!.companyName
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No saved values."
            return cell
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
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "addValue") as? AddValue
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewsList") as! NewsList
        let stockName = stockNameArray![indexPath.row]
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: stockName)
        let decodedStock = helpFunc.decodeStockObject(fromData: decoded!)
        destVC.choosenStock = decodedStock!.symbol
        //print(stockNameArray![indexPath.row])
        destVC.title = tableView.cellForRow(at: indexPath)?.textLabel?.text
        self.navigationController?.pushViewController(destVC, animated: true)
        
    }

}
