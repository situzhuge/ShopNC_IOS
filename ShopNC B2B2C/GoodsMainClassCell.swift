//
//  GoodsMainClassCell.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/7.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class GoodsMainClassCell: UITableViewCell {
    @IBOutlet weak var gc_pic: UIImageView!
    @IBOutlet weak var gc_name: UILabel!
    @IBOutlet weak var gc_text: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
