//
//  WatchListDetail1.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 10/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class WatchListDetail1: UITableViewController {
    
    let criterias = ["companyName", "symbol", "marketcap", "dividendRate", "dividendYield", "exDividendDate", "week52high", "week52low"]
    var criteriaValues: [String] = []
    let calculation = Calculation()
    var token = Token()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        getJsonData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if criteriaValues.count == 0 {
            return 1
        } else {
            return criteriaValues.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Updated")
        
        let watchListCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
        
        
        if criteriaValues.count == 0 {
            watchListCell.leftLabel.text = "No data found."
        } else {
            watchListCell.leftLabel.text = criterias[indexPath.row].capitalized + ": "
            watchListCell.leftLabel.font = .boldSystemFont(ofSize: 16)
            let labeltext = calculation.formatPoints(num: criteriaValues[indexPath.row])
            watchListCell.rightLabel.text = labeltext
            watchListCell.rightLabel.numberOfLines = 0
        }
        
        return watchListCell
    }
    
    func getJsonData() {
        
        let urlString = token.testURL(symbol: "aapl", info: "/stats")
        //let urlString = "https://api.iextrading.com/1.0/stock/aapl/stats/"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Json ist:")
                    print(json)
                    let dictionary = json as! [String:Any]
                    print(dictionary)
                    for criteria in self.criterias {
                        if let value = dictionary[criteria] as? Any {
                            let valueAsString = "\(value)"
                            let valueAsStringRe = valueAsString.replacingOccurrences(of: "Optional(", with: "")
                            let valueFinal = valueAsStringRe.replacingOccurrences(of: ")", with: "")
                            self.criteriaValues.append(valueFinal)
                        } else {
                            print(criteria)
                        }
                    }
                    self.tableView.reloadData()
                } catch {
                    print("The error is:")
                    print(error)
                }
            }
            }.resume()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height / 9
    }

}
