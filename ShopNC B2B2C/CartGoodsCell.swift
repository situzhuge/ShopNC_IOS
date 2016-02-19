//
//  CartGoodsCell.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/1.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class CartGoodsCell: UITableViewCell {
    @IBOutlet weak var checkpic: UIImageView!
    @IBOutlet weak var goodspic: UIImageView!
    @IBOutlet weak var goodsname: UILabel!
    @IBOutlet weak var goodsprice: UILabel!
    @IBOutlet weak var buynum: UILabel!
    @IBOutlet weak var editicon: UIImageView!
    //修改商品数量组件
    @IBOutlet weak var reducenum: UIView!
    @IBOutlet weak var addnum: UIView!
    @IBOutlet weak var numshow: UIView!
    @IBOutlet weak var confirmbtn: UIImageView!
    @IBOutlet weak var numlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
