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
    
    
//    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        stockNameArray = defaults.stringArray(forKey: "portfolioValuesNames")
        if stockNameArray != nil {
            for stock in stockNameArray! {
                let decoded  = defaults.data(forKey: stock)
                if decoded != nil {
                    let decodedStock = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! Stock
                    totalPrices.append(decodedStock.totalPrice)
                    sectorNames.append(decodedStock.sector)
                }
            }
        }
        
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
        
        let colors = [UIColor.magenta,
                      UIColor.cyan,
                      UIColor.gray]
        chartDataSet.colors = colors as [NSUIColor]
        
        pieChartView.data = chartData
        
//        pieChartView.backgroundColor = UIColor.red
        
        // Do any additional setup after loading the view.
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

}
