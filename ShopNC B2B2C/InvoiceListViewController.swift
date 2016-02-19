//
//  InvoiceListViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/10.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class InvoiceListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var invList = [Invoicemodel]()
    var activity: UIActivityIndicatorView!
    var invview = UITableView()
    var ScreenW: CGFloat!
    var nothing: UILabel!
    //下订单结算相关
    var choosemode = false
    var bvcontroller: BuyViewController!
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if choosemode {
            self.title = "选择发票"
        } else {
            self.title = "发票管理"
        }
        ScreenW = self.view.frame.width
        invview.frame = CGRect(x: 0, y: 0, width: ScreenW, height: self.view.frame.height-64)
        self.view.addSubview(invview)
        invview.hidden = true
        invview.delegate = self
        invview.dataSource = self
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
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        activity.startAnimating()
        NSThread.detachNewThreadSelector("refreshData", toTarget: self, withObject: nil)
        /**空数据提示**/
        nothing = UILabel(frame: CGRect(x: (ScreenW-200)/2, y: self.view.frame.height/3, width: 200, height: 30))
        nothing.font = UIFont.systemFontOfSize(16)
        nothing.textColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
        nothing.text = "这里空空如也哦~"
        nothing.textAlignment = NSTextAlignment.Center
        self.view.addSubview(nothing)
        /**添加通知监听**/
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "refreshData", name: "InvRefreshData", object: nil)
        /**设置下拉刷新**/
        invview.addHeaderWithTarget(self, action: "pullrefreshData")
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
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.tabBarController?.tabBar.tintColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        self.tabBarController?.tabBar.translucent = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.Plain, target: self, action: "add")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        UIView.setAnimationsEnabled(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**调取网络数据**/
    func pullrefreshData() {
        refreshData()
    }
    
    func refreshData() {
        invList.removeAll(keepCapacity: false)
        loadData()
        if invList.isEmpty {
            invview.hidden = true
            nothing.hidden = false
        } else {
            nothing.hidden = true
            invview.hidden = false
            invview.reloadData()
        }
    }
    
    func loadData() {
        let key = getkey()
        let paramstr = NSString(format: "key=%@", key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_invoice&op=invoice_list")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if respdata == nil {
            activity.stopAnimating()
            invview.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        if data_array.objectForKey("error") != nil {
            activity.stopAnimating()
            invview.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        if data_array.objectForKey("invoice_list") != nil {
            let inv_list = data_array.objectForKey("invoice_list") as! NSArray
            for i in inv_list {
                let invinfo = i as! NSDictionary
                let newinv = Invoicemodel()
                newinv.inv_id = invinfo.objectForKey("inv_id") as! String
                newinv.inv_title = invinfo.objectForKey("inv_title") as! String
                newinv.inv_content = invinfo.objectForKey("inv_content") as! String
                invList.append(newinv)
            }
        }
        if choosemode {
            let newinv = Invoicemodel()
            newinv.inv_id = "0"
            newinv.inv_title = "不需要发票"
            newinv.inv_content = ""
            invList.append(newinv)
        }
        activity.stopAnimating()
    }
    
    /**tableview相关设置**/
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibregistered = false
        if !nibregistered {
            tableView.registerClass(UITableViewCell().classForCoder, forCellReuseIdentifier: "InvListCellID")
            nibregistered = true
        }
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "InvListCellID")
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel!.text = invList[indexPath.row].inv_title
        cell.detailTextLabel?.text = invList[indexPath.row].inv_content
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if choosemode {
            bvcontroller.reload = false
            if invList[indexPath.row].inv_id != "0" {
                bvcontroller.invoice_id = invList[indexPath.row].inv_id
                bvcontroller.invcell.textLabel!.text = "普通发票 " + invList[indexPath.row].inv_title + " " + invList[indexPath.row].inv_content
            } else {
                bvcontroller.invoice_id = ""
                bvcontroller.invcell.textLabel!.text = invList[indexPath.row].inv_title
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    /**滑动删除**/
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        invview.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let inv_id = invList[indexPath.row].inv_id
            let delrs = delinv(inv_id)
            if delrs {
                invList.removeAtIndex(indexPath.row)
//  liubw              invview.deleteRowsAtIndexPaths(NSArray(object: indexPath) as [AnyObject] as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
            } else {
                tipstr.text = "删除失败"
                tipimg.image = UIImage(named: "error.png")
                tipshow.hidden = false
                //延时关闭提示框
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
            }
        }
    }
    
    func delinv(inv_id: String) -> Bool {
        activity.startAnimating()
        var rs = false
        let key = getkey()
        let paramstr = NSString(format: "inv_id=%@&key=%@", inv_id, key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_invoice&op=invoice_del")
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
    
    /**添加新发票**/
    func add() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let invaddcontroller = sb.instantiateViewControllerWithIdentifier("InvoiceAddViewID") as! InvoiceAddViewController
        invaddcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(invaddcontroller, animated: true)
    }
}
