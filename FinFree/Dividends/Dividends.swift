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
        vc1.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
        let vc2 = DividendsDetail2()
        vc2.view.backgroundColor = UIColor.white
        vc2.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let vc3 = DividendsDetail3()
        vc3.view.backgroundColor = UIColor.white
        vc3.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        let tabBarlist = [vc1,vc2,vc3]
        viewControllers = tabBarlist

        // Do any additional setup after loading the view.
    }
}
