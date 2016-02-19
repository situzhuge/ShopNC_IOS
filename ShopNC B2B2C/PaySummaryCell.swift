//
//  PaySummaryCell.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/11.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class PaySummaryCell: UITableViewCell {
    @IBOutlet weak var shipfee: UILabel!
    @IBOutlet weak var mansong: UILabel!
    @IBOutlet weak var daijin: UILabel!
    @IBOutlet weak var amount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
