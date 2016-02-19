//
//  FavStoreViewController.swift
//  ShopNC B2B2C
//
//  Created by 李梓平 on 14/12/24.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class FavStoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var ScreenW: CGFloat!
    var activity: UIActivityIndicatorView!
    var storeList = [Storemodel]()
    var storelistview = UITableView()
    var curpage = 1
    var page = 10
    var haveMore = false
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收藏店铺"
        ScreenW = self.view.frame.width
        storelistview.frame = CGRect(x: 0, y: 0, width: ScreenW, height: self.view.frame.height-64)
        self.view.addSubview(storelistview)
        storelistview.hidden = true
        storelistview.delegate = self
        storelistview.dataSource = self
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
        /**设置下拉刷新**/
        storelistview.addHeaderWithTarget(self, action: "pullLoadData")
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        UIView.setAnimationsEnabled(true)
        activity.startAnimating()
        NSThread.detachNewThreadSelector("refreshData", toTarget: self, withObject: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**读取网络数据**/
    func pullLoadData() {
        refreshData()
    }
    
    func refreshData() {
        storeList.removeAll(keepCapacity: false)
        curpage = 1
        loadData()
        if storeList.isEmpty {
            storelistview.hidden = true
            let nothing = UILabel(frame: CGRect(x: (ScreenW-200)/2, y: self.view.frame.height/3, width: 200, height: 30))
            nothing.font = UIFont.systemFontOfSize(16)
            nothing.textColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
            nothing.text = "这里空空如也哦~"
            nothing.textAlignment = NSTextAlignment.Center
            self.view.addSubview(nothing)
        } else {
            storelistview.hidden = false
            storelistview.reloadData()
        }
    }
    
    func loadData() {
        let key = getkey()
        let paramstr = NSString(format: "key=%@", key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_favorites_store&op=favorites_list&page=" + String(page) + "&curpage=" + String(curpage))
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if respdata == nil {
            activity.stopAnimating()
            storelistview.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let favdata_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        if favdata_array.objectForKey("error") != nil {
            activity.stopAnimating()
            storelistview.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let havemorestr = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("hasmore") as! Int
        if havemorestr == 1 {
            haveMore = true
        } else {
            haveMore = false
        }
        let fav_list: AnyObject! = favdata_array.objectForKey("favorites_list")
        if let fl = fav_list as? NSArray {
            for fav in fl {
                let newstore = Storemodel()
                let storeinfo = fav as! NSDictionary
                newstore.store_id = storeinfo.objectForKey("store_id") as! String
                newstore.store_name = storeinfo.objectForKey("store_name") as! String
                newstore.store_collect = storeinfo.objectForKey("store_collect") as! String
                newstore.store_avatar_url = storeinfo.objectForKey("store_avatar_url") as! String
                newstore.fav_time = storeinfo.objectForKey("fav_time_text") as! String
                storeList.append(newstore)
            }
        }
        storelistview.headerEndRefreshing()
        activity.stopAnimating()
    }
    
    func addData() {
        if haveMore {
            curpage++
            activity.startAnimating()
            loadData()
            storelistview.reloadData()
        }
    }
    
    /**tableview设置**/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibname = ""
        var cellID = ""
        if ScreenW == 320 {
            nibname = "FavStoreCell"
            cellID = "FavStoreCellID"
        }
        if ScreenW == 375 {
            nibname = "FavStoreCell375"
            cellID = "FavStoreCellID375"
        }
        if ScreenW == 414 {
            nibname = "FavStoreCell414"
            cellID = "FavStoreCellID414"
        }
        var nibregistered = false
        if !nibregistered {
            let nib = UINib(nibName: nibname, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: cellID)
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! FavStoreCell
        cell.storename.text = storeList[indexPath.row].store_name
        cell.favtime.text = "收藏时间：" + storeList[indexPath.row].fav_time
        cell.collectnum.text = "收藏人气：" + storeList[indexPath.row].store_collect
        /**图片的延时加载**/
        let cellimgdata: NSArray = [cell, indexPath.row]
        NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func uploadImageForCellAtIndexPath(cellimgdata: NSArray) {
        let rownum = cellimgdata.objectAtIndex(1) as! Int
        let picurl = storeList[rownum].store_avatar_url
        let picurl_arr = picurl.componentsSeparatedByString("/")
        var img: UIImage
        var data: NSData!
        if picurl_arr[picurl_arr.count - 1] == "" {
            img = UIImage(named: "goods_nopic.png")!
        } else {
            //调用图片缓存or从网络抓取图片数据
            let imagedatapath = NSHomeDirectory() + "/Library/Caches/Store/" + picurl_arr[picurl_arr.count - 1]
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
        let cell = cellimgdata.objectAtIndex(0) as! FavStoreCell
        cell.storepic.image = img
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sdcontroller = sb.instantiateViewControllerWithIdentifier("StoreDetailViewID") as! StoreDetailViewController
        sdcontroller.store_id = storeList[indexPath.row].store_id
        sdcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sdcontroller, animated: true)
    }
    
    /**滑动删除**/
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        storelistview.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let store_id = storeList[indexPath.row].store_id
            let delrs = delfavstore(store_id)
            if delrs {
                storeList.removeAtIndex(indexPath.row)
// liubw               storelistview.deleteRowsAtIndexPaths(NSArray(object: indexPath) as [AnyObject] as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
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
        let nowoffsetY = storelistview.contentOffset.y
        let cellsH = 80*page
        let addOffsetY = Float(cellsH*curpage) - Float(self.view.frame.height) + Float(40)
        if Float(nowoffsetY) >= addOffsetY {
            NSThread.detachNewThreadSelector("addData", toTarget: self, withObject: nil)
        }
    }
    
    /**删除收藏店铺**/
    func delfavstore(store_id: String) -> Bool {
        activity.startAnimating()
        var rs = false
        let key = getkey()
        let paramstr = NSString(format: "store_id=%@&key=%@", store_id, key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_favorites_store&op=favorites_del")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if respdata == nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return rs
        }
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