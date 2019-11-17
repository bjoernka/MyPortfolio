//
//  PerformanceChart.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 24/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit
import Charts

class PerformanceChart: UIViewController {
    
    var datesSincePurchase: [String] = []
    var pricesSincePurchase: [Double] = []
    var priceAndDates: [[String: Double]] = []
    var token = Token()
    var defaults = UserDefaults.standard
    var stockNameArray : [String]? = nil
    var helpFunc = HelpFunctions()
    var stockArray: [Stock] = []
    var calc = Calculation()
    var lineChart = LineChartView()
    var dataEntries: [ChartDataEntry] = []
    var datesForLineChart: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setUpView()
        
        getPriceForStock(stockName: "aapl", time: "5y")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        stockNameArray = defaults.stringArray(forKey: "portfolioValuesNames1")
        if stockNameArray == nil {
            stockNameArray = ["No saved values."]
        }
        
        for name in stockNameArray! {
            let decoded  = defaults.data(forKey: name)
            if decoded != nil {
                let decodedStock = helpFunc.decodeStockObject(fromData: decoded!)
                //let decodedDividend = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! Dividend
                stockArray.append(decodedStock!)
            }
        }
        
    }
    
    func setUpView(){
        
        self.view.addSubview(lineChart)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        lineChart.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        lineChart.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        lineChart.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func getPriceForStock(stockName: String, time: String){
        
        datesSincePurchase = []
        pricesSincePurchase = []
        
        let urlString = token.testURL(symbol: stockName, info: "/chart/" + time)
        
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
                            self.datesSincePurchase.append(latestDate)
                        }
                        if let latestPrice = dictionary["close"]! as? Double {
                            print("It works again!")
                            self.pricesSincePurchase.append(latestPrice)
                        } else {
                            print("Close is: " + "\(dictionary["close"]!)")
                        }
                    }
                    self.calculateChanges(dates: self.datesSincePurchase, prices: self.pricesSincePurchase)
                } catch {
                    print("The error is:")
                    print(error)
                }
            }
            }.resume()
    }
    
    func calculateChanges(dates: [String], prices: [Double]) {
    
        print(dates.count)
        print(prices.count)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        priceAndDates = []
        
        for stock in stockArray {
            let purchaseDate = stock.date
            let purchaseDateString = dateFormatter.string(from: purchaseDate)
            print(purchaseDateString)
            for date in dates {
                if date == purchaseDateString {
                    print("YEEEEEES!")
                    let index = dates.firstIndex(of: purchaseDateString)
                    let newArray = Array(index!...dates.endIndex)
                    for index in newArray {
                        let purchasePrice = stock.totalPrice / stock.amount
                        let currentPrice = prices[(index-1)]
                        let change = calc.changeInPercentageAsDouble(purchasePrice: purchasePrice, currentPrice: currentPrice)
                        let dictionary = [dates[index-1]: change]
                        self.priceAndDates.append(dictionary)
                        print(change)
                    }
                    print(newArray)
                }
            }
        }
        
        print(priceAndDates)
        datesForLineChart = []
        
        var miniDate: Double = 0.0
        for i in 0..<priceAndDates.count {
            
            let dict = priceAndDates[i]
            let date = Array(dict.keys)[0]
            let price = Array(dict.values)[0]
            datesForLineChart.append(date)
            let myDateMidnightLocalTime = dateFormatter.date(from: date)!
            let timeInSeconds = myDateMidnightLocalTime.timeIntervalSince1970
            if i == 0
            {
                miniDate = timeInSeconds
            }
            let closesAsDouble = Double(price)
            let dataEntry = ChartDataEntry(x: (timeInSeconds - miniDate) / (3600.0 * 24.0), y: closesAsDouble)
            print(dataEntry)
            dataEntries.append(dataEntry)
            
        }
        
        let xaxis = lineChart.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values: datesForLineChart)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        
        lineChart.rightAxis.enabled = false
       
        
        let data = LineChartData()
        let ds1 = LineChartDataSet(entries: dataEntries, label: "Hello")
        data.addDataSet(ds1)
        print(data)
        
        lineChart.data = data
    }
    
}
