//
//  ViewController.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 24/11/18.
//  Copyright © 2018 Björn Kaczmarek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var portfolioButton: UIButton!
    @IBOutlet weak var portfolioLabel: UILabel!
    
    @IBOutlet weak var assetButton: UIButton!
    @IBOutlet weak var assetLabel: UILabel!
    
    @IBOutlet weak var performanceButton: UIButton!
    @IBOutlet weak var performanceLabel: UILabel!
    
    @IBOutlet weak var dividendsButton: UIButton!
    @IBOutlet weak var dividendsLabel: UILabel!
    
    @IBOutlet weak var watchListButton: UIButton!
    @IBOutlet weak var watchListLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        preparations()
        
    }   
        
    // Set text on Labels
    func preparations() {
        
        portfolioLabel.text = "Portfolio"
        
        assetLabel.text = "Asset Allocation"
        
        performanceLabel.text = "Portfolio Performance"
    
        dividendsLabel.text = "Dividends"

        watchListLabel.text = "Watchlist"

        settingsLabel.text = "News"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Make navigationbar transparent and add title
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationItem.title = "Portfolio"
    }
    
    @IBAction func portfolioClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(Portfolio(), animated: true)
    }
    
    @IBAction func assetsClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(Assets(), animated: true)
    }
    
    @IBAction func performanceClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(Performance(), animated: true)
    }
    
    @IBAction func dividendsClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(Dividends(), animated: true)
    }
    
    @IBAction func newsClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(WatchList(), animated: true)
    }
    
    @IBAction func settingsClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(News(), animated: true)
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(AddValue(), animated: true)
    }
    
}
