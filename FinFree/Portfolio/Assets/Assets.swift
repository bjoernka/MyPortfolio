//
//  Assets.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 16/5/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class Assets: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Asset Allocation"
        
        let stockAssetsVC = StockAssets()
        let stockAssetsBarItem = UITabBarItem(title: "Stocks", image: UIImage(named: "StockAssetsIcon"), selectedImage: UIImage(named: "StockAssetsIcon"))
        stockAssetsVC.tabBarItem = stockAssetsBarItem
        
        let sectionAssetsVC = SectionAssets()
        let sectionAssetsBarItem = UITabBarItem(title: "Sectors", image: UIImage(named: "StockAssetsIcon"), selectedImage: UIImage(named: "StockAssetsIcon"))
        sectionAssetsVC.tabBarItem = sectionAssetsBarItem
        
        let tabBarlist = [stockAssetsVC,sectionAssetsVC]
        viewControllers = tabBarlist
    }

}
