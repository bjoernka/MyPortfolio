//
//  AddValueForWatchlist.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 30/5/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore

class AddValueForWatchlist: UITableViewController, UITextFieldDelegate {
    
    var criterias = ["Symbol",  "Name of the Company", "Date", "Current Price", "Desired Price"]
    var plHoldValues = ["AAPL", "Apple Inc.", "2019-06-01", "190.0", "190.0"]
    var symbolCell = TextFieldCell()
    var comNameCell = LabelTextFieldCell()
    var dateCell = LabelTextFieldCell()
    var curPriceCell = LabelTextFieldCell()
    var desPriceCell = LabelTextFieldCell()
    var cellArray: [LabelTextFieldCell] = []
    var symbol = ""
    var companyName = ""
    var date = Date()
    var currentPrice = 0.0
    var desiredPrice = 0.0
    var savingName = ""
    var savingSuccesful = false
    var watchListArray: [String]? = []
    let datePicker = UIDatePicker()
    var dateTextField = UITextField()
    var helperFunc = HelpFunctions()
    var token = Token()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        self.view.backgroundColor = UIColor.white
        
        setUIBarButtons()
        showDatePicker()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return criterias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("TextFieldCell", owner: self, options: nil)?.first as! TextFieldCell
            cell.textFieldCell.text = symbol
            cell.textFieldCell.placeholder = criterias[indexPath.row]
            cell.textFieldCell.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingDidEnd)
            return cell
        } else if indexPath.row == 1{
            let cell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
            cell.leftLabel.text = criterias[indexPath.row]
            cell.rightLabel.text = companyName
            return cell
        } else if indexPath.row == 2{
            let cell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
            datePicker.datePickerMode = .date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            cell.leftLabel.text = criterias[indexPath.row]
            cell.rightLabel.text = formatter.string(from: datePicker.date)
            return cell
        } else if indexPath.row == 3 {
            let cell = Bundle.main.loadNibNamed("LabelTextFieldCell", owner: self, options: nil)?.first as! LabelTextFieldCell
            cell.labelString.text = criterias[indexPath.row]
            cell.labelTextField.text = "\(currentPrice)"
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("LabelTextFieldCell", owner: self, options: nil)?.first as! LabelTextFieldCell
            cell.labelString.text = criterias[indexPath.row]
            cell.labelTextField.text = "\(desiredPrice)"
            cell.labelTextField.addTarget(self, action: #selector(self.desiredPriceChanged(_:)), for: .editingDidEnd)
            return cell
        }
    }
    
    func setUIBarButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.onCancel(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.onSaved(_:)))
    }
    
    @objc func onCancel (_ sender : AnyObject?){
        
        helperFunc.letViewDisappear(navController: self.navigationController)
        
    }
    
    @objc func onSaved (_ sender : AnyObject?){
        
        checkValues()
        
        if savingSuccesful == true {
            
        let watchListItem = WatchListItem(companyName: companyName,
                                          symbol: symbol,
                                          savedPrice: currentPrice,
                                          currentPrice: currentPrice,
                                          date: date,
                                          desiredPrice: desiredPrice,
                                          uid: UserIdent.userUID)
        
        let annotationRef = db.collection("watchListItems")
            annotationRef.addDocument(data: [
                "companyName" : watchListItem.companyName,
                "symbol" : watchListItem.symbol,
                "savedPrice" : watchListItem.savedPrice,
                "currentPrice" : watchListItem.currentPrice,
                "date" : watchListItem.date,
                "desiredPrice" : watchListItem.desiredPrice,
                "uid" : watchListItem.uid
            ]) { err in
                if let err = err {
                    print("Error wrting document: \(err)")
                } else {
                    print("Document succesfully written")
                }
            }
            helperFunc.letViewDisappear(navController: self.navigationController)
        } else {
            
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        
        let textFieldValue = textField.text
        
        if textFieldValue != nil {
            
            symbol = textFieldValue!
            
            let urlString = token.testURL(symbol: symbol, info: "/quote")
            
            //let urlString = "https://api.iextrading.com/1.0/stock/" + textFieldValue! + "/quote"
            
            guard let url = URL(string: urlString) else {
                return
            }
            
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    print(data)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Json ist:")
                        print(json)
                        if let dictionary = json as? [String: Any] {
                            if let latestPrice = dictionary["close"] as? Double {
                                print("Number is: " + "\(latestPrice)")
                                self.currentPrice = latestPrice
                            }
                            if let companyNam = dictionary["companyName"] as? String {
                                print("Number is: " + "\(companyNam)")
                                self.companyName = companyNam
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("The error is:")
                        print(error)
                    }
                }
                }.resume()
    
        } else {
            print("Title not found")
        }
        
        return
    }
    
     @objc func desiredPriceChanged(_ textField: UITextField) {
        
        if let desiredPriceDouble = Double(textField.text!) {
            desiredPrice = desiredPriceDouble
        } else {
            desiredPrice = 0.0
        }
        
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func checkValues() {
        
        if let firstCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldCell {
            symbol = firstCell.textFieldCell.text!
            savingSuccesful =  true
        } else {
            savingSuccesful =  false
        }
        
        if let secondCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? LabelTextFieldCell {
            companyName = secondCell.labelTextField.text!
            savingSuccesful = true
        } else {
            savingSuccesful = false
        }
        
        if let thirdCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? LabelTextFieldCell{
            if let dateConv = helperFunc.checkIfCellValueIsDate(
                textFieldValue: thirdCell.labelTextField.text!,
                errorTitle: "Date not valid",
                errorMessage: "Please enter a valid date",
                vc: self) {
                date = dateConv
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
        
        if let fourthCell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? LabelTextFieldCell {
            if let curPrice = helperFunc.checkIfCellValueIsDouble(
                textFieldValue: fourthCell.labelTextField.text!,
                errorTitle: "Current Price not valid",
                errorMessage: "Please enter a valid price",
                vc: self) {
                currentPrice = curPrice
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
        
        if let fifthCell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? LabelTextFieldCell {
            if let desPrice = helperFunc.checkIfCellValueIsDouble(
                textFieldValue: fifthCell.labelTextField.text!,
                errorTitle: "Desired price not valid",
                errorMessage: "Please enter a valid price",
                vc: self) {
                desiredPrice = desPrice
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
    }
    
}
