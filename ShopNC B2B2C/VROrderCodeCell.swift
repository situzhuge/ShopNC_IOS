//
//  VROrderCodeCell.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/9.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class VROrderCodeCell: UITableViewCell {
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var limittime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
