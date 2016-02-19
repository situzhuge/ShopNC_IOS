//
//  GoodsGiftViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/19.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class GoodsGiftViewController: UITableViewController {
    var giftList = [Giftmodel]()
    var ScreenW: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "赠品"
        ScreenW = self.view.frame.width
    }

    /**设置顶部状态栏**/
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**设置tableview**/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giftList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibname = ""
        var cellID = ""
        if ScreenW == 320 {
            nibname = "GoodsGiftCell"
            cellID = "GoodsGiftCellID"
        }
        if ScreenW == 375 {
            nibname = "GoodsGiftCell375"
            cellID = "GoodsGiftCellID375"
        }
        if ScreenW == 414 {
            nibname = "GoodsGiftCell414"
            cellID = "GoodsGiftCellID414"
        }
        var nibregistered = false
        if !nibregistered {
            let nib = UINib(nibName: nibname, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: cellID)
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! GoodsGiftCell
        cell.goodsname.text = giftList[indexPath.row].gift_name
        cell.goodsnum.text = giftList[indexPath.row].gift_num + "个"
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let gdcontroller = sb.instantiateViewControllerWithIdentifier("GoodsDetailID") as! GoodsDetailViewController
        gdcontroller.goods_id = giftList[indexPath.row].goods_id
        gdcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gdcontroller, animated: true)
    }
}
