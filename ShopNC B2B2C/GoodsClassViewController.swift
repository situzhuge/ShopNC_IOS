//
//  GoodsClassViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/5.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class GoodsClassViewController: UITableViewController, UISearchBarDelegate {
    var goodsclassList = [Goodsclassmodel]()
    var activity: UIActivityIndicatorView!
    var ScreenW: CGFloat!
    var topsearchbar: UISearchBar!
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenW = self.view.frame.width
        /**顶部搜索条**/
        topsearchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: ScreenW-20, height: 44))
        for sv in topsearchbar.subviews {
            if sv.isKindOfClass(NSClassFromString("UIView")!) && sv.subviews.count>0 {
                sv.subviews.first!.removeFromSuperview()//去掉搜索框的灰色背景
            }
        }
        topsearchbar.delegate = self
        if self.view.frame.width == 320 {
            topsearchbar.placeholder = "搜索商品                                                 "
        } else {
            topsearchbar.placeholder = "搜索商品                                                             "
        }
        //搜索框父view
        let searchview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        searchview.backgroundColor = UIColor.clearColor()
        searchview.addSubview(topsearchbar)
        self.navigationItem.titleView = searchview
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
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
        activity.startAnimating()
        NSThread.detachNewThreadSelector("loadData", toTarget: self, withObject: nil)
        /**设置下拉刷新**/
        tableView.addHeaderWithTarget(self, action: "pullrefreshData")
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
        self.tabBarController?.tabBar.tintColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        self.tabBarController?.tabBar.translucent = true
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pullrefreshData() {
        goodsclassList = [Goodsclassmodel]()
        loadData()
    }
    
    func loadData() {
        let url = NSURL(string: API_URL + "index.php?act=goods_class")
//        let url = NSURL(string:"http://www.baidu.com")
        print(url);
        let data = NSData(contentsOfURL: url!)
        
//        if data == nil {
//            let alert = UIAlertView(title: "提示2222", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
//            alert.show()
//            return
//        }
        
        
//        // 服务器查询地址前缀
//        let prefix = ("http://101.201.197.50/mobile/index.php?act=goods_class")
//        
//        // NSURL不能处理中文，需要先转换为UTF－8
//        let nsstrURL:NSString = prefix
//        let nsURL:NSURL = NSURL(string:nsstrURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
//        
//        // 获取返回结果，并格式化
//        let resultNSData = NSData(contentsOfURL: nsURL)
//        
//        if resultNSData == nil {
//            let alert = UIAlertView(title: "提示", message: "当前没有网络连接haha", delegate: self, cancelButtonTitle: "确定")
//            alert.show()
//            return
//        }
        
        
        
        if data == nil {
            activity.stopAnimating()
            tableView.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let data_array: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")!.objectForKey("class_list")
        if let datas = data_array as? NSArray {
            for var i=0;i<datas.count;i++ {
                let newgc = Goodsclassmodel()
                let datagc = data_array.objectAtIndex(i) as! NSDictionary
                newgc.gc_id = datagc.objectForKey("gc_id") as! String
                newgc.gc_image = datagc.objectForKey("image") as! String
                newgc.gc_name = datagc.objectForKey("gc_name") as! String
                newgc.gc_text = datagc.objectForKey("text") as! String
                goodsclassList.append(newgc)
            }
        } else {
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
        }
        tableView.headerEndRefreshing()
        activity.stopAnimating()
        tableView.hidden = false
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsclassList.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibname = ""
        var cellID = ""
        if ScreenW == 320 {
            nibname = "GoodsMainClassCell"
            cellID = "GoodsMainClassCellID"
        }
        if ScreenW == 375 {
            nibname = "GoodsMainClassCell375"
            cellID = "GoodsMainClassCellID375"
        }
        if ScreenW == 414 {
            nibname = "GoodsMainClassCell414"
            cellID = "GoodsMainClassCellID414"
        }
        var nibregistered = false
        if !nibregistered {
            let nib = UINib(nibName: nibname, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: cellID)
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! GoodsMainClassCell
        cell.gc_name.text = goodsclassList[indexPath.row].gc_name
        cell.gc_text.text = goodsclassList[indexPath.row].gc_text
        /**图片的延时加载**/
        let cellimgdata: NSArray = [cell, indexPath.row]
        NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let gsccontroller = sb.instantiateViewControllerWithIdentifier("GoodsSubClassID") as! GoodsSubClassViewController
        gsccontroller.navititle = goodsclassList[indexPath.row].gc_name
        gsccontroller.gc_id = goodsclassList[indexPath.row].gc_id
        self.navigationController?.pushViewController(gsccontroller, animated: true)
    }
    
    func uploadImageForCellAtIndexPath(cellimgdata: NSArray) {
        let rownum = cellimgdata.objectAtIndex(1) as! Int
        let picurl = goodsclassList[rownum].gc_image
        let picurl_arr = picurl.componentsSeparatedByString("/")
        var img: UIImage
        var data: NSData!
        if picurl_arr[picurl_arr.count - 1] == "" {
            img = UIImage(named: "goods_nopic.png")!
        } else {
            //调用图片缓存or从网络抓取图片数据
            let imagedatapath = NSHomeDirectory() + "/Library/Caches/GoodsClass/" + picurl_arr[picurl_arr.count - 1]
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
        let cell = cellimgdata.objectAtIndex(0) as! GoodsMainClassCell
        cell.gc_pic.image = img
    }
    
    /**设置搜索框**/
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let svcontroller = sb.instantiateViewControllerWithIdentifier("SearchViewID") as! SearchViewController
        svcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(svcontroller, animated: false)
    }
}
