//
//  LabelTextFieldCell.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 3/6/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class LabelTextFieldCell: UITableViewCell {

    @IBOutlet weak var labelString: UILabel!
    @IBOutlet weak var labelTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
