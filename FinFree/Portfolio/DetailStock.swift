//
//  DetailStock.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 5/5/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class DetailStock: UITableViewController {
    
    var criterias = ["Company name: ", "Purchase Date: ",  "Purchase price: ", "Current Price: ", "Change: "]
    var companyName = ""
    var purchasePrice = 0.0
    var amount = 0.0
    var pricePerShare = 0.0
    var curPrice = 0.0
    var change = "0.0%"
    var purchaseDate = Date()
    var changeLabel = UILabel()
    var decodedStock = Stock(symbol: "Not available", companyName: "Not available", sector: "Not available", amount: 0.0, price: 0.0, fees: 0.0, taxes: 0.0, date: Date(), totalPrice: 0.0)
    var calculation = Calculation()
    let userDefaults = UserDefaults.standard
    var pickedStock = ""
    var token = Token()
    var helpFunc = HelpFunctions()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return criterias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
        cell.leftLabel.text = criterias[indexPath.row]
        if (indexPath.row == 0) {
            cell.rightLabel.text = companyName
        }  else if (indexPath.row == 1) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let purchaseDateString = formatter.string(from: purchaseDate)
            cell.rightLabel.text = purchaseDateString
        } else if (indexPath.row == 2) {
            cell.rightLabel.text = "\(purchasePrice)"
        } else if (indexPath.row == 3) {
            if amount != 0 {
                curPrice = curPrice * amount
                cell.rightLabel.text = "\(curPrice)"
            } else {
                cell.rightLabel.text = "\(curPrice)"
            }
        } else {
            cell.rightLabel.text = changeLabel.text
            let index = self.change.index(self.change.startIndex, offsetBy: 1)
            let currentStockPriceFirst = String(self.change.prefix(upTo: index))
            print("CurrentStock: " + "\(currentStockPriceFirst)")
            if (currentStockPriceFirst == "-") {
                cell.rightLabel.textColor = UIColor.red
            } else if (currentStockPriceFirst == "+") {
                cell.rightLabel.textColor = UIColor.green
            } else {
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.green
        self.view.addSubview(activityIndicator)
        getStock()
        self.tableView.reloadData()
    }
    
    func getStock() {
        // get picked Stock object
        let decoded  = userDefaults.data(forKey: pickedStock)
        decodedStock = helpFunc.decodeStockObject(fromData: decoded!)!
        print("Decoded:")
        print(decodedStock.date)
        //decodedStock = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! Stock
        purchasePrice = decodedStock.totalPrice
        amount = decodedStock.amount
        purchaseDate = decodedStock.date
        if amount != 0 {
            pricePerShare = purchasePrice / amount
        } else {
            pricePerShare = purchasePrice
        }
        
        // download current Price to compare to purchase Price
        downloadPrice(stockname: decodedStock.symbol)
    }
    
    func downloadPrice(stockname: String) {
        
        self.activityIndicator.startAnimating()
        //let urlString = "https://query1.finance.yahoo.com/v7/finance/quote?symbols=aapl"
        let urlString = token.testURL(symbol: stockname, info: "/quote")
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
                        if let companyNameString = dictionary["companyName"] as? String {
                            self.companyName = companyNameString
                        }
                        if let currentPrice = dictionary["latestPrice"] as? Double {
                            self.curPrice = currentPrice
                        }
                    }
                    self.updateLabels()
                } catch {
                    print("The error is:")
                    print(error)
                }
            }
        }.resume()
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
        return
    }
    
    func updateLabels() {
        
        DispatchQueue.main.async {
            self.change = self.calculation.changeInPercentage(purchasePrice: self.pricePerShare, currentPrice: self.curPrice)
            let index = self.change.index(self.change.startIndex, offsetBy: 1)
            let currentStockPriceFirst = String(self.change.prefix(upTo: index))
            print("CurrentStock: " + "\(currentStockPriceFirst)")
            if (currentStockPriceFirst == "-") {
                self.changeLabel.textColor = UIColor.red
                self.changeLabel.text = self.change
            } else if (currentStockPriceFirst == "+") {
                self.changeLabel.textColor = UIColor.green
                self.changeLabel.text = self.change
            } else {
                self.changeLabel.text = self.change
            }
            self.tableView.reloadData()
        }
        
    }
    
}
