//
//  Assets.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 16/5/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class Assets: UITabBarController {
    
    public var allStocks: [StockObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(allStocks)
        
        self.navigationItem.title = "Asset Allocation"
        
        let stockAssetsVC = StockAssets()
        stockAssetsVC.allStocks = []
        stockAssetsVC.allStocks = allStocks
        let stockAssetsBarItem = UITabBarItem(title: "Stocks", image: UIImage(named: "StockAssetsIcon"), selectedImage: UIImage(named: "StockAssetsIcon"))
        stockAssetsVC.tabBarItem = stockAssetsBarItem
        
        let sectionAssetsVC = SectionAssets()
        sectionAssetsVC.allStocks = []
        sectionAssetsVC.allStocks = allStocks
        let sectionAssetsBarItem = UITabBarItem(title: "Sectors", image: UIImage(named: "StockAssetsIcon"), selectedImage: UIImage(named: "StockAssetsIcon"))
        sectionAssetsVC.tabBarItem = sectionAssetsBarItem
        
        let tabBarlist = [stockAssetsVC,sectionAssetsVC]
        viewControllers = tabBarlist
    }

}
