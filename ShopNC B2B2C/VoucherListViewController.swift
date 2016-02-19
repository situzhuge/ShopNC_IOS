//
//  VoucherListViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/5.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class VoucherListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var voucher_status = "1"//1-未使用 2-已使用 3-已过期
    var ScreenW: CGFloat!
    var activity: UIActivityIndicatorView!
    var voucherList = [Vouchermodel]()
    var voucherview: UITableView!
    var nothing = UILabel()
    var curpage = 1
    var page = 10
    var haveMore = false
    var colorindex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的代金券"
        ScreenW = self.view.frame.width
        voucherview = UITableView(frame: CGRect(x: 10, y: 50, width: ScreenW-20, height: self.view.frame.height-64-50), style: UITableViewStyle.Grouped)
        self.view.addSubview(voucherview)
        self.view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 1.0)
        voucherview.hidden = true
        voucherview.delegate = self
        voucherview.dataSource = self
        /**切换控制器**/
        let segarr = ["未使用", "已使用", "已过期"]
        let segctr = UISegmentedControl(items: segarr)
        segctr.frame = CGRect(x: (ScreenW-240)/2, y: 10, width: 240, height: 30)
        segctr.selectedSegmentIndex = 0
        segctr.tintColor = UIColor(red: 158/255, green: 0/255, blue: 3/255, alpha: 1.0)
        segctr.addTarget(self, action: "segchange:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(segctr)
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        activity.startAnimating()
        NSThread.detachNewThreadSelector("refreshData", toTarget: self, withObject: nil)
        /**设置下拉刷新**/
        voucherview.addHeaderWithTarget(self, action: "pullrefreshData")
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
        self.tabBarController?.tabBar.tintColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        self.tabBarController?.tabBar.translucent = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**切换器操作**/
    func segchange(seg: UISegmentedControl) {
        let segindex = seg.selectedSegmentIndex
        switch segindex {
        case 0:
            voucher_status = "1"
        case 1:
            voucher_status = "2"
        case 2:
            voucher_status = "3"
        default:
            voucher_status = "1"
        }
        activity.startAnimating()
        NSThread.detachNewThreadSelector("refreshData", toTarget: self, withObject: nil)
    }
    
    /**调取网络数据**/
    func pullrefreshData() {
        refreshData()
    }
    
    func refreshData() {
        voucherList.removeAll(keepCapacity: false)
        curpage = 1
        colorindex = 1
        loadData()
        if voucherList.isEmpty {
            voucherview.hidden = true
            nothing.frame = CGRect(x: (ScreenW-200)/2, y: self.view.frame.height/3, width: 200, height: 30)
            nothing.font = UIFont.systemFontOfSize(16)
            nothing.textColor = UIColor.grayColor()
            nothing.text = "这里空空如也哦~"
            nothing.textAlignment = NSTextAlignment.Center
            self.view.addSubview(nothing)
            nothing.hidden = false
        } else {
            voucherview.hidden = false
            voucherview.reloadData()
            nothing.hidden = true
        }
    }
    
    func loadData() {
        let key = getkey()
        let paramstr = NSString(format: "key=%@&voucher_state=%@", key, voucher_status)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_voucher&op=voucher_list&page=" + String(page) + "&curpage=" + String(curpage))
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        voucherview.headerEndRefreshing()
        if respdata == nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        if data_array.objectForKey("error") != nil {
            activity.stopAnimating()
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
        if data_array.objectForKey("voucher_list") != nil {
            let voucherlist: AnyObject! = data_array.objectForKey("voucher_list")
            if let vouchers = voucherlist as? NSArray {
                for i in vouchers {
                    let newvouchers = Vouchermodel()
                    let vouchersinfo = i as! NSDictionary
                    newvouchers.store_id = vouchersinfo.objectForKey("store_id") as! String
                    newvouchers.store_name = vouchersinfo.objectForKey("store_name") as! String
                    newvouchers.voucher_start_date = vouchersinfo.objectForKey("voucher_start_date") as! String
                    newvouchers.voucher_end_date = vouchersinfo.objectForKey("voucher_end_date") as! String
                    newvouchers.voucher_limit = vouchersinfo.objectForKey("voucher_limit") as! String
                    newvouchers.voucher_price = vouchersinfo.objectForKey("voucher_price") as! String
                    voucherList.append(newvouchers)
                }
            }
        }
        activity.stopAnimating()
    }
    
    func addData() {
        if haveMore {
            curpage++
            activity.startAnimating()
            loadData()
            voucherview.reloadData()
        }
    }
    
    /**tableview相关设置**/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return voucherList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibname = ""
        var cellID = ""
        if ScreenW == 320 {
            nibname = "VoucherListCell"
            cellID = "VoucherListCellID"
        }
        if ScreenW == 375 {
            nibname = "VoucherListCell375"
            cellID = "VoucherListCellID375"
        }
        if ScreenW == 414 {
            nibname = "VoucherListCell414"
            cellID = "VoucherListCellID414"
        }
        var nibregistered = false
        if !nibregistered {
            let nib = UINib(nibName: nibname, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: cellID)
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! VoucherListCell
        cell.storename.text = voucherList[indexPath.section].store_name
        cell.price.text = voucherList[indexPath.section].voucher_price
        cell.limit.text = "订单满" + voucherList[indexPath.section].voucher_limit + "元 (不含邮费)"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let starttimestr = voucherList[indexPath.section].voucher_start_date as NSString
        cell.starttime.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: starttimestr.doubleValue))
        let endtimestr = voucherList[indexPath.section].voucher_end_date as NSString
        cell.endtime.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: endtimestr.doubleValue))
        switch colorindex {
        case 1:
            cell.priceview.backgroundColor = UIColor(red: 231/255, green: 56/255, blue: 97/255, alpha: 1.0)
        case 2:
            cell.priceview.backgroundColor = UIColor(red: 250/255, green: 153/255, blue: 20/255, alpha: 1.0)
        case 3:
            cell.priceview.backgroundColor = UIColor(red: 129/255, green: 187/255, blue: 31/255, alpha: 1.0)
        case 4:
            cell.priceview.backgroundColor = UIColor(red: 62/255, green: 164/255, blue: 214/255, alpha: 1.0)
        default:
            cell.priceview.backgroundColor = UIColor(red: 231/255, green: 56/255, blue: 97/255, alpha: 1.0)
        }
        if colorindex == 4 {
            colorindex = 1
        } else {
            colorindex++
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if voucherList[indexPath.section].store_id != "1" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let sdcontroller = sb.instantiateViewControllerWithIdentifier("StoreDetailViewID") as! StoreDetailViewController
            sdcontroller.store_id = voucherList[indexPath.section].store_id
            sdcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sdcontroller, animated: true)
        }
    }
    
    /**tableview滑动控制**/
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let nowoffsetY = voucherview.contentOffset.y
        let cellsH = 120*page
        let addOffsetY = Float(cellsH*curpage) - Float(self.view.frame.height) + Float(50)
        if Float(nowoffsetY) >= addOffsetY {
            NSThread.detachNewThreadSelector("addData", toTarget: self, withObject: nil)
        }
    }
}