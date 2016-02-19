//
//  HomeGoodsCell.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/15.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class HomeGoodsCell: UITableViewCell {
    @IBOutlet weak var goodsonepic: UIImageView!
    @IBOutlet weak var goodsonename: UILabel!
    @IBOutlet weak var goodsoneprice: UILabel!
    @IBOutlet weak var goodstwopic: UIImageView!
    @IBOutlet weak var goodstwoname: UILabel!
    @IBOutlet weak var goodstwoprice: UILabel!
    @IBOutlet weak var goodstwoview: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
