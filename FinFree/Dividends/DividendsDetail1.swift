//
//  DividendsDetail1.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 11/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit
import Charts

class DividendsDetail1: UIViewController {
    
    let barCharView = BarChartView()
    var barCharEntries: [BarChartDataEntry] = []
    var dividendNameArray: [String]? = []
    let userDefaults = UserDefaults.standard
    var allDividends: [Dividend] = []
    var allMonths = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12",]
    var allYears = ["2016", "2017", "2018", "2019", "2020", "2021", "2022",]
    var allDivDates: [String] = []
    var allDivNames: [String] = []
    var allDivValues: [Double] = []
    var DatesAndValues: [String: Double] = [:]
    var keysAsArray: [String] = []
    var counter = 0
    var helperFunc = HelpFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
    }
    
    func setupView(){
        
        self.view.addSubview(barCharView)
        barCharView.translatesAutoresizingMaskIntoConstraints = false
        barCharView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        barCharView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        barCharView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        barCharView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func setupChart() {
        
        
        dividendNameArray = userDefaults.stringArray(forKey: "dividendArrayNew")
        if dividendNameArray != nil {
            createEntries(divArry: dividendNameArray!)
//            for dividendName in dividendNameArray! {
//                let decoded  = userDefaults.data(forKey: dividendName)
//                if decoded != nil {
//                    let decodedDividend = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! Dividend
//                    let barCharEntry = BarChartDataEntry(x: decodedDividend.fees, y: decodedDividend.totalPrice)
//                    barCharEntries.append(barCharEntry)
//                    let barCharData = BarChartData()
//                    let barCharSet = BarChartDataSet(entries: barCharEntries, label: "Test")
//                    barCharData.addDataSet(barCharSet)
//                    barCharView.data = barCharData
//                }
//            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onAdd(_:)))
        setupView()
        setupChart()
    }
    
    @objc func onAdd(_ sender : AnyObject?) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        
        let vc = AddDividend()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func createEntries(divArry: [String]) {
        
        allDivDates = []
        allDivNames = []
        allDivValues = []
        DatesAndValues = [:]
        keysAsArray = []
        counter = 0
        
        for divName in divArry {
            let decoded  = userDefaults.data(forKey: divName)
            if decoded != nil {
                let decodedDividend = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! Dividend
                allDividends.append(decodedDividend)
            }
        }
        
        for oneDividend in allDividends {
            let calendar = NSCalendar.current
            let month = calendar.component(.month, from: oneDividend.date)
            let year = calendar.component(.year, from: oneDividend.date)
            allDivDates.append("\(year)" + "-" + "\(month)" + "-" + "01")
            allDivNames.append(oneDividend.companyName)
            allDivValues.append(oneDividend.totalPrice)
        }
 
        DatesAndValues = helperFunc.turnArraysIntoDictionaries(stringArray: allDivDates, doubleArray: allDivValues)
        
        print(DatesAndValues)
        
        print(allDivDates)
        print(allDivNames)
        print(allDivValues)
        
        let keys = DatesAndValues.keys
        for key in keys {
            keysAsArray.append(key)
        }
        
        print(keys)
        
        let xaxis = barCharView.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values: keysAsArray)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1

        
        barCharView.rightAxis.enabled = false
        //axisFormatDelegate = self

        
        for key in keys {
            counter += 1
            
            let barCharEntry = BarChartDataEntry(x: Double(counter), y: DatesAndValues[key]!)
            barCharEntries.append(barCharEntry)
        }
        
        let barCharData = BarChartData()
        let barCharSet = BarChartDataSet(entries: barCharEntries, label: "Test")
        barCharData.addDataSet(barCharSet)
        barCharView.data = barCharData
        
    }

}
