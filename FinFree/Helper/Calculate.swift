//
//  Calculate.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 6/5/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import Foundation

class Calculation {
    
    // calculate return
    func changeInPercentage(purchasePrice: Double, currentPrice: Double) -> String {
        let absoluteChange = currentPrice / purchasePrice
        
        if (absoluteChange > 1) {
            let absoluteChangeMinusOne = absoluteChange - 1
            let absoluteChangeinPercentage = absoluteChangeMinusOne * 100
            let absoluteChangeRounded = (absoluteChangeinPercentage*100).rounded()/100
            let absoluteChangeinPercentageAsString = "+" + "\(absoluteChangeRounded)" + "%"
            return absoluteChangeinPercentageAsString
        } else if (absoluteChange < 1) {
            let absoluteChangeMinusOne = 1 - absoluteChange
            let absoluteChangeinPercentage = absoluteChangeMinusOne * 100
            let absoluteChangeRounded = (absoluteChangeinPercentage*100).rounded()/100
            let absoluteChangeinPercentageAsString = "-" + "\(absoluteChangeRounded)" + "%"
            return absoluteChangeinPercentageAsString
        } else {
            let absoluteChangeinPercentageAsString =  "0" + "%"
            return absoluteChangeinPercentageAsString
        }
    }
    
    func formatPoints(num: String) ->String{
        if let numAsDouble = Double(num) {
        let thousandNum = numAsDouble/1000
        let millionNum = numAsDouble/1000000
        let billionNum = numAsDouble/1000000000
        if numAsDouble >= 1000 && numAsDouble < 1000000{
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))k")
            }
            return("\(thousandNum.rounded())k")
        }
        if numAsDouble > 1000000 && numAsDouble < 1000000000{
            if(floor(millionNum) == millionNum){
                return("\(Int(thousandNum))k")
            }
            return ("\(millionNum.rounded())M")
        }
        if numAsDouble > 1000000000{
            if(floor(billionNum) == billionNum){
                return("\(Int(thousandNum))M")
            }
            return ("\(billionNum.rounded())B")
        }
        else{
            if(floor(numAsDouble) == numAsDouble){
                return ("\(Int(numAsDouble))")
            }
            return ("\(numAsDouble)")
        }
        } else {
            return num
        }
        
    }
    
}
