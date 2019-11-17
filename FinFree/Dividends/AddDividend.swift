//
//  AddDividend.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 11/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class AddDividend: UITableViewController {
    
    var criterias = ["Name of the company", "Divdend", "Date", "Taxes", "Fess", "Total Price"]
    var companyName = ""
    var dividend = 0.0
    var date = Date()
    var taxes = 0.0
    var fees = 0.0
    var totalPrice = 0.0
    var dividendNameArray: [String]? = []
    var savingName = ""
    var indexPathrow = 0
    var savingSuccesful = false
    var helperFunc = HelpFunctions()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
        setUIBarButtons()
    }
    
    func setUIBarButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.onCancel(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.onSaved(_:)))
    }
    
    @objc func onCancel (_ sender : AnyObject?){
        
        helperFunc.letViewDisappear(navController: self.navigationController)
        
    }
    
    @objc func onSaved (_ sender : AnyObject?){
        
        // save Data
        saveData()
        
        if savingSuccesful == true {
            
            let dividendObject = Dividend(companyName: companyName,
                                          dividend: dividend,
                                          fees: fees,
                                          taxes: taxes,
                                          date: date,
                                          totalPrice: totalPrice)
            
            let date = Date()
            
            savingName = companyName + "@" + "\(date)"
            
            var encodedData = Data()
            do {
                encodedData = try NSKeyedArchiver.archivedData(withRootObject: dividendObject, requiringSecureCoding: false)
            }
            catch {
                print("ERROR! " + "\(error)")
            }
            
            helperFunc.saveData(data: encodedData, atKey: savingName, atArray: "dividendArrayNew")
            
            // let add-view disappear
            helperFunc.letViewDisappear(navController: self.navigationController)
        } else {
            
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return criterias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0){
            let textFieldCell = Bundle.main.loadNibNamed("TextFieldCell", owner: self, options: nil)?.first as! TextFieldCell
            textFieldCell.textFieldCell.text = ""
            textFieldCell.textFieldCell.placeholder = criterias[indexPath.row]
            return textFieldCell
        } else if(indexPath.row == 2) {
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
        } else {
            let labelFieldCell = Bundle.main.loadNibNamed("LabelTextFieldCell", owner: self, options: nil)?.first as! LabelTextFieldCell
            labelFieldCell.labelString.text = criterias[indexPath.row]
            return labelFieldCell
        }
    }
    
    
    @objc func donedatePicker(){
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func saveData() {
        
        if let firstCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldCell {
            companyName = firstCell.textFieldCell.text!
            savingSuccesful =  true
        } else {
            savingSuccesful =  false
        }
        
        if let secondCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? LabelTextFieldCell {
            if let dividendDouble = helperFunc.checkIfCellValueIsDouble(
                textFieldValue: secondCell.labelTextField.text!,
                errorTitle: "Dividend not valid",
                errorMessage: "Please enter a valid number",
                vc: self) {
                dividend = dividendDouble
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }

        if let thirdcell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? LabelTextFieldCell{
            if let dateConv = helperFunc.checkIfCellValueIsDate(
                textFieldValue: thirdcell.labelTextField.text!,
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
            if let taxesCell = helperFunc.checkIfCellValueIsDouble(
                textFieldValue: fourthCell.labelTextField.text!,
                errorTitle: "Taxes not valid",
                errorMessage: "Please enter a valid tax",
                vc: self) {
                taxes = taxesCell
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
        
        if let fifthCell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? LabelTextFieldCell {
            if let feesCell = helperFunc.checkIfCellValueIsDouble(
                textFieldValue: fifthCell.labelTextField.text!,
                errorTitle: "Fees not valid",
                errorMessage: "Please enter a valid fee",
                vc: self) {
                fees = feesCell
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
        
        if let sixthCell = self.tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? LabelTextFieldCell {
            if let totPriceCell = helperFunc.checkIfCellValueIsDouble(
                textFieldValue: sixthCell.labelTextField.text!,
                errorTitle: "Total price not valid",
                errorMessage: "Please enter a valid price",
                vc: self) {
                totalPrice = totPriceCell
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
    }
}
