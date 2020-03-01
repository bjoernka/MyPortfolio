//
//  StockObject.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 29/2/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import Foundation

struct StockObject {
    
    var symbol: String = ""
    var companyName: String = ""
    var sector: String = ""
    var amount: Double = 0
    var price: Double = 0
    var fees: Double = 0
    var taxes: Double = 0
    var date: Date = Date()
    var totalPrice: Double = 0
    var uid: String = ""
    
    init(symbol: String, companyName: String, sector: String, amount: Double, price: Double, fees: Double, taxes: Double, date: Date, totalPrice: Double, uid: String) {
        self.symbol = symbol
        self.companyName = companyName
        self.sector = sector
        self.amount = amount
        self.price = price
        self.fees = fees
        self.taxes = taxes
        self.date = date
        self.totalPrice = totalPrice
        self.uid = uid
    }
}
