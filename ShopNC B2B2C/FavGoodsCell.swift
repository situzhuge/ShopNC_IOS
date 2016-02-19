//
//  FavGoodsCell.swift
//  ShopNC B2B2C
//
//  Created by lzpsnake on 14/11/29.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class FavGoodsCell: UITableViewCell {
    @IBOutlet weak var goodspic: UIImageView!
    @IBOutlet weak var goodsname: UILabel!
    @IBOutlet weak var goodsprice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
