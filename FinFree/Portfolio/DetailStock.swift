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
    var stockObject: StockObject? = nil
    var amount = 0.0
    var curPrice = 0.0
    var change = "0.0%"
    var purchaseDate = Date()
    var changeLabel = UILabel()
    var calculation = Calculation()
    var token = Token()
    var helpFunc = HelpFunctions()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         activityIndicator.center = self.view.center
         activityIndicator.color = UIColor.green
         self.view.addSubview(activityIndicator)
          downloadPrice(stockname: stockObject!.symbol)
         self.tableView.reloadData()
     }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if stockObject != nil {
            return criterias.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
        if stockObject != nil {
            cell.leftLabel.text = criterias[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.rightLabel.text = stockObject?.companyName
            case 1:
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let purchaseDateString = formatter.string(from: stockObject!.date)
                cell.rightLabel.text = purchaseDateString
            case 2:
                cell.rightLabel.text = "\(stockObject!.price)"
            case 3:
                if stockObject?.amount != 0 {
                    curPrice = curPrice * stockObject!.amount
                    cell.rightLabel.text = "\(curPrice)"
                } else {
                    cell.rightLabel.text = "\(curPrice)"
                }
            default:
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
        } else {
            cell.leftLabel.text = "No values saved"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func downloadPrice(stockname: String) {
        
        self.activityIndicator.startAnimating()
        //let urlString = "https://query1.finance.yahoo.com/v7/finance/quote?symbols=aapl"
        let urlString = token.testURL(symbol: stockObject!.symbol, info: "/quote")
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
            self.change = self.calculation.changeInPercentage(purchasePrice: self.stockObject!.totalPrice, currentPrice: self.curPrice)
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
