//
//  OrderTitltCell.swift
//  ShopNC B2B2C
//
//  Created by lzpsnake on 14/12/6.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class OrderTitltCell: UITableViewCell {
    @IBOutlet weak var storename: UILabel!
    @IBOutlet weak var ordersn: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var lock: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
