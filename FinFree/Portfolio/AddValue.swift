//
//  addValue.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 29/3/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class AddValue: UITableViewController, UITextFieldDelegate {

    var helpFunc = HelpFunctions()
    var stockNameArray: [String]? = []
    var criterias = ["Symbol", "Name of the company", "Sector", "Current Price", "Amount", "Date", "Taxes", "Fess", "Total Price"]
    var symbol = ""
    var companyName = ""
    var sector = ""
    var currentPrice = 0.0
    var amount = 0.0
    var date = Date()
    var taxes = 0.0
    var fees = 0.0
    var totalPrice = 0.0
    var savingName = ""
    var savingSuccesful = false
    var helperFunc = HelpFunctions()
    let datePicker = UIDatePicker()
    let userDefaults = UserDefaults.standard
    var doubleValues: [Double] = []
    var token = Token()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        self.view.backgroundColor = UIColor.white
        
        setUIBarButtons()
//        showDatePicker()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return criterias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        doubleValues = [0.0, 0.0, 0.0, currentPrice,amount,0.0, taxes,fees]
        
        if(indexPath.row == 0){
            let textFieldCell = Bundle.main.loadNibNamed("TextFieldCell", owner: self, options: nil)?.first as! TextFieldCell
            textFieldCell.textFieldCell.placeholder = criterias[indexPath.row]
            textFieldCell.textFieldCell.text = symbol
            textFieldCell.textFieldCell.delegate = self
            return textFieldCell
        } else if(indexPath.row == 1){
            let textFieldCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
            textFieldCell.leftLabel.text = criterias[indexPath.row]
            textFieldCell.rightLabel.text = companyName
            return textFieldCell
        } else if(indexPath.row == 2){
            let textFieldCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
            textFieldCell.leftLabel.text = criterias[indexPath.row]
            textFieldCell.rightLabel.text = sector
            return textFieldCell
        } else if(indexPath.row == 5) {
            let labelFieldCell = Bundle.main.loadNibNamed("LabelTextFieldCell", owner: self, options: nil)?.first as! LabelTextFieldCell
            datePicker.datePickerMode = .date
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            labelFieldCell.labelTextField.inputAccessoryView = toolbar
            labelFieldCell.labelTextField.inputView = datePicker
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            labelFieldCell.labelTextField.text = formatter.string(from: datePicker.date)
            labelFieldCell.labelString.text = criterias[indexPath.row]
            return labelFieldCell
        } else if(indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 7){
            let labelFieldCell = Bundle.main.loadNibNamed("LabelTextFieldCell", owner: self, options: nil)?.first as! LabelTextFieldCell
            labelFieldCell.labelString.text = criterias[indexPath.row]
            labelFieldCell.labelTextField.text = "\(doubleValues[indexPath.row])"
            labelFieldCell.labelTextField.addTarget(self, action: #selector(self.updateTotalPrice(_:)), for: .editingDidEnd)
            return labelFieldCell
        } else {
            let textFieldCell = Bundle.main.loadNibNamed("WatchListDetail1Cell", owner: self, options: nil)?.first as! WatchListDetail1Cell
            textFieldCell.leftLabel.text = criterias[indexPath.row]
            textFieldCell.rightLabel.text = "\(totalPrice)"
            return textFieldCell
        }
        
    }
    
    func setUIBarButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.onCancel(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.onSaved(_:)))
    }
    
    @objc func onCancel (_ sender : AnyObject?){
        
        helpFunc.letViewDisappear(navController: self.navigationController)
        
    }
    
    @objc func onSaved (_ sender : AnyObject?){
        
        let stock = Stock(symbol: symbol,
                          companyName: companyName,
                          sector: sector,
                          amount: amount,
                          price: currentPrice,
                          fees: fees,
                          taxes: taxes,
                          date: date,
                          totalPrice: totalPrice)
        
        let name = symbol
        
        var encodedData = Data()
        do {
            encodedData = try NSKeyedArchiver.archivedData(withRootObject: stock, requiringSecureCoding: false)
        }
            catch {
            print("ERROR! " + "\(error)")
        }
        if name != nil {
            userDefaults.set(encodedData, forKey: name)
            userDefaults.synchronize()
        }
        
        
        let defaults = UserDefaults.standard
        stockNameArray = defaults.stringArray(forKey: "portfolioValuesNames")
        if (stockNameArray == nil) {
            stockNameArray = []
        }

        if (name != nil) {
            stockNameArray?.append(name)
            print(stockNameArray!)
            defaults.set(stockNameArray, forKey: "portfolioValuesNames")
        }
        
        // let add-view disappear
        helpFunc.letViewDisappear(navController: self.navigationController)
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        
        let textFieldValue = textField.text
        
        if textFieldValue != nil {
        
            let urlString = token.testURL(symbol: textFieldValue!, info: "/company")
            
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
                        if let symbolString = dictionary["symbol"] as? String {
                            self.symbol = "\(symbolString)"
                        }
                        if let companyNameString = dictionary["companyName"] as? String {
                            self.companyName = companyNameString
                        }
                        if let sectorString = dictionary["sector"] as? String {
                            self.sector = sectorString
                        }   
//                        if let latestPrice = dictionary["close"] as? Double {
//                            self.currentPrice = latestPrice
//                        }
                    }
                } catch {
                    print("The error is:")
                    print(error)
                }
            }
            }.resume()
        
        return
        } else {
            print("Title not found")
        }
        self.tableView.reloadData()
    }
    
    @objc func updateTotalPrice(_ textField: UITextField) {
        
        saveData()
        totalPrice = (currentPrice * amount) + fees + taxes
        self.tableView.reloadData()
    }
    
    
    func saveData() {
        
        if let firstCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldCell {
            symbol = firstCell.textFieldCell.text!
            savingSuccesful =  true
        } else {
            savingSuccesful =  false
        }
        
        if let secondCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? LabelTextFieldCell {
            companyName = secondCell.labelTextField.text!
            savingSuccesful =  true
        } else {
            savingSuccesful =  false
        }
        
        if let thirdcell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? LabelTextFieldCell{
            sector = thirdcell.labelTextField.text!
            savingSuccesful =  true
        } else {
            savingSuccesful =  false
        }
        
        if let fourthCell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? LabelTextFieldCell {
            if let curPriceCell = helperFunc.checkIfCellValueIsDouble(
                textFieldValue: fourthCell.labelTextField.text!,
                errorTitle: "Price not valid",
                errorMessage: "Please enter a valid price",
                vc: self) {
                currentPrice = curPriceCell
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
        
        if let fifthCell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? LabelTextFieldCell {
            if let amountCell = helperFunc.checkIfCellValueIsDouble(
                textFieldValue: fifthCell.labelTextField.text!,
                errorTitle: "Amount not valid",
                errorMessage: "Please enter a valid amount",
                vc: self) {
                amount = amountCell
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
        
        if let sixthCell = self.tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? LabelTextFieldCell{
            if let dateConv = helperFunc.checkIfCellValueIsDate(
                textFieldValue: sixthCell.labelTextField.text!,
                errorTitle: "Date not valid",
                errorMessage: "Please enter a valid date",
                vc: self) {
                date = dateConv
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
        
        if let seventhCell = self.tableView.cellForRow(at: IndexPath(row: 6, section: 0)) as? LabelTextFieldCell {
            if let taxesCell = helperFunc.checkIfCellValueIsDouble(
                textFieldValue: seventhCell.labelTextField.text!,
                errorTitle: "Taxes not valid",
                errorMessage: "Please enter a valid tax",
                vc: self) {
                taxes = taxesCell
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
        
        if let eigthCell = self.tableView.cellForRow(at: IndexPath(row: 7, section: 0)) as? LabelTextFieldCell {
            if let feeCell = helperFunc.checkIfCellValueIsDouble(
                textFieldValue: eigthCell.labelTextField.text!,
                errorTitle: "Fees not valid",
                errorMessage: "Please enter a valid fee",
                vc: self) {
                fees = feeCell
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
    }
    
//    func showDatePicker(){
//        //Formate Date
//        datePicker.datePickerMode = .date
//
//        //ToolBar
//        let toolbar = UIToolbar();
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
//
//        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
//
//        dateTextField.inputAccessoryView = toolbar
//        dateTextField.inputView = datePicker
//
//    }
    
    @objc func donedatePicker(){
        
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
        
}