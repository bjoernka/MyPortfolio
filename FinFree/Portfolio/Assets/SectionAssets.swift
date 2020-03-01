//
//  SectionAssets.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 16/5/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit
import Charts

class SectionAssets: UIViewController {
    
    var stockNameArray : [String]? = nil
    var chartDataEntries : [PieChartDataEntry] = []
    let defaults = UserDefaults.standard
    var totalPrices: [Double] = []
    var sectorNames: [String] = []
    var namesAndPrices: [String: Double] = [:]
    var helperFunc = HelpFunctions()
    var pieChartView = PieChartView()
    var allStocks: [StockObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
        
        getStocks()
        
        setupPieCharts()
    }
    
    func setupView(){
        
        self.view.backgroundColor = .white
        self.view.addSubview(pieChartView)
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        pieChartView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        pieChartView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        pieChartView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func getStocks() {
        totalPrices = []
        sectorNames = []
        
        if allStocks != nil {
            for stocks in allStocks {
                totalPrices.append(stocks.totalPrice)
                sectorNames.append(stocks.sector)
            }
        }
    }
    
    func setupPieCharts() {
        chartDataEntries = []
        
        namesAndPrices = helperFunc.turnArraysIntoDictionaries(stringArray: sectorNames, doubleArray: totalPrices)
        
        for secName in namesAndPrices.keys {
            let dataEntry = PieChartDataEntry()
            dataEntry.value = namesAndPrices[secName]!
            dataEntry.label = secName
            chartDataEntries.append(dataEntry)
        }
        
        print(chartDataEntries)
        
        let chartDataSet = PieChartDataSet(entries: chartDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(red: 51/255, green: 181/255, blue: 299/255, alpha: 1),
                      UIColor(red: 299/255, green: 181/255, blue: 51/255, alpha: 1),
                      UIColor(red: 181/255, green: 51/255, blue: 299/255, alpha: 1)]
        chartDataSet.colors = colors as [NSUIColor]
        
        pieChartView.data = chartData
        
        pieChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
        
        pieChartView.centerText = "Allocation by Sector"
        
    }
    
}
