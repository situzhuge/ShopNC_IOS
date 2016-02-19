//
//  BuyViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/10.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate {
    var system_error = false
    var ifcart = false//是否为购物车结算
    var iffcode = false//是否为F码商品
    var ifxvni = false//是否为虚拟商品
    var xvni_num = 0//虚拟商品购买数量
    var choosegoods = ""//结算商品数据字符串 213|1,100309|1
    var activity: UIActivityIndicatorView!
    var ScreenW: CGFloat!
    var checkview = UITableView()
    var allheight: CGFloat = 0
    var allamount: UILabel!
    var allgoodsprice = 0.00//全部商品总额
    var allprice = 0.00//订单总额
    var allshipfee = 0.00//全部运费
    var reload = true
    //代金券选择器
    var voucherview: UIView!
    var voucherpicker: UIPickerView!
    var allvoucher = [String:[Vouchermodel]]()
    var voucherList = [Vouchermodel]()
    var choosevoucher = [String:Vouchermodel]()
    var summarycellList = [String: PaySummaryCell]()
    //结算信息
    var datacell = [Ordercellmodel]()
    var address = Addressmodel()
    var invoice = Invoicemodel()
    var address_id = ""
    var freight_hash = ""
    var city_id = ""
    var area_id = ""
    var offpay_hash = ""
    var offpay_hash_batch = ""
    var paytypecell: PayTypeCell!
    var invcell: UITableViewCell!
    var available_predeposit = "0.00"
    var smcellListHelper = [String:Double]()//运费
    var smcellListHelper2 = [String:Double]()//店铺商品小计
    var smcellListHelper3 = [String:Double]()//店铺满即送
    var ori = true
    var vat_hash = ""
    var invoice_id = ""
    var paytype = "online"
    var pdpaycell: PDPayCell!
    var usepd = "0"
    var pdpwdtext: UITextField!
    var fcodetext: UITextField!
    var mobiletext: UITextField!
    var voucherstr = ""
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "确认订单"
        ScreenW = self.view.frame.width
        checkview.frame = CGRect(x: 0, y: 0, width: ScreenW, height: self.view.frame.height-64)
        checkview.hidden = true
        checkview.delegate = self
        checkview.dataSource = self
        self.view.addSubview(checkview)
        /**底部操作条**/
        let bbview = UIView(frame: CGRect(x: 0, y: self.view.frame.height-114, width: ScreenW, height: 50))
        bbview.backgroundColor = UIColor.clearColor()
        self.view.addSubview(bbview)
        let uinfobg = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 50))
        uinfobg.image = UIImage(named: "uinfobg.png")
        bbview.addSubview(uinfobg)
        let submitBtn = UIButton(frame: CGRect(x: ScreenW-130, y: 5, width: 120, height: 40))
        submitBtn.backgroundColor = UIColor(red: 196/255, green: 0/255, blue: 4/255, alpha: 1.0)
        submitBtn.layer.cornerRadius = 3
        submitBtn.addTarget(self, action: "submit", forControlEvents: UIControlEvents.TouchUpInside)
        submitBtn.setTitle("提交订单", forState: UIControlState.Normal)
        submitBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        submitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        bbview.addSubview(submitBtn)
        allamount = UILabel(frame: CGRect(x: ScreenW-290, y: 10, width: 150, height: 30))
        allamount.textAlignment = NSTextAlignment.Right
        allamount.textColor = UIColor.whiteColor()
        allamount.font = UIFont.systemFontOfSize(18)
        allamount.text = "￥0.00元"
        bbview.addSubview(allamount)
        /**代金券选择器**/
        voucherview = UIView(frame: CGRect(x: 0, y: self.view.frame.height-300, width: ScreenW, height: 300))
        voucherview.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
        self.view.addSubview(voucherview)
        let areabtn = UILabel(frame: CGRect(x: ScreenW-70, y: 10, width: 60, height: 30))
        areabtn.text = "完成"
        areabtn.textAlignment = NSTextAlignment.Center
        areabtn.font = UIFont.systemFontOfSize(16)
        areabtn.layer.borderColor = UIColor.blackColor().CGColor
        areabtn.layer.borderWidth = 1
        areabtn.layer.cornerRadius = 3
        areabtn.userInteractionEnabled = true
        areabtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addvoucherinfo"))
        voucherview.addSubview(areabtn)
        voucherpicker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        voucherpicker.showsSelectionIndicator = true
        voucherpicker.dataSource = self
        voucherpicker.delegate = self
        voucherview.addSubview(voucherpicker)
        voucherview.hidden = true
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
        /**添加通知监听**/
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "addressUpdate", name: "AddressUpdate", object: nil)
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        UIView.setAnimationsEnabled(true)
        if reload {
            OrderRefresh()
        } else {
            reload = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**加载数据**/
    func OrderRefresh() {
        /**清空数据**/
        allheight = 0
        allgoodsprice = 0.00//全部商品总额
        allprice = 0.00//订单总额
        allshipfee = 0.00//全部运费
        //代金券选择器
        allvoucher = [String:[Vouchermodel]]()
        voucherList = [Vouchermodel]()
        choosevoucher = [String:Vouchermodel]()
        summarycellList = [String: PaySummaryCell]()
        //结算信息
        datacell = [Ordercellmodel]()
        address = Addressmodel()
        invoice = Invoicemodel()
        address_id = ""
        freight_hash = ""
        city_id = ""
        area_id = ""
        offpay_hash = ""
        offpay_hash_batch = ""
        available_predeposit = "0.00"
        smcellListHelper = [String:Double]()//运费
        smcellListHelper2 = [String:Double]()//店铺商品小计
        smcellListHelper3 = [String:Double]()//店铺满即送
        ori = true
        vat_hash = ""
        invoice_id = ""
        paytype = "online"
        usepd = "0"
        voucherstr = ""
        activity.startAnimating()
        NSThread.detachNewThreadSelector("loadData", toTarget: self, withObject: nil)
    }
    
    func loadData() {
        let key = getkey()
        if key == "null" {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "请您先登录", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "好")
            alert.tag = 2
            alert.show()
            return
        }
        if ifxvni {
            let paramstr = NSString(format: "key=%@&goods_id=%@&quantity=%@", key, choosegoods, String(xvni_num))
            let paramstrlen = paramstr.length
            let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: API_URL + "index.php?act=member_vr_buy&op=buy_step2")
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postdata
            let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            if respdata == nil {
                activity.stopAnimating()
                let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "知道了")
                alert.show()
                return
            }
            let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
            if data_array.objectForKey("error") != nil {
                activity.stopAnimating()
                let alert = UIAlertView(title: "提示", message: "该商品当前无法购买", delegate: self, cancelButtonTitle: "知道了")
                alert.show()
                //输出错误信息
                let err = data_array.objectForKey("error") as! String
                NSLog("%@", err)
                return
            } else {
                //手机号码
                let fcodecelldata = Ordercellmodel()
                fcodecelldata.type = "mobile"
                datacell.append(fcodecelldata)
                allheight += 50
                //支付方式
                let paycelldata = Ordercellmodel()
                paycelldata.type = "paytype"
                datacell.append(paycelldata)
                allheight += 50
                let member_info = data_array.objectForKey("member_info") as! NSDictionary
                let pdvalue: AnyObject! = member_info.objectForKey("available_predeposit")
                if let pd = pdvalue as? String {
                    available_predeposit = pd
                }
                //店铺信息
                let store_info = data_array.objectForKey("store_info") as! NSDictionary
                let storecelldata = Ordercellmodel()
                storecelldata.type = "storename"
                storecelldata.data = store_info.objectForKey("store_name") as! String
                datacell.append(storecelldata)
                allheight += 50
                //商品信息
                let goods_info = data_array.objectForKey("goods_info") as! NSDictionary
                let newgoods = Goodsmodel()
                newgoods.goods_name = goods_info.objectForKey("goods_name") as! String
                newgoods.goods_image = goods_info.objectForKey("goods_image_url") as! String
                let goodspromprice = goods_info.objectForKey("goods_promotion_price") as! String
                let goodsprice = goods_info.objectForKey("goods_price") as! String
                newgoods.goods_price = goodspromprice != "0.00" ? goodspromprice : goodsprice
                newgoods.goods_id = goods_info.objectForKey("goods_id") as! String
                let num = goods_info.objectForKey("quantity") as! Int
                newgoods.goods_num = String(num)
                let goodsdata = Ordercellmodel()
                goodsdata.type = "goodsinfo"
                goodsdata.data = newgoods
                datacell.append(goodsdata)
                allheight += 80
                //结算信息
                let summary = Summarymodel()
                summary.store_id = key as String
                summary.total = goods_info.objectForKey("goods_total") as! String
                let allpricestr = goods_info.objectForKey("goods_total") as! NSString
                allprice = allpricestr.doubleValue
                let summarycelldata = Ordercellmodel()
                summarycelldata.type = "summary"
                summarycelldata.data = summary
                datacell.append(summarycelldata)
                allheight += 105
                //预存款支付
                let pdpaycelldata = Ordercellmodel()
                pdpaycelldata.type = "pdpay"
                datacell.append(pdpaycelldata)
                let pdinputcelldata = Ordercellmodel()
                pdinputcelldata.type = "pdinput"
                datacell.append(pdinputcelldata)
                allheight += 100
            }
        } else {
            var paramstr: NSString!
            if ifcart {
                paramstr = NSString(format: "key=%@&cart_id=%@&ifcart=1", key, choosegoods)
            } else {
                paramstr = NSString(format: "key=%@&cart_id=%@", key, choosegoods)
            }
            let paramstrlen = paramstr.length
            let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: API_URL + "index.php?act=member_buy&op=buy_step1")
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postdata
            let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            if respdata == nil {
                activity.stopAnimating()
                let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "知道了")
                alert.show()
                return
            }
            let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
            if data_array.objectForKey("error") != nil {
                activity.stopAnimating()
                let alert = UIAlertView(title: "提示", message: "该商品当前无法购买", delegate: self, cancelButtonTitle: "知道了")
                alert.show()
                //输出错误信息
                let err = data_array.objectForKey("error") as! String
                NSLog("%@", err)
                return
            } else {
                //收货地址信息
                let address_info_data: AnyObject! = data_array.objectForKey("address_info")
                if let address_info = address_info_data as? NSDictionary {
                    address.address_id = address_info.objectForKey("address_id") as! String
                    address.area_info = address_info.objectForKey("area_info") as! String
                    address.address = address_info.objectForKey("address") as! String
                    address.true_name = address_info.objectForKey("true_name") as! String
                    address.tel_phone = address_info.objectForKey("tel_phone") as! String
                    address.mob_phone = address_info.objectForKey("mob_phone") as! String
                    let adrcelldata = Ordercellmodel()
                    adrcelldata.type = "address"
                    adrcelldata.data = address
                    datacell.append(adrcelldata)
                    address_id = address_info.objectForKey("address_id") as! String
                    freight_hash = data_array.objectForKey("freight_hash") as! String
                    city_id = address_info.objectForKey("city_id") as! String
                    area_id = address_info.objectForKey("area_id") as! String
                    addressUpdate()
                    allheight += 120
                } else {
                    activity.stopAnimating()
                    let alert = UIAlertView(title: "提示", message: "请先设置收货地址", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "好")
                    alert.tag = 1
                    alert.show()
                    return
                }
                //支付方式
                var paytype = [String:String]()
                let payoff: AnyObject! = data_array.objectForKey("address_info")
                if let py = payoff as? Int {
                    if py == 1 {
                        paytype["payoff"] = "yes"
                    }
                }
                let pdvalue: AnyObject! = data_array.objectForKey("available_predeposit")
                if let pd = pdvalue as? String {
                    available_predeposit = pd
                }
                let paycelldata = Ordercellmodel()
                paycelldata.type = "paytype"
                paycelldata.data = paytype
                datacell.append(paycelldata)
                allheight += 50
                //发票信息
                let inv_info = data_array.objectForKey("inv_info") as! NSDictionary
                if inv_info.objectForKey("content") != nil {
                    invoice.inv_id = "0"
                    invoice.inv_title = ""
                    invoice.inv_content = inv_info.objectForKey("content") as! String
                } else {
                    invoice.inv_id = inv_info.objectForKey("inv_id") as! String
                    invoice.inv_title = inv_info.objectForKey("inv_title") as! String
                    invoice.inv_content = inv_info.objectForKey("inv_content") as! String
                    invoice_id = inv_info.objectForKey("inv_id") as! String
                }
                let invcelldata = Ordercellmodel()
                invcelldata.type = "invoice"
                invcelldata.data = invoice
                datacell.append(invcelldata)
                vat_hash = data_array.objectForKey("vat_hash") as! String
                allheight += 50
                //店铺商品结算
                let store_cart_list = data_array.objectForKey("store_cart_list") as! NSDictionary
                for (key,val) in store_cart_list {
                    let cartinfo = val as! NSDictionary
                    //店铺名称
                    let storecelldata = Ordercellmodel()
                    storecelldata.type = "storename"
                    storecelldata.data = cartinfo.objectForKey("store_name") as! String
                    datacell.append(storecelldata)
                    allheight += 50
                    //商品信息
                    var ship_fee = 0.00
                    let goods_list = cartinfo.objectForKey("goods_list") as! NSArray
                    for i in goods_list {
                        let goodsinfo = i as! NSDictionary
                        let newgoods = Goodsmodel()
                        newgoods.goods_name = goodsinfo.objectForKey("goods_name") as! String
                        newgoods.goods_image = goodsinfo.objectForKey("goods_image_url") as! String
                        let goodsnumstr: AnyObject! = goodsinfo.objectForKey("goods_num")
                        newgoods.goods_num = String(goodsnumstr)
                        let goodspricestr: AnyObject! = goodsinfo.objectForKey("goods_price")
                        newgoods.goods_price = String(goodspricestr)
                        let goodsidstr: AnyObject! = goodsinfo.objectForKey("goods_id")
                        newgoods.goods_id = String(goodsidstr)
                        let goodsdata = Ordercellmodel()
                        goodsdata.type = "goodsinfo"
                        goodsdata.data = newgoods
                        datacell.append(goodsdata)
                        allheight += 80
                        //累加运费
                        if goodsinfo.objectForKey("goods_freight") != nil {
                            let ship = goodsinfo.objectForKey("goods_freight") as! NSString
                            ship_fee += ship.doubleValue
                        }
                    }
                    //结算信息
                    let summary = Summarymodel()
                    summary.store_id = key as! String
                    //A、店铺结算总额
                    summary.total = cartinfo.objectForKey("store_goods_total") as! String
                    let totalnum = summary.total as NSString
                    allprice += totalnum.doubleValue
                    allgoodsprice += totalnum.doubleValue
                    smcellListHelper2[summary.store_id] = totalnum.doubleValue
                    //B、满即送
                    let newms = Msmodel()
                    let msinfo: AnyObject! = cartinfo.objectForKey("store_mansong_rule_list")
                    var msprice = 0.00
                    if let ms = msinfo as? NSDictionary {
                        newms.price = ms.objectForKey("price") as! String
                        newms.discount = ms.objectForKey("discount") as! String
                        newms.desc = ms.objectForKey("desc") as! String
                        let discountnum = newms.discount as NSString
                        allprice -= discountnum.doubleValue
                        allgoodsprice -= discountnum.doubleValue
                        msprice = discountnum.doubleValue
                    }
                    summary.msinfo = newms
                    smcellListHelper3[summary.store_id] = msprice
                    //C、代金券
                    let vc_list: AnyObject! = cartinfo.objectForKey("store_voucher_list")
                    if let vc = vc_list as? NSDictionary {
                        allvoucher[summary.store_id] = [Vouchermodel]()
                        for (key,val) in vc {
                            let voucher = val as! NSDictionary
                            let newvc = Vouchermodel()
                            newvc.voucher_id = voucher.objectForKey("voucher_id") as! String
                            newvc.voucher_price = voucher.objectForKey("voucher_price") as! String
                            newvc.title = voucher.objectForKey("voucher_title") as! String
                            newvc.store_id = voucher.objectForKey("voucher_store_id") as! String
                            newvc.voucher_t_id = voucher.objectForKey("voucher_t_id") as! String
                            allvoucher[summary.store_id]!.append(newvc)
                            summary.vouchernum += 1
                        }
                    }
                    //D、运费
                    let freight = cartinfo.objectForKey("freight") as! String
                    summary.freight = Int(freight)!
                    summary.ship_fee = ship_fee
                    if summary.freight != 0 {
                        allprice += ship_fee
                        allshipfee += ship_fee
                    }
                    smcellListHelper[summary.store_id] = ship_fee
                    //E、店铺信息
                    let summarycelldata = Ordercellmodel()
                    summarycelldata.type = "summary"
                    summarycelldata.data = summary
                    datacell.append(summarycelldata)
                    allheight += 105
                }
                //预存款支付
                let pdpaycelldata = Ordercellmodel()
                pdpaycelldata.type = "pdpay"
                datacell.append(pdpaycelldata)
                let pdinputcelldata = Ordercellmodel()
                pdinputcelldata.type = "pdinput"
                datacell.append(pdinputcelldata)
                allheight += 100
                //F码
                if iffcode {
                    let fcodecelldata = Ordercellmodel()
                    fcodecelldata.type = "fcode"
                    datacell.append(fcodecelldata)
                    allheight += 50
                }
            }
        }
        activity.stopAnimating()
        checkview.reloadData()
        checkview.hidden = false
        allamount.text = "￥" + String(allprice) + "元"
    }
    
    /**tablview相关设置**/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { 
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datacell.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 0
        let data = datacell[indexPath.row] as Ordercellmodel
        let type = data.type
        switch type {
        case "address":
            height = 120
        case "goodsinfo":
            height = 80
        case "summary":
            height = 105
        case "pdinput":
            height = iffcode ? 50 : (50+216)
        case "fcode":
            height = 55+216
        default:
            height = 50
        }
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = datacell[indexPath.row] as Ordercellmodel
        let type = data.type
        var nibname = ""
        var cellID = ""
        if type == "address" {
            if ScreenW == 320 {
                nibname = "AddressInfoCell"
                cellID = "AddressInfoCellID"
            }
            if ScreenW == 375 {
                nibname = "AddressInfoCell375"
                cellID = "AddressInfoCellID375"
            }
            if ScreenW == 414 {
                nibname = "AddressInfoCell414"
                cellID = "AddressInfoCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! AddressInfoCell
            let adrinfo = data.data as? Addressmodel
            cell.addressinfo.text = adrinfo?.address
            cell.areainfo.text = adrinfo?.area_info
            cell.contactinfo.text = adrinfo!.true_name + " " + adrinfo!.mob_phone + " " + adrinfo!.tel_phone
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "paytype" {
            nibname = "PayTypeCell"
            cellID = "PayTypeCellID"
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! PayTypeCell
            let payinfo = data.data as? NSDictionary
            if payinfo?.objectForKey("payoff") == nil {
                cell.payoffline.hidden = true
                cell.offlinelabel.hidden = true
            } else {
                cell.payoffline.hidden = false
                cell.offlinelabel.hidden = false
            }
            cell.payonline.tag = 1
            cell.payonline.userInteractionEnabled = true
            cell.payonline.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "switchpaytype:"))
            cell.payoffline.tag = 2
            cell.payoffline.userInteractionEnabled = true
            cell.payoffline.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "switchpaytype:"))
            paytypecell = cell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "invoice" {
            var nibregistered = false
            if !nibregistered {
                tableView.registerClass(UITableViewCell().classForCoder, forCellReuseIdentifier: "InvListCellID")
                nibregistered = true
            }
            let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "InvListCellID")
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let invinfo = data.data as? Invoicemodel
            if invinfo!.inv_id == "0" {
                cell.textLabel!.text = invinfo!.inv_content
            } else {
                cell.textLabel!.text = "普通发票 " + invinfo!.inv_title + " " + invinfo!.inv_content
            }
            cell.textLabel!.font = UIFont.systemFontOfSize(14)
            invcell = cell
            return cell
        } else if type == "storename" {
            nibname = "StoreNameCell"
            cellID = "StoreNameCellID"
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! StoreNameCell
            let storename = data.data as? String
            cell.storename.text = storename
            cell.storename.font = UIFont.systemFontOfSize(14)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "goodsinfo" {
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
        } else if type == "pdpay" {
            nibname = "PDPayCell"
            cellID = "PDPayCellID"
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! PDPayCell
            cell.yes.tag = 1
            cell.yes.userInteractionEnabled = true
            cell.yes.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "switchpd:"))
            cell.no.tag = 0
            cell.no.userInteractionEnabled = true
            cell.no.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "switchpd:"))
            cell.money.text = "(￥" + available_predeposit + ")"
            pdpaycell = cell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "pdinput" {
            nibname = "InputCell"
            cellID = "InputCellID"
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! InputCell
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
            cell.inputfield.frame = CGRect(x: 10, y: 5, width: 300, height: 40)
            cell.inputfield.placeholder = "请输入预存款支付密码"
            cell.inputfield.font = UIFont.systemFontOfSize(14)
            cell.inputfield.clearButtonMode = UITextFieldViewMode.WhileEditing
            cell.inputfield.backgroundColor = UIColor.whiteColor()
            cell.inputfield.borderStyle = UITextBorderStyle.RoundedRect
            cell.inputfield.leftView = padding
            cell.inputfield.tag = 1
            cell.inputfield.autocapitalizationType = UITextAutocapitalizationType.None
            cell.inputfield.delegate = self
            cell.inputfield.secureTextEntry = true
            cell.inputfield.returnKeyType = UIReturnKeyType.Done
            pdpwdtext = cell.inputfield
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "fcode" {
            nibname = "InputCell"
            cellID = "InputCellID"
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! InputCell
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
            cell.inputfield.frame = CGRect(x: 10, y: 5, width: 300, height: 40)
            cell.inputfield.placeholder = "请输入F码"
            cell.inputfield.font = UIFont.systemFontOfSize(14)
            cell.inputfield.clearButtonMode = UITextFieldViewMode.WhileEditing
            cell.inputfield.backgroundColor = UIColor.whiteColor()
            cell.inputfield.borderStyle = UITextBorderStyle.RoundedRect
            cell.inputfield.leftView = padding
            cell.inputfield.tag = 2
            cell.inputfield.autocapitalizationType = UITextAutocapitalizationType.None
            cell.inputfield.delegate = self
            cell.inputfield.returnKeyType = UIReturnKeyType.Done
            cell.inputfield.keyboardType = UIKeyboardType.ASCIICapable
            fcodetext = cell.inputfield
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "mobile" {
            nibname = "InputCell"
            cellID = "InputCellID"
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! InputCell
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
            cell.inputfield.frame = CGRect(x: 10, y: 5, width: 300, height: 40)
            cell.inputfield.placeholder = "请输入手机号码"
            cell.inputfield.font = UIFont.systemFontOfSize(14)
            cell.inputfield.clearButtonMode = UITextFieldViewMode.WhileEditing
            cell.inputfield.backgroundColor = UIColor.whiteColor()
            cell.inputfield.borderStyle = UITextBorderStyle.RoundedRect
            cell.inputfield.leftView = padding
            cell.inputfield.tag = 3
            cell.inputfield.autocapitalizationType = UITextAutocapitalizationType.None
            cell.inputfield.delegate = self
            cell.inputfield.returnKeyType = UIReturnKeyType.Done
            cell.inputfield.keyboardType = UIKeyboardType.ASCIICapable
            mobiletext = cell.inputfield
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else {
            if ScreenW == 320 {
                nibname = "PaySummaryCell"
                cellID = "PaySummaryCellID"
            }
            if ScreenW == 375 {
                nibname = "PaySummaryCell375"
                cellID = "PaySummaryCellID375"
            }
            if ScreenW == 414 {
                nibname = "PaySummaryCell414"
                cellID = "PaySummaryCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! PaySummaryCell
            let summary = data.data as? Summarymodel
            let amountstr = summary!.total as NSString
            var amount = amountstr.doubleValue
            if ori {
                if summary?.freight == 0 || summary!.ship_fee == 0.00 {
                    cell.shipfee.text = "运费：免运费"
                } else {
                    cell.shipfee.text = "运费：￥" + String(summary!.ship_fee)
                    amount += summary!.ship_fee
                }
            } else {
                let sid = summary!.store_id
                if summary?.freight == 0 || smcellListHelper[sid] == 0.00 {
                    cell.shipfee.text = "运费：免运费"
                } else {
                    cell.shipfee.text = "运费：￥" + String(smcellListHelper[sid])
                    amount += smcellListHelper[sid]!
                }
            }
            let msinfo = summary?.msinfo as Msmodel!
            if msinfo.desc != "" {
                let dcstr = msinfo.discount as NSString
                amount -= dcstr.doubleValue
                cell.mansong.text = "满" + msinfo.price + "减" + msinfo.discount + "元：-￥" + (dcstr as String)
            } else {
                cell.mansong.text = "满即送：无"
            }
            if summary?.vouchernum == 0 {
                cell.daijin.text = "代金券：无"
            } else {
                cell.daijin.text = "点击选择代金券"
                cell.daijin.layer.borderWidth = 1
                cell.daijin.layer.borderColor = UIColor.blackColor().CGColor
                cell.daijin.layer.cornerRadius = 3
                cell.daijin.tag = Int(summary!.store_id)!
                cell.daijin.userInteractionEnabled = true
                cell.daijin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "choosevoucher:"))
            }
            cell.amount.text = "本店合计：￥" + String(amount)
            summarycellList[summary!.store_id] = cell
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = datacell[indexPath.row] as Ordercellmodel
        let type = data.type
        if type == "address" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let adrlistcontroller = sb.instantiateViewControllerWithIdentifier("AddressListViewID") as! AddressListViewController
            adrlistcontroller.choosemode = true
            adrlistcontroller.bvcontroller = self
            adrlistcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(adrlistcontroller, animated: true)
        }
        if type == "invoice" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let invlistcontroller = sb.instantiateViewControllerWithIdentifier("InvoiceListViewID") as! InvoiceListViewController
            invlistcontroller.choosemode = true
            invlistcontroller.bvcontroller = self
            invlistcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(invlistcontroller, animated: true)
        }
    }
    
    /**更新收货地址数据**/
    func addressUpdate() {
        let key = getkey()
        let paramstr = NSString(format: "key=%@&freight_hash=%@&city_id=1&area_id=%@", key, freight_hash, city_id, area_id)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_buy&op=change_address")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
       
        if data_array.objectForKey("error") != nil {
            tipstr.text = "收货地址异常"
            tipimg.image = UIImage(named: "error.png")
            tipshow.hidden = false
        } else {
            offpay_hash = data_array.objectForKey("offpay_hash") as! String
            offpay_hash_batch = data_array.objectForKey("offpay_hash_batch") as! String
            if !ori {
                let allow_offpay = data_array.objectForKey("allow_offpay") as! String
                if Int(allow_offpay) == 0 {
                    paytypecell.payoffline.hidden = true
                    paytypecell.offlinelabel.hidden = true
                } else {
                    paytypecell.payoffline.hidden = false
                    paytypecell.offlinelabel.hidden = false
                }
                let content = data_array.objectForKey("content") as! NSDictionary
                allshipfee = 0.00
                for (key,val) in content {
                    let sid = key as! String
                    let shipfee = val as! Double
                    smcellListHelper[sid] = shipfee
                    allshipfee += shipfee
                }
                checkview.reloadData()
                //更新订单总额显示
                allamount.text = "￥" + String(allgoodsprice+allshipfee) + "元"
            }
        }
    }
    
    /**切换支付方式**/
    func switchpaytype(recognizer: UITapGestureRecognizer) {
        let choosetype = recognizer.view!.tag
        if choosetype == 1 {
            paytypecell.payonline.image = UIImage(named: "checked.png")
            paytypecell.payoffline.image = UIImage(named: "uncheck.png")
            paytype = "online"
        } else {
            paytypecell.payonline.image = UIImage(named: "uncheck.png")
            paytypecell.payoffline.image = UIImage(named: "checked.png")
            paytype = "offline"
        }
    }
    
    /**切换是否使用预存款支付**/
    func switchpd(recognizer: UITapGestureRecognizer) {
        let choosetype = recognizer.view!.tag
        if choosetype == 1 {
            pdpaycell.yes.image = UIImage(named: "checked.png")
            pdpaycell.no.image = UIImage(named: "uncheck.png")
            usepd = "1"
        } else {
            pdpaycell.yes.image = UIImage(named: "uncheck.png")
            pdpaycell.no.image = UIImage(named: "checked.png")
            usepd = "0"
        }
    }
    
    /**编辑框的一些设置和响应处理**/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**提交订单**/
    func submit() {
        if system_error {
            return
        }
        if usepd == "1" && pdpwdtext.text == ""{
            tipstr.text = "请填写支付密码"
            tipimg.image = UIImage(named: "error.png")
            tipshow.hidden = false
            //延时关闭提示框
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
            return
        }
        let ap = available_predeposit as NSString
        if usepd == "1" && ap.doubleValue < allprice{
            tipstr.text = "预存款余额不足"
            tipimg.image = UIImage(named: "error.png")
            tipshow.hidden = false
            //延时关闭提示框
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
            return
        }
        let key = getkey()
        var passwordstr = ""
        if usepd == "1" {
            passwordstr = pdpwdtext.text!
            //检查支付密码是否正确
            let paramstr = NSString(format: "key=%@&password=%@", key, passwordstr)
            let paramstrlen = paramstr.length
            let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: API_URL + "index.php?act=member_buy&op=check_password")
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postdata
            let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let check_data: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")
            if String(check_data) != "1" {
                tipstr.text = "支付密码不正确"
                tipimg.image = UIImage(named: "error.png")
                tipshow.hidden = false
                //延时关闭提示框
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
                return
            }
        }
        if ifxvni {
            if mobiletext.text == ""{
                tipstr.text = "请填写手机号码"
                tipimg.image = UIImage(named: "error.png")
                tipshow.hidden = false
                //延时关闭提示框
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
                return
            }
            let paramstr = NSString(format: "key=%@&goods_id=%@&quantity=%@&buyer_phone=%@&pd_pay=%@&password=%@", key, choosegoods, String(xvni_num), mobiletext.text!, usepd, passwordstr)
            let paramstrlen = paramstr.length
            let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: API_URL + "index.php?act=member_vr_buy&op=buy_step3")
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postdata
            let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
            if data_array.objectForKey("order_id") != nil {
//                //跳转到虚拟列表
//                let sb = UIStoryboard(name: "Main", bundle: nil)
//                let vrolcontroller = sb.instantiateViewControllerWithIdentifier("VROrderListViewID") as! VROrderListViewController
//                vrolcontroller.fromcheckout = true
//                vrolcontroller.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(vrolcontroller, animated: true)
            } else {
                tipstr.text = "订单提交失败"
                tipimg.image = UIImage(named: "error.png")
                tipshow.hidden = false
                //延时关闭提示框
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
            }
        } else {
            if iffcode && fcodetext.text == ""{
                tipstr.text = "请填写F码"
                tipimg.image = UIImage(named: "error.png")
                tipshow.hidden = false
                //延时关闭提示框
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
                return
            }
            var paramstr: NSString!
            let ifcartstr = ifcart ? "1" : "0"
            var fcodestr = ""
            if iffcode {
                passwordstr = fcodetext.text!
            }
            //处理代金券信息
            for (key,val) in choosevoucher {
                var vc = val as Vouchermodel
                voucherstr += vc.voucher_t_id + "|" + vc.store_id + "|" + vc.voucher_price + ","
            }
            if iffcode {
                paramstr = NSString(format: "key=%@&ifcart=%@&cart_id=%@&address_id=%@&vat_hash=%@&offpay_hash=%@&offpay_hash_batch=%@&pay_name=%@&invoice_id=%@&voucher=%@&pd_pay=%@&password=%@&fcode=%@", key, ifcartstr, choosegoods, address_id, vat_hash, offpay_hash, offpay_hash_batch, paytype, invoice_id, voucherstr, usepd, passwordstr, passwordstr)
            } else {
                paramstr = NSString(format: "key=%@&ifcart=%@&cart_id=%@&address_id=%@&vat_hash=%@&offpay_hash=%@&offpay_hash_batch=%@&pay_name=%@&invoice_id=%@&voucher=%@&pd_pay=%@&password=%@", key, ifcartstr, choosegoods, address_id, vat_hash, offpay_hash, offpay_hash_batch, paytype, invoice_id, voucherstr, usepd, passwordstr)
            }
            let paramstrlen = paramstr.length
            let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: API_URL + "index.php?act=member_buy&op=buy_step2")
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postdata
            let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
            if data_array.objectForKey("pay_sn") != nil {
                //通知购物车刷新数据
                let center = NSNotificationCenter.defaultCenter()
                center.postNotificationName("CartRefreshData", object: self, userInfo: nil)
                //跳转到订单列表
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let olcontroller = sb.instantiateViewControllerWithIdentifier("OrderListViewID") as! OrderListViewController
                olcontroller.fromcheckout = true
                olcontroller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(olcontroller, animated: true)
            } else {
                tipstr.text = "订单提交失败"
                tipimg.image = UIImage(named: "error.png")
                tipshow.hidden = false
                //延时关闭提示框
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
            }
        }
    }
    
    //隐藏黑色提示框
    func hidetip() {
        tipshow.hidden = true
    }
    
    /**代金券选择器相关设置**/
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return voucherList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return voucherList[row].title
    }
    
    /**开启代金券选择器**/
    func choosevoucher(recognizer: UITapGestureRecognizer) {
        let sid = recognizer.view!.tag
        let store_id = String(sid)
        voucherList.removeAll(keepCapacity: false)
        let newvc = Vouchermodel()
        newvc.title = "不使用代金券"
        newvc.store_id = store_id
        voucherList.append(newvc)
        let list = allvoucher[store_id]!
        for vc in list {
            voucherList.append(vc)
        }
        voucherpicker.reloadAllComponents()
        voucherview.hidden = false
    }
    
    func addvoucherinfo() {
        let row = voucherpicker.selectedRowInComponent(0)
        let sid = voucherList[row].store_id
        let cell = summarycellList[sid]
        var newstoreamount = smcellListHelper[sid]! + smcellListHelper2[sid]! - smcellListHelper3[sid]!
        if row > 0 {
            //添加进选择数组中
            choosevoucher[sid] = voucherList[row]
            //更新代金券使用显示
            cell!.daijin.text = voucherList[row].title + "：-￥" + voucherList[row].voucher_price
            let vcprice = voucherList[row].voucher_price as NSString
            newstoreamount -= vcprice.doubleValue
        } else {
            //删除出选择数组
            choosevoucher.removeValueForKey(sid)
            //更新代金券使用显示
            cell!.daijin.text = "不使用代金券"
        }
        //更新店铺合计价格显示
        cell!.amount.text = "本店合计：￥" + String(newstoreamount)
        //更新底部订单总金额显示
        var newamount = allgoodsprice + allshipfee
        for (_,val) in choosevoucher {
            let vc = val as Vouchermodel
            let vcprice = vc.voucher_price as NSString
            newamount -= vcprice.doubleValue
        }
        allamount.text = "￥" + String(newamount) + "元"
        voucherview.hidden = true
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if alertView.tag == 1 && btnlabel == "好" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let adrlistcontroller = sb.instantiateViewControllerWithIdentifier("AddressListViewID") as! AddressListViewController
            adrlistcontroller.choosemode = true
            adrlistcontroller.bvcontroller = self
            adrlistcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(adrlistcontroller, animated: true)
        }
        if alertView.tag == 2 && btnlabel == "好" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let logincontroller = sb.instantiateViewControllerWithIdentifier("LoginViewID") as! LoginViewController
            self.navigationController?.pushViewController(logincontroller, animated: true)
        }
        if btnlabel == "取消" || btnlabel == "知道了" {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}