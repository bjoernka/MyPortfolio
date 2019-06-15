//
//  Stock.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 4/5/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import Foundation

class Stock: NSObject, NSCoding {
    
    var symbol: String = ""
    var companyName: String = ""
    var sector: String = ""
    var amount: Double = 0
    var price: Double = 0
    var fees: Double = 0
    var taxes: Double = 0
    var date: Date = Date()
    var totalPrice: Double = 0
    
    init(symbol: String, companyName: String, sector: String, amount: Double, price: Double, fees: Double, taxes: Double, date: Date, totalPrice: Double) {
        self.symbol = symbol
        self.companyName = companyName
        self.sector = sector
        self.amount = amount
        self.price = price
        self.fees = fees
        self.taxes = taxes
        self.date = date
        self.totalPrice = totalPrice
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let symbol = aDecoder.decodeObject(forKey: "symbol") as! String
        let companyName = aDecoder.decodeObject(forKey: "companyName") as! String
        let sector = aDecoder.decodeObject(forKey: "sector") as! String
        let amount = aDecoder.decodeDouble(forKey: "amount")
        let price = aDecoder.decodeDouble(forKey: "price")
        let fees = aDecoder.decodeDouble(forKey: "fees")
        let taxes = aDecoder.decodeDouble(forKey: "taxes")
        let date = aDecoder.decodeObject(forKey: "date") as! Date
        let totalPrice = aDecoder.decodeDouble(forKey: "totalPrice")
        self.init(symbol: symbol, companyName: companyName, sector: sector, amount: amount, price: price, fees: fees, taxes: taxes, date: date, totalPrice: totalPrice)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(symbol, forKey: "symbol")
        aCoder.encode(companyName, forKey: "companyName")
        aCoder.encode(sector, forKey: "sector")
        aCoder.encode(amount, forKey: "amount")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(fees, forKey: "fees")
        aCoder.encode(taxes, forKey: "taxes")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(totalPrice, forKey: "totalPrice")
        
    }
    
    
}
