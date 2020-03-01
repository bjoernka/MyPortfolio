//
//  addValue.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 29/3/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore

class AddValue: UITableViewController {

    var helpFunc = HelpFunctions()
    var criterias = ["Symbol", "Name of the company", "Sector", "Current Price", "Amount", "Taxes", "Fess", "Date",  "Total Price"]
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
    let datePicker = UIDatePicker()
    let userDefaults = UserDefaults.standard
    var placeHolderValues: [Double] = []
    var token = Token()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        self.tableView.separatorStyle = .none

        self.view.backgroundColor = UIColor.white
        
        setUIBarButtons()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return criterias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        placeHolderValues = [0.0, 0.0, 0.0, currentPrice,amount, taxes,fees, 0.0,]
        
        switch indexPath.row {
        case 0:
            let cell = helpFunc.createTextFieldCell(textString: symbol, placeholderString: criterias[indexPath.row])
            cell.textFieldCell.delegate = self
            return cell
        case 1:
            let cell = helpFunc.createWatchListCell(leftlabel: criterias[indexPath.row], rightlabel: companyName)
            return cell
        case 2:
            let cell = helpFunc.createWatchListCell(leftlabel: criterias[indexPath.row], rightlabel: sector)
            return cell
        case 3,4,5,6:
            let labelFieldCell = Bundle.main.loadNibNamed("LabelTextFieldCell", owner: self, options: nil)?.first as! LabelTextFieldCell
            labelFieldCell.labelString.text = criterias[indexPath.row]
            labelFieldCell.labelTextField.text = "\(placeHolderValues[indexPath.row])"
            labelFieldCell.labelTextField.addTarget(self, action: #selector(self.updateTotalPrice(_:)), for: .editingDidEnd)
            return labelFieldCell
        case 7:
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
        default:
            let cell = helpFunc.createWatchListCell(leftlabel: criterias[indexPath.row], rightlabel: "\(totalPrice)")
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func setUIBarButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.onCancel(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.onSaved(_:)))
    }
    
    @objc func onCancel (_ sender : AnyObject?){
        
        helpFunc.letViewDisappear(navController: self.navigationController)
        
    }
    
    @objc func onSaved (_ sender : AnyObject?){
        
        checkEntries()
        
        if savingSuccesful == true {
        
        let stock = Stock(symbol: symbol,
                          companyName: companyName,
                          sector: sector,
                          amount: amount,
                          price: currentPrice,
                          fees: fees,
                          taxes: taxes,
                          date: date,
                          totalPrice: totalPrice)
            
        let annotationRef = db.collection("stocks")
        annotationRef.addDocument(data: [
            "symbol" : stock.symbol,
            "companyName" : stock.companyName,
            "sector" : stock.sector,
            "amount" : stock.amount,
            "price" : stock.price,
            "fees" : stock.fees,
            "taxes" : stock.taxes,
            "date" : stock.date,
            "totalPrice" : stock.totalPrice,
            "uid:" : UserIdent.userUID
        ]) { err in
            if let err = err {
                print("Error wrting document: \(err)")
            } else {
                print("Document succesfully written")
            }
        }
        helpFunc.letViewDisappear(navController: self.navigationController)
        } else {
            
        }
    }
    
    @objc func updateTotalPrice(_ textField: UITextField) {
        
        checkEntries()
        totalPrice = (currentPrice * amount) + fees + taxes
        self.tableView.reloadData()
    }
    
    
    func checkEntries() {
        
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
            if let curPriceCell = helpFunc.checkIfCellValueIsDouble(
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
            if let amountCell = helpFunc.checkIfCellValueIsDouble(
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
        
        if let sixthCell = self.tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? LabelTextFieldCell {
            if let taxesCell = helpFunc.checkIfCellValueIsDouble(
                textFieldValue: sixthCell.labelTextField.text!,
                errorTitle: "Fees not valid",
                errorMessage: "Please enter a valid fee",
                vc: self) {
                taxes = taxesCell
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
        
        if let seventhCell = self.tableView.cellForRow(at: IndexPath(row: 6, section: 0)) as? LabelTextFieldCell {
            if let feeCell = helpFunc.checkIfCellValueIsDouble(
                textFieldValue: seventhCell.labelTextField.text!,
                errorTitle: "Taxes not valid",
                errorMessage: "Please enter a valid tax",
                vc: self) {
                fees = feeCell
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
        
        if let eigthCell = self.tableView.cellForRow(at: IndexPath(row: 7, section: 0)) as? LabelTextFieldCell{
            if let dateConv = helpFunc.checkIfCellValueIsDate(
                textFieldValue: eigthCell.labelTextField.text!,
                errorTitle: "Date not valid",
                errorMessage: "Please enter a valid date",
                vc: self) {
                date = dateConv
                savingSuccesful = true
            } else {
                savingSuccesful = false
            }
        }
    }

    @objc func donedatePicker(){
        
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
        
}

extension AddValue: UITextFieldDelegate {
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        
        let textFieldValue = textField.text
        
        if textFieldValue != nil {
            
            let urlString = token.testURL(symbol: textFieldValue!, info: "/company")
            
            print(urlString)
            
            if let url = URL(string: urlString) {
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
                                if let sectorString = dictionary["industry"] as? String {
                                    self.sector = sectorString
                                }
                            }
                        } catch {
                            
                        }
                    }
                }.resume()
            } else {
                print("json could not be downloaded.")
            }
            return
        }
        self.tableView.reloadData()
    }
}
