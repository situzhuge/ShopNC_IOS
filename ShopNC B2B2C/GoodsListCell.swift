//
//  GoodsListCell.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/10.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class GoodsListCell: UITableViewCell {
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var goodsprice: UILabel!
    @IBOutlet weak var salenum: UILabel!
    @IBOutlet weak var commentnum: UILabel!
    @IBOutlet weak var goodsname: UILabel!
    @IBOutlet weak var star_1: UIImageView!
    @IBOutlet weak var star_2: UIImageView!
    @IBOutlet weak var star_3: UIImageView!
    @IBOutlet weak var star_4: UIImageView!
    @IBOutlet weak var star_5: UIImageView!
    @IBOutlet weak var zengpin: UIImageView!
    @IBOutlet weak var yvshou: UIImageView!
    @IBOutlet weak var xianshi: UIImageView!
    @IBOutlet weak var tuangou: UIImageView!
    @IBOutlet weak var xvni: UIImageView!
    @IBOutlet weak var fma: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
