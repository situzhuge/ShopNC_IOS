//
//  FavStoreCell.swift
//  ShopNC B2B2C
//
//  Created by 李梓平 on 14/12/24.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class FavStoreCell: UITableViewCell {
    @IBOutlet weak var storepic: UIImageView!
    @IBOutlet weak var storename: UILabel!
    @IBOutlet weak var favtime: UILabel!
    @IBOutlet weak var collectnum: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
