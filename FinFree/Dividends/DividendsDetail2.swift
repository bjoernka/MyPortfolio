//
//  DividendsDetail2.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 11/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit
import Charts

class DividendsDetail2: UIViewController {
    
    var stockNameArray : [String]? = nil
    var chartDataEntries : [PieChartDataEntry] = []
    let userDefaults = UserDefaults.standard
    var dividendNameArray: [String]? = []
    var pieChartView =  PieChartView()
    var totalPrices: [Double] = []
    var companyNames: [String] = []
    var namesAndPrices: [String: Double] = [:]
    var helperFunc = HelpFunctions()
    var allDividends: [Dividend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chartDataEntries = []
        setupChart()
    }
    
    func setupChart() {
        
        totalPrices = []
        companyNames = []
        
        dividendNameArray = userDefaults.stringArray(forKey: "dividendArrayNew")
        if dividendNameArray != nil {
            for divName in dividendNameArray! {
                let decoded  = userDefaults.data(forKey: divName)
                if decoded != nil {
                    let decodedDividend = helperFunc.decodeDividendObject(fromData: decoded!)
                    //let decodedDividend = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! Dividend
                    totalPrices.append(decodedDividend!.totalPrice)
                    companyNames.append(decodedDividend!.companyName)
                }
            }
        }
        
        namesAndPrices = helperFunc.turnArraysIntoDictionaries(stringArray: companyNames, doubleArray: totalPrices)
        
        for comName in namesAndPrices.keys {
            let dataEntry = PieChartDataEntry()
            dataEntry.value = namesAndPrices[comName]!
            dataEntry.label = comName
            chartDataEntries.append(dataEntry)
        }
        
        
        let chartDataSet = PieChartDataSet(entries: chartDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.magenta,
                      UIColor.cyan,
                      UIColor.gray]
        chartDataSet.colors = colors as [NSUIColor]
        
        pieChartView.data = chartData
        
        setupView()
        
    }
    
    func setupView(){
        self.view.addSubview(pieChartView)
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        pieChartView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        pieChartView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        pieChartView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}
