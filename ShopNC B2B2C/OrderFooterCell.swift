//
//  OrderFooterCell.swift
//  ShopNC B2B2C
//
//  Created by lzpsnake on 14/12/6.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class OrderFooterCell: UITableViewCell {
    @IBOutlet weak var allnum: UILabel!
    @IBOutlet weak var shipfee: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var cancelbtn: UILabel!
    @IBOutlet weak var confirmbtn: UILabel!
    @IBOutlet weak var shipviewbtn: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
