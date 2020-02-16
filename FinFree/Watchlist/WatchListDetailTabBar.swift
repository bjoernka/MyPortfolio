//
//  WatchListDetailTabBar.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 5/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class WatchListDetailTabBar: UITabBarController {

    var selectedStock = String()
    var stockFile = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Selected: " + selectedStock)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Selected: " + selectedStock)
        let watchList1 = WatchListDetail1()
        let watchList1BarItem = UITabBarItem(title: "Info", image: UIImage(named: "BookIcon"), selectedImage: UIImage(named: "BookIcon"))
        watchList1.tabBarItem = watchList1BarItem
        watchList1.selectedStock = selectedStock
        let watchList2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "watchListDetail2") as? WatchListDetail2
        watchList2!.stock = selectedStock
        //        watchList2!.view.backgroundColor = UIColor.red
        let watchList2BarItem = UITabBarItem(title: "Graph", image: UIImage(named: "HistoricGraphIcon"), selectedImage: UIImage(named: "HistoricGraphIcon"))
        watchList2!.tabBarItem = watchList2BarItem
        watchList2!.selectedStock = selectedStock
        let watchList3 = WatchListDetail3()
        let watchList3BarItem = UITabBarItem(title: "Change", image: UIImage(named: "Dollar"), selectedImage: UIImage(named: "Dollar"))
        watchList3.tabBarItem = watchList3BarItem
        watchList3.selectedStockFile = stockFile
        watchList3.selectedStock = selectedStock
        let tabBarlist = [watchList3, watchList1,watchList2!]
        viewControllers = tabBarlist
    }
}
