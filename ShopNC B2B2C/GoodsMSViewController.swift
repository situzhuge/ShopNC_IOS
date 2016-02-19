//
//  GoodsMSViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/19.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class GoodsMSViewController: UITableViewController {
    var msList = [Msmodel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "满即送"
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
        return msList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibregistered = false
        if !nibregistered {
            let nib = UINib(nibName: "GoodsMSCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "GoodsMSCellID")
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("GoodsMSCellID", forIndexPath: indexPath) as! GoodsMSCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.datastr.text = msList[indexPath.row].limitdata
        cell.mansongstr.text = msList[indexPath.row].mansong
        /**图片的延时加载**/
        let cellimgdata: NSArray = [cell, indexPath.row]
        NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func uploadImageForCellAtIndexPath(cellimgdata: NSArray) {
        let rownum = cellimgdata.objectAtIndex(1) as! Int
        let picurl = msList[rownum].gift_img_url
        if picurl != "" {
            let picurl_arr = picurl.componentsSeparatedByString("/")
            var img: UIImage
            var data: NSData!
            if picurl_arr[picurl_arr.count - 1] == "" {
                img = UIImage(named: "nogift.png")!
            } else {
                //调用图片缓存or从网络抓取图片数据
                let imagedatapath = NSHomeDirectory() + "/Library/Caches/Goods/" + picurl_arr[picurl_arr.count - 1]
                if NSFileManager.defaultManager().fileExistsAtPath(imagedatapath) {
                    data = NSFileManager.defaultManager().contentsAtPath(imagedatapath)!
                } else {
                    let url = NSURL(string: picurl)!
                    data = NSData(contentsOfURL: url)
                    if data != nil {
                        data.writeToFile(imagedatapath, atomically: false)
                    }
                }
                if data != nil {
                    img = UIImage(data: data)!
                } else {
                    img = UIImage(named: "nogift.png")!
                }
            }
            let cell = cellimgdata.objectAtIndex(0) as! GoodsMSCell
            cell.giftimg.image = img
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if msList[indexPath.row].gift_goods_id != "" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let gdcontroller = sb.instantiateViewControllerWithIdentifier("GoodsDetailID") as! GoodsDetailViewController
            gdcontroller.goods_id = msList[indexPath.row].gift_goods_id
            gdcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(gdcontroller, animated: true)
        }
    }
}