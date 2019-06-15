//
//  HelpFunctions.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 13/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import Foundation
import UIKit

class HelpFunctions {
    
    func checkIfCellValueIsDouble(textFieldValue: String, errorTitle: String, errorMessage: String, vc: UIViewController) -> Double? {
    
        if let dividendDouble = Double(textFieldValue) {
            return dividendDouble
        } else {
            let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
            return nil
        }
    }
    
    func checkIfCellValueIsDate(textFieldValue: String, errorTitle: String, errorMessage: String, vc: UIViewController) -> Date? {
        let isoDate = textFieldValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        if let dividendDate = dateFormatter.date(from:isoDate) {
            return dividendDate
        } else {
            let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
            return nil
        }
    }
    
    func letViewDisappear(navController: UINavigationController?) {
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navController?.view.layer.add(transition, forKey: nil)
        _ = navController?.popViewController(animated: false)
        
    }
    
    func turnArraysIntoDictionaries(stringArray: [String], doubleArray: [Double]) -> [String:Double] {
        
        var returnDictionary: [String: Double] = [:]
        
        for (index, element) in stringArray.enumerated() {
            let elementExists = returnDictionary[element]
            if elementExists != nil {
                let newValue = elementExists! + doubleArray[index]
                returnDictionary.updateValue(newValue, forKey: element)
            } else {
                returnDictionary[element] = doubleArray[index]
            }
        }
        
        return returnDictionary
    }
}
