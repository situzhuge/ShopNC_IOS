//
//  VROrderFooterCell.swift
//  ShopNC B2B2C
//
//  Created by lzpsnake on 14/12/8.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class VROrderFooterCell: UITableViewCell {
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var cancelbtn: UILabel!
    @IBOutlet weak var viewcode: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
