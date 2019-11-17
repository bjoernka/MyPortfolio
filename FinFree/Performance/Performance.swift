//
//  Performance.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 1/3/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class Performance: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = PerformanceChart()
        let vc1BarItem = UITabBarItem(title: "Per Month", image: UIImage(named: "MonthDividends"), selectedImage: UIImage(named: "MonthDividends"))
        vc1.tabBarItem = vc1BarItem
        let vc2 = PerformanceDetail()
        let vc2BarItem = UITabBarItem(title: "Per Company", image: UIImage(named: "StockAssetsIcon"), selectedImage: UIImage(named: "StockAssetsIcon"))
        vc2.tabBarItem = vc2BarItem
        let tabBarlist = [vc1,vc2]
        viewControllers = tabBarlist
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
