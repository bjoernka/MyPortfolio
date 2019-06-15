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
        
        let stockAssetsVC = StockAssets()
        stockAssetsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
        stockAssetsVC.title = "Allocation"
        let sectionAssetsVC = SectionAssets()
        //        watchList2!.view.backgroundColor = UIColor.red
        sectionAssetsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        sectionAssetsVC.title = "Allocation"
        let tabBarlist = [stockAssetsVC,sectionAssetsVC]
        viewControllers = tabBarlist
        // Do any additional setup after loading the view.
    }

}
