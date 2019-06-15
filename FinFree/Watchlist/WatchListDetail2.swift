//
//  WatchListDetail2.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 5/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit
import Charts

class WatchListDetail2: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var ThreeMButton: UIButton!
    @IBOutlet weak var OneYButton: UIButton!
    @IBOutlet weak var maxButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var stock: String = ""
    var datesAsString: [String] = []
    var closesAsStrings: [String] = []
    var datesArray: [Date] = []
    var dataEntries: [ChartDataEntry] = []
    var lineChart = LineChartView()
    var token = Token()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        ThreeMButton.addTarget(self, action: #selector(self.onAdd(_:)), for: .touchUpInside)
        OneYButton.addTarget(self, action: #selector(self.onAdd(_:)), for: .touchUpInside)
        maxButton.addTarget(self, action: #selector(self.onAdd(_:)), for: .touchUpInside)
        
        view.backgroundColor = UIColor.white
        
    }
    
    @objc func onAdd(_ sender : AnyObject?) {
        
        if let senderButton = sender as? UIButton {
            
            if senderButton.titleLabel?.text == "3M" {
                
                getJsonData(timeInterval: "3m")
                
            } else if senderButton.titleLabel?.text == "1Y" {
                
                getJsonData(timeInterval: "1y")
                
            } else {
                
                getJsonData(timeInterval: "5y")
            }
        }
        
    }
    
    func getJsonData(timeInterval time: String) {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        datesAsString = []
        closesAsStrings = []
        datesArray = []
        dataEntries = []
        
        let urlString = token.testURL(symbol: "aapl", info: "/chart/" + time)
        
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
                    let dictionaryAlt = json as! [[String:Any]]
                    for dictionary in dictionaryAlt {
                        print(dictionary)
                        if let latestDate = dictionary["date"] as? String {
                            print("It works")
                            print("Headline is: " + "\(latestDate)")
                            self.datesAsString.append(latestDate)
                        }
                        if let latestHeadline2 = dictionary["close"]! as? String {
                            print("It works again!")
                            print("Source is: " + "\(latestHeadline2)")
                            self.closesAsStrings.append(latestHeadline2)
                        } else {
                            print("Close is: " + "\(dictionary["close"]!)")
                            self.closesAsStrings.append("\(dictionary["close"]!)")
                        }
                    }
                    
                    self.convertStringToDate(dates: self.datesAsString)
                } catch {
                    print("The error is:")
                    print(error)
                }
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            }.resume()
        
    }
    
    func convertStringToDate(dates: [String]) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var miniDate: Double = 0.0
        for i in 0..<dates.count {
            
            let myDateMidnightLocalTime = dateFormatter.date(from: dates[i])!
            let timeInSeconds = myDateMidnightLocalTime.timeIntervalSince1970
            if i == 0
            {
                miniDate = timeInSeconds
            }
            let closesAsDouble = Double(closesAsStrings[i])
            let dataEntry = ChartDataEntry(x: (timeInSeconds - miniDate) / (3600.0 * 24.0), y: closesAsDouble!)
            print(dataEntry)
            dataEntries.append(dataEntry)
            
        }
        
        let data = LineChartData()
        let ds1 = LineChartDataSet(entries: dataEntries, label: "Hello")
        data.addDataSet(ds1)
        print(data)
        
        lineChartView.data = data
    }
}
