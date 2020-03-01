//
//  ViewController.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 24/11/18.
//  Copyright © 2018 Björn Kaczmarek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    
    
    let db = Firestore.firestore()
    var allUser: [UserObject] = []
    var allStocks : [StockObject] = []
    var allDividends : [Dividend] = []
    var allWatchListItems : [WatchListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        preparations()
    
        // Make navigationbar transparent and add title
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationItem.title = "Portfolio"
        
        downloadUsersFromFirebase()
        downloadStocksFromFirebase()
        downloadDividendsFromFirebase()
        downloadWatchListItemsFromFirebase()
    }
    
    func downloadUsersFromFirebase() {
        
        allUser = []
            
            db.collection("users").getDocuments()
            {
                (querySnapshot,err) in
                if let err = err
                {
                    print("Error getting documents: \(err)");
                }
                else
                {
                    for document in querySnapshot!.documents {
                        let documentArray = document.data()
                        let userObject = UserObject(uid: documentArray["uid"] as! String,
                                                    username: documentArray["username"] as! String)
                        self.allUser.append(userObject)
                    }
                    self.downloadStocksFromFirebase()
                }
            }
    }
    
    func downloadStocksFromFirebase() {
        
        allStocks = []
        
        db.collection("stocks").getDocuments()
        {
            (querySnapshot,err) in
            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
                for document in querySnapshot!.documents {
                    let documentArray = document.data()
                    let userObject = StockObject(symbol: documentArray["symbol"] as! String,
                                                 companyName: documentArray["companyName"] as! String,
                                                 sector: documentArray["sector"] as! String,
                                                 amount: documentArray["amount"] as! Double,
                                                 price: documentArray["price"] as! Double,
                                                 fees: documentArray["fees"] as! Double,
                                                 taxes: documentArray["taxes"] as! Double,
                                                 date: (documentArray["date"] as! Timestamp).dateValue(),
                                                 totalPrice: documentArray["totalPrice"] as! Double,
                                                 uid: documentArray["uid"] as! String)
                    self.allStocks.append(userObject)
                }
            }
        }
    }
    
    func downloadDividendsFromFirebase() {
        allDividends = []
        
        db.collection("dividends").getDocuments()
        {
            (querySnapshot,err) in
            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
                for document in querySnapshot!.documents {
                    let documentArray = document.data()
                    let dividendObject = Dividend(companyName: documentArray["companyName"] as! String,
                                                 dividend: documentArray["dividend"] as! Double,
                                                 fees: documentArray["fees"] as! Double,
                                                 taxes: documentArray["taxes"] as! Double,
                                                 date: (documentArray["date"] as! Timestamp).dateValue(),
                                                 totalPrice: documentArray["totalPrice"] as! Double,
                                                 uid: documentArray["uid"] as! String)
                    self.allDividends.append(dividendObject)
                }
            }
        }
        
    }
    
    func downloadWatchListItemsFromFirebase() {
        
        allWatchListItems = []
        
        db.collection("watchListItems").getDocuments()
        {
            (querySnapshot,err) in
            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
                for document in querySnapshot!.documents {
                    let documentArray = document.data()
                    let watchListObject = WatchListItem(companyName: documentArray["companyName"] as! String,
                                                   symbol: documentArray["symbol"] as! String,
                                                   savedPrice: documentArray["savedPrice"] as! Double,
                                                   currentPrice: documentArray["currentPrice"] as! Double,
                                                   date: (documentArray["date"] as! Timestamp).dateValue(),
                                                   desiredPrice: documentArray["desiredPrice"] as! Double,
                                                   uid: documentArray["uid"] as! String)
                    self.allWatchListItems.append(watchListObject)
                }
            }
        }
        
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
    
    @IBAction func portfolioClicked(_ sender: UIButton) {
        let portfolioVC = Portfolio()
        portfolioVC.allStocks = []
        portfolioVC.allStocks = allStocks
        print(allStocks)
        self.navigationController?.pushViewController(portfolioVC, animated: true)
    }
    
    @IBAction func assetsClicked(_ sender: UIButton) {
        let assetsVC = Assets()
        //(assetsVC.viewControllers?.first as? StockAssets)?.allStocks = allStocks
        assetsVC.allStocks = []
        assetsVC.allStocks = allStocks
        self.navigationController?.pushViewController(assetsVC, animated: true)
    }
    
    @IBAction func performanceClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(Performance(), animated: true)
    }
    
    @IBAction func dividendsClicked(_ sender: UIButton) {
        let dividendsVC = Dividends()
        dividendsVC.allDividends = []
        dividendsVC.allDividends = allDividends
        self.navigationController?.pushViewController(dividendsVC, animated: true)
    }
    
    @IBAction func newsClicked(_ sender: UIButton) {
        let watchListVC = WatchList()
        watchListVC.allWatchListItems = []
        watchListVC.allWatchListItems = allWatchListItems
        self.navigationController?.pushViewController(watchListVC, animated: true)
    }
    
    @IBAction func settingsClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(News(), animated: true)
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(AddValue(), animated: true)
    }
    @IBAction func logoutButtonClicked(_ sender: UIBarButtonItem) {
        let startVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StartNavVC") as? StartNavController
               
        view.window?.rootViewController = startVC
        view.window?.makeKeyAndVisible()
    }
    
}
