//
//  ImageLabelCell.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 21/10/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class ImageLabelCell: UITableViewCell {

    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
