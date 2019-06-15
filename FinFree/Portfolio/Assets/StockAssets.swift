//
//  Assets.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 1/3/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit
import Charts

class StockAssets: UIViewController {
    
    var stockNameArray : [String]? = nil
    var chartDataEntries : [PieChartDataEntry] = []
    let defaults = UserDefaults.standard
    var totalPrices: [Double] = []
    var companyNames: [String] = []
    var namesAndPrices: [String: Double] = [:]
    var helperFunc = HelpFunctions()
    var pieChartView = PieChartView()
//
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
                    companyNames.append(decodedStock.companyName)
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
        print(chartDataEntries)
        
        let chartDataSet = PieChartDataSet(entries: chartDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
//        chartDataSet.colors = ChartColorTemplates.vordiplom()
//            + ChartColorTemplates.joyful()
//            + ChartColorTemplates.colorful()
//            + ChartColorTemplates.liberty()
//            + ChartColorTemplates.pastel()
//            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        let colors = [UIColor(red: 51/255, green: 181/255, blue: 299/255, alpha: 1),
                      UIColor(red: 299/255, green: 181/255, blue: 51/255, alpha: 1),
                    UIColor(red: 181/255, green: 51/255, blue: 299/255, alpha: 1)]
        chartDataSet.colors = colors as [NSUIColor]
        
        pieChartView.data = chartData
        
        //pieChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
        
        pieChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
        
        pieChartView.centerText = "Allocation by Company"
    }
    
    func setupView(){
        
        self.title = "Allocation"
        self.view.backgroundColor = .white
        self.view.addSubview(pieChartView)
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        pieChartView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        pieChartView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        pieChartView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        pieChartView.backgroundColor = .lightGray
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
