//
//  AddressViewCell.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/4.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class AddressViewCell: UITableViewCell {
    @IBOutlet weak var areainfo: UILabel!
    @IBOutlet weak var addressinfo: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var defaultpic: UIImageView!
    @IBOutlet weak var setdefault: UILabel!
    @IBOutlet weak var edit: UIView!
    @IBOutlet weak var del: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
