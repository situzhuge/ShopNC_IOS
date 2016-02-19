//我的订单页面

import UIKit

class OrderListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate {
    var ScreenW: CGFloat!
    var activity: UIActivityIndicatorView!
    var ordergroupList = [Orderdatamodel]()
    var orderview: UITableView!
    var exc_orderid = ""
    var paysnList = [String:String]()
    var paysnIndex = 1
    var fromcheckout = false
    var payment = 0//0未找到1支付宝2微信3支付宝+微信
    var pay_sn = ""
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的订单"
        ScreenW = self.view.frame.width
        orderview = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: self.view.frame.height-64), style: UITableViewStyle.Grouped)
        self.view.addSubview(orderview)
        orderview.hidden = true
        orderview.delegate = self
        orderview.dataSource = self
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
        orderview.addHeaderWithTarget(self, action: "pullrefreshData")
        /**添加通知监听**/
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "refreshData", name: "reloadOrders", object: nil)
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
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.tintColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        self.tabBarController?.tabBar.translucent = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        if fromcheckout {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "poptocart")
        }
        activity.startAnimating()
        NSThread.detachNewThreadSelector("refreshData", toTarget: self, withObject: nil)
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
        ordergroupList = [Orderdatamodel]()
        paysnList = [String:String]()
        paysnIndex = 1
        payment = 0
        loadData()
        load_payment_list()
        if ordergroupList.isEmpty {
            orderview.hidden = true
            let nothing = UILabel(frame: CGRect(x: (ScreenW-200)/2, y: self.view.frame.height/3, width: 200, height: 30))
            nothing.font = UIFont.systemFontOfSize(16)
            nothing.textColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
            nothing.text = "这里空空如也哦~"
            nothing.textAlignment = NSTextAlignment.Center
            self.view.addSubview(nothing)
        } else {
            orderview.hidden = false
            orderview.reloadData()
        }
    }
    
    func loadData() {
        let key = getkey()
        let paramstr = NSString(format: "key=%@", key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_order&op=order_list")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if respdata == nil {
            activity.stopAnimating()
            orderview.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let order_group_array: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")!.objectForKey("order_group_list")
        if let ordergroup = order_group_array as? NSArray {
            for val in ordergroup {
                let group = val as! NSDictionary
                let newordergroup = Orderdatamodel()
                //下单时间
                let timedata = Ordercellmodel()
                timedata.type = "addtime"
                timedata.data = group.objectForKey("add_time") as! String
                newordergroup.orderList.append(timedata)
                let orderlist = group.objectForKey("order_list") as! NSArray
                for orderval in orderlist {
                    let orderinfo = orderval as! NSDictionary
                    //店铺名称
                    let neworderhead = Orderheadmodel()
                    neworderhead.storename = orderinfo.objectForKey("store_name") as! String
                    neworderhead.ordersn = orderinfo.objectForKey("order_sn") as! String
                    neworderhead.status = orderinfo.objectForKey("state_desc") as! String
                    let islockstr: AnyObject! = orderinfo.objectForKey("if_lock")
                    if let il = islockstr as? Int {
                        if il == 1 {
                            neworderhead.islock = true
                        }
                    }
                    let headdata = Ordercellmodel()
                    headdata.type = "storehead"
                    headdata.data = neworderhead
                    newordergroup.orderList.append(headdata)
                    //商品信息
                    let goodslist: AnyObject! = orderinfo.objectForKey("extend_order_goods")
                    var num = 0
                    if let gl = goodslist as? NSArray {
                        for goodsval in gl {
                            let newgoods = Goodsmodel()
                            let goodsinfo = goodsval as! NSDictionary
                            newgoods.goods_name = goodsinfo.objectForKey("goods_name") as! String
                            newgoods.goods_image = goodsinfo.objectForKey("goods_image_url") as! String
                            newgoods.goods_num = goodsinfo.objectForKey("goods_num") as! String
                            newgoods.goods_price = goodsinfo.objectForKey("goods_price") as! String
                            newgoods.goods_id = goodsinfo.objectForKey("goods_id") as! String
                            let goodsdata = Ordercellmodel()
                            goodsdata.type = "goodsinfo"
                            goodsdata.data = newgoods
                            newordergroup.orderList.append(goodsdata)
                            num++
                        }
                    }
                    //结算小计
                    let neworderfoot = Orderfootmodel()
                    neworderfoot.amount = orderinfo.objectForKey("order_amount") as! String
                    neworderfoot.shipfee = orderinfo.objectForKey("shipping_fee") as! String
                    neworderfoot.order_id = orderinfo.objectForKey("order_id") as! String
                    let iscancel: AnyObject! = orderinfo.objectForKey("if_cancel")
                    let isconfirm: AnyObject! = orderinfo.objectForKey("if_receive")
                    let isdeliver: AnyObject! = orderinfo.objectForKey("if_deliver")
                    if let ic = iscancel as? Int {
                        if ic == 1 {
                            neworderfoot.ccbtn = true
                        }
                    }
                    if let icf = isconfirm as? Int {
                        if icf == 1 {
                            neworderfoot.cfbtn = true
                        }
                    }
                    if let id = isdeliver as? Int {
                        if id == 1 {
                            neworderfoot.svbtn = true
                        }
                    }
                    neworderfoot.allnum = String(num)
                    let footdata = Ordercellmodel()
                    footdata.type = "storefoot"
                    footdata.data = neworderfoot
                    newordergroup.orderList.append(footdata)
                }
                //支付按钮
                if (group.objectForKey("pay_amount") != nil) {
                    let payamount = group.objectForKey("pay_amount") as! Float
                    if payamount > 0 {
                        let paybtn = Ordercellmodel()
                        paybtn.type = "pay"
                        var payinfo = [String]()
                        payinfo.append("订单支付(￥" + String(payamount) + "元)")
                        let paysn = group.objectForKey("pay_sn") as! String
                        paysnList[String(paysnIndex)] = paysn
                        payinfo.append(String(paysnIndex))
                        paybtn.data = payinfo
                        paysnIndex++
                        newordergroup.orderList.append(paybtn)
                    }
                }
                ordergroupList.append(newordergroup)
            }
        } else {
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
        }
        orderview.headerEndRefreshing()
        activity.stopAnimating()
    }
    
    /**tablview相关设置**/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ordergroupList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordergroupList[section].orderList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 0
        let data = ordergroupList[indexPath.section].orderList[indexPath.row] as Ordercellmodel
        let type = data.type
        switch type {
            case "addtime":
                height = 40
            case "storehead":
                height = 60
            case "goodsinfo":
                height = 80
            case "storefoot":
                height = 110
            case "pay":
                height = 40
            default:
                height = 60
        }
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = ordergroupList[indexPath.section].orderList[indexPath.row] as Ordercellmodel
        let type = data.type
        var nibname = ""
        var cellID = ""
        if type == "addtime" {
            nibname = "OrderAddtimeCell"
            cellID = "OrderAddtimeCellID"
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! OrderAddtimeCell
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let addtime_str = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: data.data.doubleValue))
            cell.addtime.text = "下单时间：" + addtime_str
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "storehead" {
            if ScreenW == 320 {
                nibname = "OrderTitltCell"
                cellID = "OrderTitleCellID"
            }
            if ScreenW == 375 {
                nibname = "OrderTitltCell375"
                cellID = "OrderTitleCellID375"
            }
            if ScreenW == 414 {
                nibname = "OrderTitltCell414"
                cellID = "OrderTitleCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! OrderTitltCell
            let headinfo = data.data as? Orderheadmodel
            cell.storename.text = headinfo?.storename
            cell.ordersn.text = headinfo?.ordersn
            cell.status.text = headinfo?.status
            if headinfo?.status == "已取消" {
                cell.status.textColor = UIColor.lightGrayColor()
            } else {
                cell.status.textColor = UIColor(red: 255/255, green: 127/255, blue: 0/255, alpha: 1.0)
            }
            if headinfo?.islock == true {
                cell.lock.hidden = false
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "storefoot" {
            if ScreenW == 320 {
                nibname = "OrderFooterCell"
                cellID = "OrderFooterCellID"
            }
            if ScreenW == 375 {
                nibname = "OrderFooterCell375"
                cellID = "OrderFooterCellID375"
            }
            if ScreenW == 414 {
                nibname = "OrderFooterCell414"
                cellID = "OrderFooterCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! OrderFooterCell
            let footinfo = data.data as? Orderfootmodel
            cell.allnum.text = "共" + footinfo!.allnum + "件商品"
            cell.shipfee.text = "运费：￥" + footinfo!.shipfee
            cell.amount.text = "合计：￥" + footinfo!.amount
            cell.cancelbtn.layer.borderWidth = 1
            cell.cancelbtn.layer.cornerRadius = 3
            if footinfo?.ccbtn == true {//取消订单
                cell.cancelbtn.textColor = UIColor.blackColor()
                cell.cancelbtn.layer.borderColor = UIColor.blackColor().CGColor
                cell.cancelbtn.tag = Int(footinfo!.order_id)!
                cell.cancelbtn.userInteractionEnabled = true
                cell.cancelbtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cancelorder:"))
            } else {
                cell.cancelbtn.textColor = UIColor.lightGrayColor()
                cell.cancelbtn.layer.borderColor = UIColor.lightGrayColor().CGColor
                cell.cancelbtn.userInteractionEnabled = false
            }
            cell.confirmbtn.layer.borderWidth = 1
            cell.confirmbtn.layer.cornerRadius = 3
            if footinfo?.cfbtn == true {//确认收货
                cell.confirmbtn.textColor = UIColor.blackColor()
                cell.confirmbtn.layer.borderColor = UIColor.blackColor().CGColor
                cell.confirmbtn.tag = Int(footinfo!.order_id)!
                cell.confirmbtn.userInteractionEnabled = true
                cell.confirmbtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "confirmorder:"))
            } else {
                cell.confirmbtn.textColor = UIColor.lightGrayColor()
                cell.confirmbtn.layer.borderColor = UIColor.lightGrayColor().CGColor
                cell.confirmbtn.userInteractionEnabled = false
            }
            cell.shipviewbtn.layer.borderWidth = 1
            cell.shipviewbtn.layer.cornerRadius = 3
            if footinfo?.svbtn == true {//查看物流
                cell.shipviewbtn.textColor = UIColor.blackColor()
                cell.shipviewbtn.layer.borderColor = UIColor.blackColor().CGColor
                cell.shipviewbtn.tag = Int(footinfo!.order_id)!
                cell.shipviewbtn.userInteractionEnabled = true
                cell.shipviewbtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "shipinfo:"))
            } else {
                cell.shipviewbtn.textColor = UIColor.lightGrayColor()
                cell.shipviewbtn.layer.borderColor = UIColor.lightGrayColor().CGColor
                cell.shipviewbtn.userInteractionEnabled = false
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "pay" {
            if ScreenW == 320 {
                nibname = "OrderPayCell"
                cellID = "OrderPayCellID"
            }
            if ScreenW == 375 {
                nibname = "OrderPayCell375"
                cellID = "OrderPayCellID375"
            }
            if ScreenW == 414 {
                nibname = "OrderPayCell414"
                cellID = "OrderPayCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! OrderPayCell
            let payinfo = data.data as? NSArray
            cell.payinfo.text = payinfo!.objectAtIndex(0) as? String
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let paysnIndex = payinfo!.objectAtIndex(1) as? String
            cell.tag = Int(paysnIndex!)!
            cell.userInteractionEnabled = true
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pay:"))
            return cell
        } else {
            if ScreenW == 320 {
                nibname = "OrderGoodsCell"
                cellID = "OrderGoodsCellID"
            }
            if ScreenW == 375 {
                nibname = "OrderGoodsCell375"
                cellID = "OrderGoodsCellID375"
            }
            if ScreenW == 414 {
                nibname = "OrderGoodsCell414"
                cellID = "OrderGoodsCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! OrderGoodsCell
            let goodsinfo = data.data as? Goodsmodel
            cell.goodsname.text = goodsinfo?.goods_name
            cell.goodsprice.text = "价格：￥" + goodsinfo!.goods_price
            cell.buynum.text = "商品数目：" + goodsinfo!.goods_num
            /**图片的延时加载**/
            let cellimgdata: NSArray = [cell, goodsinfo!.goods_image]
            NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    func uploadImageForCellAtIndexPath(cellimgdata: NSArray) {
        let picurl = cellimgdata.objectAtIndex(1) as! String
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
        let cell = cellimgdata.objectAtIndex(0) as! OrderGoodsCell
        cell.goodspic.image = img
    }
    
    /**取消订单**/
    func cancelorder(recognizer: UITapGestureRecognizer) {
        let alert = UIAlertView(title: "提示", message: "要取消该订单吗？", delegate: self, cancelButtonTitle: "否", otherButtonTitles: "是")
        alert.tag = 1
        exc_orderid = String(recognizer.view!.tag)
        alert.show()
    }
    
    /**确认收货**/
    func confirmorder(recognizer: UITapGestureRecognizer) {
        let alert = UIAlertView(title: "提示", message: "要确认收货吗？", delegate: self, cancelButtonTitle: "否", otherButtonTitles: "是")
        alert.tag = 2
        exc_orderid = String(recognizer.view!.tag)
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if btnlabel == "是" {
            let key = getkey()
            let paramstr = NSString(format: "key=%@&order_id=%@", key, exc_orderid)
            let paramstrlen = paramstr.length
            let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let request = NSMutableURLRequest()
            if alertView.tag == 1 {
                request.URL = NSURL(string: API_URL + "index.php?act=member_order&op=order_cancel")
            }
            if alertView.tag == 2 {
                request.URL = NSURL(string: API_URL + "index.php?act=member_order&op=order_receive")
            }
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postdata
            let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let data_array: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")
            if let datas = data_array as? String {
                if datas == "1" {
                    tipstr.text = "操作成功"
                    tipimg.image = UIImage(named: "success.png")
                    tipshow.hidden = false
                    refreshData()
                }
            } else {
                tipstr.text = "操作失败"
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
    
    /**查看物流**/
    func shipinfo(recognizer: UITapGestureRecognizer) {
        let order_id = String(recognizer.view!.tag)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let shipinfocontroller = sb.instantiateViewControllerWithIdentifier("ShipInfoViewID") as! ShipInfoViewController
        shipinfocontroller.order_id = order_id
        shipinfocontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(shipinfocontroller, animated: true)
    }
    
    /**在线支付**/
    func pay(recognizer: UITapGestureRecognizer) {
        if payment == 0 {
            let alert = UIAlertView(title: "提示", message: "暂无支持的在线支付方式", delegate: self, cancelButtonTitle: "好")
            alert.show()
        } else {
            let paysnIndexstr = String(recognizer.view!.tag)
            pay_sn = paysnList[paysnIndexstr] as String!
            if payment == 1 {
                let paysheet = UIActionSheet(title: "请选择支付方式", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "支付宝")
                paysheet.showInView(self.view)
            }
            if payment == 2 {
                let paysheet = UIActionSheet(title: "请选择支付方式", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "微信支付")
                paysheet.showInView(self.view)
            }
            if payment == 3 {
                let paysheet = UIActionSheet(title: "请选择支付方式", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "支付宝", "微信支付")
                paysheet.showInView(self.view)
            }
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if payment == 1 && buttonIndex == 1 {
            alipay();
        }
        if payment == 2 {
            wxpay();
        }
        if payment == 3 {
            if buttonIndex == 1 {
                alipay();
            }
            if buttonIndex == 2 {
                wxpay();
            }
        }
    }
    
    //支付宝
    func alipay() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let paycontroller = sb.instantiateViewControllerWithIdentifier("PayViewID") as! PayViewController
        paycontroller.pay_sn = pay_sn
        paycontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(paycontroller, animated: true)
    }
    
    //微信支付
    func wxpay() {
        activity.startAnimating()
        let key = getkey()
        //NSLog("pay_sn:%@, key:%@", pay_sn, key)
        let paramstr = NSString(format: "key=%@&pay_sn=%@", key, pay_sn)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_payment&op=wx_app_pay")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
//        let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments, error: nil)
//        NSLog("%@", toString(json))
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        activity.stopAnimating()
        if data_array.objectForKey("error") != nil {
            let alert = UIAlertView(title: "提示", message: "微信支付失败", delegate: self, cancelButtonTitle: "知道了")
            alert.show()
        } else {
            var appid = data_array.objectForKey("appid") as! String
            let noncestr = data_array.objectForKey("noncestr") as! String
            let package = data_array.objectForKey("package") as! String
            let partnerid = data_array.objectForKey("partnerid") as! String
            let prepayid = data_array.objectForKey("prepayid") as! String
            let sign = data_array.objectForKey("sign") as! String
            let timestamp = data_array.objectForKey("timestamp") as! Int
            //NSLog("%@,%@,%@,%@,%@,%d", noncestr, package, partnerid, prepayid, sign, timestamp)
            let wpreq = PayReq()
            //wpreq.openID = appid
            wpreq.partnerId = partnerid
            wpreq.prepayId = prepayid
            wpreq.package = package
            wpreq.nonceStr = noncestr
            wpreq.timeStamp = UInt32(timestamp)
            wpreq.sign = sign
            WXApi.sendReq(wpreq)
        }
    }
    
    /**返回根页面**/
    func poptocart() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /**调取在线支付方式**/
    func load_payment_list() {
        
        payment = 0
        return
//liubwtest
//   暂时强制认定为只支持支付宝
        
//        let key = getkey()
//        let paramstr = NSString(format: "key=%@", key)
//        let paramstrlen = paramstr.length
//        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//        let request = NSMutableURLRequest()
//        request.URL = NSURL(string: API_URL + "index.php?act=member_payment&op=payment_list")
//        request.HTTPMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
//        request.HTTPBody = postdata
//        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
//        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
//        if data_array.objectForKey("error") != nil {
//            payment = 0
//        } else {
//            let payment_list = data_array.objectForKey("payment_list") as! NSArray
//            var alipay = false
//            var wxpay = false
//            for i in payment_list {
//                let paystr = i as! String
//                if paystr == "alipay" {
//                    alipay = true
//                }
//                if paystr == "wxpay" {
//                    wxpay = true
//                }
//            }
//            if alipay && !wxpay {
//                payment = 1
//            }
//            if !alipay && wxpay {
//                payment = 2
//            }
//            if alipay && wxpay {
//                payment = 3
//            }
//        }
    }
}