//
//  WatchListItem.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 13/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import Foundation

class WatchListItem: NSObject, NSCoding {
    
    var companyName: String = ""
    var symbol: String = ""
    var savedPrice: Double = 0
    var currentPrice: Double = 0
    var date: Date = Date()
    var desiredPrice: Double = 0
    
    init(companyName: String, symbol: String, savedPrice: Double, currentPrice: Double, date: Date, desiredPrice: Double) {
        self.companyName = companyName
        self.symbol = symbol
        self.savedPrice = savedPrice
        self.currentPrice = currentPrice
        self.date = date
        self.desiredPrice = desiredPrice
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let companyName = aDecoder.decodeObject(forKey: "companyName") as! String
        let symbol = aDecoder.decodeObject(forKey: "symbol") as! String
        let savedPrice = aDecoder.decodeDouble(forKey: "savedPrice")
        let currentPrice = aDecoder.decodeDouble(forKey: "currentPrice")
        let date = aDecoder.decodeObject(forKey: "date") as! Date
        let desiredPrice = aDecoder.decodeDouble(forKey: "desiredPrice")
        self.init(companyName: companyName, symbol: symbol, savedPrice: savedPrice, currentPrice: currentPrice, date: date, desiredPrice: desiredPrice)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(companyName, forKey: "companyName")
        aCoder.encode(symbol, forKey: "symbol")
        aCoder.encode(savedPrice, forKey: "savedPrice")
        aCoder.encode(currentPrice, forKey: "currentPrice")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(desiredPrice, forKey: "desiredPrice")
        
    }
    
    
}
