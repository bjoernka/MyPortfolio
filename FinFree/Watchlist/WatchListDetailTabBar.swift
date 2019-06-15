//
//  WatchListDetailTabBar.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 5/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class WatchListDetailTabBar: UITabBarController {

    var selectedStock: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let watchList1 = WatchListDetail1()
        watchList1.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
        let watchList2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "watchListDetail2") as? WatchListDetail2
        watchList2!.stock = selectedStock
//        watchList2!.view.backgroundColor = UIColor.red
        watchList2!.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let tabBarlist = [watchList1,watchList2!]
        viewControllers = tabBarlist
        // Do any additional setup after loading the view.
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
