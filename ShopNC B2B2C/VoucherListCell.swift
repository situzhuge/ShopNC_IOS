//
//  VoucherListCell.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/9.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class VoucherListCell: UITableViewCell {
    @IBOutlet weak var storename: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var limit: UILabel!
    @IBOutlet weak var starttime: UILabel!
    @IBOutlet weak var endtime: UILabel!
    @IBOutlet weak var priceview: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
