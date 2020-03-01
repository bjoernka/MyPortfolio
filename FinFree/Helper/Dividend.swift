//
//  Dividend.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 11/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import Foundation

class Dividend: NSObject, NSCoding {
    
    var companyName: String = ""
    var dividend: Double = 0
    var fees: Double = 0
    var taxes: Double = 0
    var date: Date = Date()
    var totalPrice: Double = 0
    var uid: String = ""
    
    init(companyName: String, dividend: Double, fees: Double, taxes: Double, date: Date, totalPrice: Double, uid:String) {
        self.companyName = companyName
        self.dividend = dividend
        self.fees = fees
        self.taxes = taxes
        self.date = date
        self.totalPrice = totalPrice
        self.uid = uid
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let companyName = aDecoder.decodeObject(forKey: "companyName") as! String
        let dividend = aDecoder.decodeDouble(forKey: "dividend")
        let fees = aDecoder.decodeDouble(forKey: "fees")
        let taxes = aDecoder.decodeDouble(forKey: "taxes")
        let date = aDecoder.decodeObject(forKey: "date") as! Date
        let totalPrice = aDecoder.decodeDouble(forKey: "totalPrice")
        let uid = aDecoder.decodeObject(forKey: "uid") as! String
        self.init(companyName: companyName, dividend: dividend, fees: fees, taxes: taxes, date: date, totalPrice: totalPrice, uid: uid)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(companyName, forKey: "companyName")
        aCoder.encode(dividend, forKey: "dividend")
        aCoder.encode(fees, forKey: "fees")
        aCoder.encode(taxes, forKey: "taxes")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(totalPrice, forKey: "totalPrice")
        
    }
    
    
}
