//
//  OrderGoodsCell.swift
//  ShopNC B2B2C
//
//  Created by lzpsnake on 14/12/6.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class OrderGoodsCell: UITableViewCell {
    @IBOutlet weak var goodspic: UIImageView!
    @IBOutlet weak var goodsname: UILabel!
    @IBOutlet weak var goodsprice: UILabel!
    @IBOutlet weak var buynum: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
