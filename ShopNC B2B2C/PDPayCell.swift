//
//  PDPayCell.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/12.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class PDPayCell: UITableViewCell {
    @IBOutlet weak var yes: UIImageView!
    @IBOutlet weak var no: UIImageView!
    @IBOutlet weak var money: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
