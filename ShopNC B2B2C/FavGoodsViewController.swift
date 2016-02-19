//
//  FavGoodsViewController.swift
//  ShopNC B2B2C
//
//  Created by lzpsnake on 14/11/29.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class FavGoodsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var ScreenW: CGFloat!
    var activity: UIActivityIndicatorView!
    var goodsList = [Goodsmodel]()
    var goodslistview = UITableView()
    var curpage = 1
    var page = 10
    var haveMore = false
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收藏商品"
        ScreenW = self.view.frame.width
        goodslistview.frame = CGRect(x: 0, y: 0, width: ScreenW, height: self.view.frame.height-64)
        self.view.addSubview(goodslistview)
        goodslistview.hidden = true
        goodslistview.delegate = self
        goodslistview.dataSource = self
        /**添加黑色提示框**/
        tipshow.frame = CGRect(x: (ScreenW-150)/2, y: (self.view.frame.height-80)/3, width: 150, height: 80)
        tipshow.backgroundColor = UIColor.clearColor()
        tipshow.layer.cornerRadius = 10
        let tipbg = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 80))
        tipbg.image = UIImage(named: "tipbg.png")
        tipshow.addSubview(tipbg)
        tipstr = UILabel(frame: CGRect(x: 10, y: 45, width: 130, height: 20))
        tipstr.font = UIFont.systemFontOfSize(18)
        tipstr.textAlignment = NSTextAlignment.Center
        tipstr.textColor = UIColor.whiteColor()
        tipshow.addSubview(tipstr)
        tipimg.frame = CGRect(x: 60, y: 10, width: 30, height: 30)
        tipshow.addSubview(tipimg)
        tipshow.hidden = true
        self.view.addSubview(tipshow)
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        activity.startAnimating()
        NSThread.detachNewThreadSelector("refreshData", toTarget: self, withObject: nil)
        /**设置下拉刷新**/
        goodslistview.addHeaderWithTarget(self, action: "pullLoadData")
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
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**读取网络数据**/
    func pullLoadData() {
        refreshData()
    }
    
    func refreshData() {
        goodsList.removeAll(keepCapacity: false)
        curpage = 1
        loadData()
        if goodsList.isEmpty {
            goodslistview.hidden = true
            let nothing = UILabel(frame: CGRect(x: (ScreenW-200)/2, y: self.view.frame.height/3, width: 200, height: 30))
            nothing.font = UIFont.systemFontOfSize(16)
            nothing.textColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
            nothing.text = "这里空空如也哦~"
            nothing.textAlignment = NSTextAlignment.Center
            self.view.addSubview(nothing)
        } else {
            goodslistview.hidden = false
            goodslistview.reloadData()
        }
    }
    
    func loadData() {
        let key = getkey()
        let paramstr = NSString(format: "key=%@", key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_favorites&op=favorites_list&page=" + String(page) + "&curpage=" + String(curpage))
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if respdata == nil {
            activity.stopAnimating()
            goodslistview.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let havemorestr = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("hasmore") as! Int
        if havemorestr == 1 {
            haveMore = true
        } else {
            haveMore = false
        }
        let favdata_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        let fav_list: AnyObject! = favdata_array.objectForKey("favorites_list")
        if let fl = fav_list as? NSArray {
            for fav in fl {
                let newgoods = Goodsmodel()
                let goodsinfo = fav as! NSDictionary
                let name = goodsinfo.objectForKey("goods_name") as! String
                let price = goodsinfo.objectForKey("goods_price") as! String
                let picurl = goodsinfo.objectForKey("goods_image_url") as! String
                let goodsid = goodsinfo.objectForKey("goods_id") as! String
                let favid = goodsinfo.objectForKey("fav_id") as! String
                newgoods.goods_name = name
                newgoods.goods_price = price
                newgoods.goods_image = picurl
                newgoods.goods_id = goodsid
                newgoods.fav_id = favid
                goodsList.append(newgoods)
            }
        } else {
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
        }
        goodslistview.headerEndRefreshing()
        activity.stopAnimating()
    }
    
    func addData() {
        if haveMore {
            curpage++
            activity.startAnimating()
            loadData()
            goodslistview.reloadData()
        }
    }
    
    /**tableview设置**/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibname = ""
        var cellID = ""
        if ScreenW == 320 {
            nibname = "FavGoodsCell"
            cellID = "FavGoodsCellID"
        }
        if ScreenW == 375 {
            nibname = "FavGoodsCell375"
            cellID = "FavGoodsCellID375"
        }
        if ScreenW == 414 {
            nibname = "FavGoodsCell414"
            cellID = "FavGoodsCellID414"
        }
        var nibregistered = false
        if !nibregistered {
            let nib = UINib(nibName: nibname, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: cellID)
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! FavGoodsCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if !goodsList.isEmpty {
            cell.goodsname.text = goodsList[indexPath.row].goods_name
            cell.goodsprice.text = "￥" + goodsList[indexPath.row].goods_price
            /**图片的延时加载**/
            let cellimgdata: NSArray = [cell, indexPath.row]
            NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
        }
        return cell
    }
    
    func uploadImageForCellAtIndexPath(cellimgdata: NSArray) {
        let rownum = cellimgdata.objectAtIndex(1) as! Int
        let picurl = goodsList[rownum].goods_image
        let picurl_arr = picurl.componentsSeparatedByString("/")
        var img: UIImage
        var data: NSData!
        if picurl_arr[picurl_arr.count - 1] == "" {
            img = UIImage(named: "goods_nopic.png")!
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
                img = UIImage(named: "goods_nopic.png")!
            }
        }
        let cell = cellimgdata.objectAtIndex(0) as! FavGoodsCell
        cell.goodspic.image = img
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let gdcontroller = sb.instantiateViewControllerWithIdentifier("GoodsDetailID") as! GoodsDetailViewController
        gdcontroller.goods_id = goodsList[indexPath.row].goods_id
        gdcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gdcontroller, animated: true)
    }
    
    /**滑动删除**/
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        goodslistview.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let fav_id = goodsList[indexPath.row].fav_id
            let delrs = delfavgoods(fav_id)
            if delrs {
                goodsList.removeAtIndex(indexPath.row)
// liubw               goodslistview.deleteRowsAtIndexPaths(NSArray(object: indexPath) as [AnyObject] as [AnyObject], withRowAnimation:UITableViewRowAnimation.Fade)
            } else {
                tipstr.text = "删除失败"
                tipimg.image = UIImage(named: "error.png")
                tipshow.hidden = false
                //延时关闭提示框
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
            }
        }
    }
    
    /**tableview滑动控制**/
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let nowoffsetY = goodslistview.contentOffset.y
        let cellsH = 80*page
        let addOffsetY = Float(cellsH*curpage) - Float(self.view.frame.height) + Float(40)
        if Float(nowoffsetY) >= addOffsetY {
            NSThread.detachNewThreadSelector("addData", toTarget: self, withObject: nil)
        }
    }
    
    /**删除收藏商品**/
    func delfavgoods(fav_id: String) -> Bool {
        activity.startAnimating()
        var rs = false
        let key = getkey()
        let paramstr = NSString(format: "fav_id=%@&key=%@", fav_id, key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_favorites&op=favorites_del")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        let data_array: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")
        if let datas = data_array as? String {
            if datas == "1" {
                rs = true
            }
        }
        activity.stopAnimating()
        return rs
    }
    
    //隐藏黑色提示框
    func hidetip() {
        tipshow.hidden = true
    }
}