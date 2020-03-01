//
//  Dividends.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 1/3/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class Dividends: UITabBarController {

    var allDividends: [Dividend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let vc1 = DividendsDetail1()
        vc1.allDividends = []
        vc1.allDividends = allDividends
        let vc1BarItem = UITabBarItem(title: "Per Month", image: UIImage(named: "MonthDividends"), selectedImage: UIImage(named: "MonthDividends"))
        vc1.tabBarItem = vc1BarItem
        let vc2 = DividendsDetail2()
        vc2.allDividends = []
        vc2.allDividends = allDividends
        vc2.view.backgroundColor = UIColor.white
        let vc2BarItem = UITabBarItem(title: "Per Company", image: UIImage(named: "StockAssetsIcon"), selectedImage: UIImage(named: "StockAssetsIcon"))
        vc2.tabBarItem = vc2BarItem
        let vc3 = DividendsDetail3()
        vc3.allDividends = []
        vc3.allDividends = allDividends
        vc3.view.backgroundColor = UIColor.white
        let vc3BarItem = UITabBarItem(title: "All Entries", image: UIImage(named: "AllEntries"), selectedImage: UIImage(named: "AllEntries"))
        vc3.tabBarItem = vc3BarItem
        let tabBarlist = [vc1,vc2,vc3]
        viewControllers = tabBarlist
        
    }
}
