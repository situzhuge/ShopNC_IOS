//
//  PayTypeCell.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/11.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class PayTypeCell: UITableViewCell {
    @IBOutlet weak var payonline: UIImageView!
    @IBOutlet weak var payoffline: UIImageView!
    @IBOutlet weak var offlinelabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
