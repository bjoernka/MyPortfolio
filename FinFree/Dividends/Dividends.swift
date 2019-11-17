//
//  Dividends.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 1/3/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class Dividends: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = DividendsDetail1()
        let vc1BarItem = UITabBarItem(title: "Per Month", image: UIImage(named: "MonthDividends"), selectedImage: UIImage(named: "MonthDividends"))
        vc1.tabBarItem = vc1BarItem
        let vc2 = DividendsDetail2()
        vc2.view.backgroundColor = UIColor.white
        let vc2BarItem = UITabBarItem(title: "Per Company", image: UIImage(named: "StockAssetsIcon"), selectedImage: UIImage(named: "StockAssetsIcon"))
        vc2.tabBarItem = vc2BarItem
        let vc3 = DividendsDetail3()
        vc3.view.backgroundColor = UIColor.white
        let vc3BarItem = UITabBarItem(title: "All Entries", image: UIImage(named: "AllEntries"), selectedImage: UIImage(named: "AllEntries"))
        vc3.tabBarItem = vc3BarItem
        let tabBarlist = [vc1,vc2,vc3]
        viewControllers = tabBarlist

        // Do any additional setup after loading the view.
    }
}
