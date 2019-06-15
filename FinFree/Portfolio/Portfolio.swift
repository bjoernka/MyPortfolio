//
//  Portfolio.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 1/3/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class Portfolio: UITableViewController {
    
    var defaults = UserDefaults.standard
    // Array for names that need to show up in the tableview
    var stockNameArray : [String]? = ["No saved values."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delete unnecessary rows
        tableView.tableFooterView = UIView()
    
        // set BarButtonItems
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onAdd(_:)))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        stockNameArray = defaults.stringArray(forKey: "portfolioValuesNames")
        if stockNameArray == nil {
            stockNameArray = ["No saved values."]
        }
        
        self.tableView.reloadData()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockNameArray!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let stockName = stockNameArray![indexPath.row]
        let decoded  = defaults.data(forKey: stockName)
        if decoded == nil {
            cell.textLabel?.text = stockNameArray![indexPath.row]
        } else {
            let decodedStock = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! Stock
            cell.textLabel?.text = decodedStock.companyName
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stockNameArray?.remove(at: indexPath.row)
            self.tableView.reloadData()
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
        
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "addValue") as? AddValue
        let vc = AddValue()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailStock()
        vc.title = tableView.cellForRow(at: indexPath)?.textLabel?.text
        vc.pickedStock = stockNameArray![indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
