//
//  HelpFunctions.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 13/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import Foundation
import UIKit

class HelpFunctions: NSObject {
    
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
    
    func createDateCell(label: String, doneButton: UIBarButtonItem, cancelButton: UIBarButtonItem) -> UITableViewCell {
        
        let datePicker = UIDatePicker()
        
        let labelFieldCell = Bundle.main.loadNibNamed("LabelTextFieldCell", owner: self, options: nil)?.first as! LabelTextFieldCell
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = doneButton;
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = cancelButton;
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        labelFieldCell.labelTextField.inputAccessoryView = toolbar
        labelFieldCell.labelTextField.inputView = datePicker
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        labelFieldCell.labelTextField.text = formatter.string(from: datePicker.date)
        labelFieldCell.labelString.text = label
        return labelFieldCell
        
    }
    
    func createWatchListCell(leftlabel: String, rightlabel: String) -> UITableViewCell {
        let textFieldCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
        textFieldCell.leftLabel.text = leftlabel
        textFieldCell.rightLabel.text = rightlabel
        return textFieldCell
    }
    
    func createTextFieldCell(textString: String, placeholderString: String) -> TextFieldCell {
        let textFieldCell = Bundle.main.loadNibNamed("TextFieldCell", owner: self, options: nil)?.first as! TextFieldCell
        textFieldCell.textFieldCell.placeholder = placeholderString
        textFieldCell.textFieldCell.text = textString
        return textFieldCell
    }
    
    func decodeStockObject(fromData: Data) -> Stock? {
        do {
            let decodedStock = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fromData) as! Stock
            return decodedStock
        } catch {
            print(error)
            return nil
        }
    }
    
    func decodeDividendObject(fromData: Data) -> Dividend? {
        do {
            let decodedDividend = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fromData) as! Dividend
            return decodedDividend
        } catch {
            print(error)
            return nil
        }
    }
    
    func decodeWatchListObject(fromData: Data) -> WatchListItem? {
        do {
            let decodedWatchListItem = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fromData) as! WatchListItem
            return decodedWatchListItem
        } catch {
            print(error)
            return nil
        }
    }
    
    func saveData(data: Data, atKey: String, atArray: String){
     
        let userDefaults = UserDefaults.standard

        userDefaults.set(data, forKey: atKey)
        userDefaults.synchronize()
        
        var stockNames = userDefaults.stringArray(forKey: atArray)
        if (stockNames == nil) {
            stockNames = []
        }
        
        stockNames?.append(atKey)
        userDefaults.set(stockNames, forKey: atArray)
    }
    
    func downloadJsonData(urlString: String) -> Any? {
        var json: Any? = nil
        
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    print(data)
                    do {
                        json = try JSONSerialization.jsonObject(with: data, options: [])
                    } catch {
                        print("The error is:")
                        print(error)
                    }
                }
            }.resume()
        } else {
            print("\(urlString)" + " is not a valid url.")
        }
        
        return json
    }
    
    func checkIfLabelTextFiedCell(row: Int, section: Int) {
        
    }
}
