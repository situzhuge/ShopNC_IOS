//
//  AddressListViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/4.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class AddressListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    var ScreenW: CGFloat!
    var activity: UIActivityIndicatorView!
    var adrList = [Addressmodel]()
    var adrview = UITableView()
    var delid = ""
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
            self.title = "选择收货地址"
        } else {
            self.title = "收货地址"
        }
        ScreenW = self.view.frame.width
        adrview.frame = CGRect(x: 0, y: 0, width: ScreenW, height: self.view.frame.height-64)
        self.view.addSubview(adrview)
        adrview.hidden = true
        adrview.delegate = self
        adrview.dataSource = self
        adrview.separatorStyle = UITableViewCellSeparatorStyle.None
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
        /**空数据提示**/
        nothing = UILabel(frame: CGRect(x: (ScreenW-200)/2, y: self.view.frame.height/3, width: 200, height: 30))
        nothing.font = UIFont.systemFontOfSize(16)
        nothing.textColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
        nothing.text = "这里空空如也哦~"
        nothing.textAlignment = NSTextAlignment.Center
        self.view.addSubview(nothing)
        /**设置下拉刷新**/
        adrview.addHeaderWithTarget(self, action: "pullrefreshData")
        /**添加通知监听**/
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "refreshData", name: "AdrRefreshData", object: nil)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新增", style: UIBarButtonItemStyle.Plain, target: self, action: "add")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        UIView.setAnimationsEnabled(true)
    }
    
    /**读取网络数据**/
    func pullrefreshData() {
        refreshData()
    }
    
    func refreshData() {
        adrList.removeAll(keepCapacity: false)
        loadData()
        if adrList.isEmpty {
            adrview.hidden = true
            nothing.hidden = false
        } else {
            nothing.hidden = true
            adrview.hidden = false
            adrview.reloadData()
        }
    }
    
    func loadData() {
        let key = getkey()
        let paramstr = NSString(format: "key=%@", key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_address&op=address_list")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if respdata == nil {
            activity.stopAnimating()
            adrview.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let adr_array: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")!.objectForKey("address_list")
        if let aa = adr_array as? NSArray {
            for val in aa {
                let newadr = Addressmodel()
                let address = val as! NSDictionary
                newadr.address_id = address.objectForKey("address_id") as! String
                newadr.area_id = address.objectForKey("area_id") as! String
                newadr.city_id = address.objectForKey("city_id") as! String
                newadr.area_info = address.objectForKey("area_info") as! String
                newadr.address = address.objectForKey("address") as! String
                newadr.true_name = address.objectForKey("true_name") as! String
                newadr.tel_phone = address.objectForKey("tel_phone") as! String
                newadr.mob_phone = address.objectForKey("mob_phone") as! String
                let isdefault = address.objectForKey("is_default") as! String
                if isdefault == "1" {
                    newadr.is_default = true
                }
                adrList.append(newadr)
            }
        } else {
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
        }
        activity.stopAnimating()
        adrview.headerEndRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adrList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibname = ""
        var cellID = ""
        if ScreenW == 320 {
            nibname = "AddressViewCell"
            cellID = "AddressViewCellID"
        }
        if ScreenW == 375 {
            nibname = "AddressViewCell375"
            cellID = "AddressViewCellID375"
        }
        if ScreenW == 414 {
            nibname = "AddressViewCell414"
            cellID = "AddressViewCellID414"
        }
        var nibregistered = false
        if !nibregistered {
            let nib = UINib(nibName: nibname, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: cellID)
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! AddressViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.areainfo.text = adrList[indexPath.row].area_info
        cell.addressinfo.text = adrList[indexPath.row].address
        cell.contact.text = adrList[indexPath.row].true_name + " " + adrList[indexPath.row].mob_phone + " " + adrList[indexPath.row].tel_phone
        cell.del.tag = Int(adrList[indexPath.row].address_id)!
        cell.del.userInteractionEnabled = true
        cell.del.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "del:"))
        if adrList[indexPath.row].is_default {
            cell.defaultpic.hidden = false
            cell.setdefault.hidden = false
            cell.defaultpic.image = UIImage(named: "checked.png")
            cell.setdefault.text = "默认地址"
        } else {
            cell.defaultpic.hidden = true
            cell.setdefault.hidden = true
        }
        cell.edit.tag = Int(adrList[indexPath.row].address_id)!
        cell.edit.userInteractionEnabled = true
        cell.edit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "edit:"))
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if choosemode {
            bvcontroller.address_id = adrList[indexPath.row].address_id
            bvcontroller.city_id = adrList[indexPath.row].city_id
            bvcontroller.area_id = adrList[indexPath.row].area_id
            bvcontroller.address.area_info = adrList[indexPath.row].area_info
            bvcontroller.address.address = adrList[indexPath.row].address
            bvcontroller.address.true_name = adrList[indexPath.row].true_name
            bvcontroller.address.mob_phone = adrList[indexPath.row].mob_phone
            bvcontroller.address.tel_phone = adrList[indexPath.row].tel_phone
            //通知下单控制器获取新收货地址相关运费信息
            bvcontroller.ori = false
            bvcontroller.reload = false
            let center = NSNotificationCenter.defaultCenter()
            center.postNotificationName("AddressUpdate", object: self, userInfo: nil)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    /**相关操作**/
    func del(recognizer: UITapGestureRecognizer) {
        delid = String(recognizer.view!.tag)
        let alert = UIAlertView(title: "提示", message: "确认要删除此收货地址吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if btnlabel == "确定" {
            let key = getkey()
            let paramstr = NSString(format: "key=%@&address_id=%@", key, delid)
            let paramstrlen = paramstr.length
            let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: API_URL + "index.php?act=member_address&op=address_del")
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postdata
            let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! String
            if data_array == "1" {
                tipstr.text = "删除成功"
                tipimg.image = UIImage(named: "success.png")
                tipshow.hidden = false
                for (key,val) in adrList.enumerate() {
                    if val.address_id == delid {
                        adrList.removeAtIndex(key)
                    }
                }
                adrview.reloadData()
            } else {
                tipstr.text = "删除失败"
                tipimg.image = UIImage(named: "error.png")
                tipshow.hidden = false
            }
            //延时关闭提示框
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
        }
    }
    
    //隐藏黑色提示框
    func hidetip() {
        tipshow.hidden = true
    }
    
    func edit(recognizer: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let adreditcontroller = sb.instantiateViewControllerWithIdentifier("AddressEditViewID") as! AddressEditViewController
        let address_id = String(recognizer.view!.tag)
        for adr in adrList {
            let address = adr as Addressmodel
            if address.address_id == address_id {
                adreditcontroller.adrinfo = address
                break
            }
        }
        adreditcontroller.mode = "edit"
        adreditcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(adreditcontroller, animated: true)
    }
    
    func add() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let adreditcontroller = sb.instantiateViewControllerWithIdentifier("AddressEditViewID") as! AddressEditViewController
        adreditcontroller.mode = "add"
        adreditcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(adreditcontroller, animated: true)
    }
}