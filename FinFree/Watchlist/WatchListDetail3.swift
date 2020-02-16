//
//  WatchListDetail3.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 8/1/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import UIKit

class WatchListDetail3: UITableViewController {
    
    let criterias = ["Name: ", "Date: ", "Saved Price: ", "Current Price: ", "Change: ", "Desired Price: "]
    var selectedStock = ""
    var selectedStockFile = ""
    let userDefaults = UserDefaults.standard
    let helpFunc = HelpFunctions()
    var decodedStock: WatchListItem? = nil
    var token = Token()
    var currentPriceDownloaded = 0.0
    var calculate = Calculation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.onAdd(_:)))
        
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getStock()
        
        getCurrentPrice()
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return criterias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if decodedStock != nil {
            switch indexPath.row {
            case 0:
                let watchListCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
                watchListCell.leftLabel.text = criterias[indexPath.row]
                watchListCell.rightLabel.text = decodedStock!.companyName
                return watchListCell
            case 1:
                let watchListCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
                watchListCell.leftLabel.text = criterias[indexPath.row]
                watchListCell.rightLabel.text = decodedStock!.date.description
                return watchListCell
            case 2:
                let watchListCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
                watchListCell.leftLabel.text = criterias[indexPath.row]
                watchListCell.rightLabel.text = String(decodedStock!.currentPrice)
                return watchListCell
            case 3:
                let watchListCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
                watchListCell.leftLabel.text = criterias[indexPath.row]
                watchListCell.rightLabel.text = currentPriceDownloaded.description
                return watchListCell
            case 4:
                let watchListCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
                watchListCell.leftLabel.text = criterias[indexPath.row]
                watchListCell.rightLabel.text = calculate.changeInPercentage(purchasePrice: currentPriceDownloaded, currentPrice: decodedStock!.currentPrice)
                return watchListCell
            case 5:
                let watchListCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
                watchListCell.leftLabel.text = criterias[indexPath.row]
                watchListCell.rightLabel.text = decodedStock!.desiredPrice.description
                return watchListCell
            default:
                let watchListCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
                watchListCell.leftLabel.text = "Value"
                return watchListCell
            }
        } else {
            let watchListCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
            watchListCell.leftLabel.text = criterias[indexPath.row]
            return watchListCell
        }
        
    }
    
    func getStock() {
        // get picked Stock object
        print(selectedStockFile)
        let decoded  = userDefaults.data(forKey: selectedStockFile)
        decodedStock = helpFunc.decodeWatchListObject(fromData: decoded!)
    }
    
    func getCurrentPrice() {
        
        let urlString = token.testURL(symbol: selectedStock, info: "/quote")
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                print(data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("Json ist:")
                    print(json)
                    if let dictionary = json as? [String: Any] {
                        if let curPrice = dictionary["latestPrice"] as? Double {
                            self.currentPriceDownloaded = curPrice
                        }
                    }
                } catch {
                    print("The error is:")
                    print(error)
                }
            }
            self.tableView.reloadData()
        }.resume()
        
        return
    }
    
    @objc func onAdd(_ sender : AnyObject?) {
        
        self.tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height / 9
    }
    
}
