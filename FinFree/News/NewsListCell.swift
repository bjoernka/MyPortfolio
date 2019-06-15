//
//  NewsListCell.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 31/5/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class NewsListCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
