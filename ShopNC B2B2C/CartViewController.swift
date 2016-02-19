//
//  CartViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/28.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var ScreenWidth: CGFloat!
    var goodstable = UITableView()
    var cartList = [String:Cartmodel]()
    var cartListHelper = [String]()
    var cartview: UITableView!
    var activity: UIActivityIndicatorView!
    var nothing = UILabel()
    var reloadbtn = UILabel()
    //结算相关
    var allgoodsnum = 0
    var allprice = 0.00
    var checkoutgoods = [String:Goodsmodel]()//cart_id => goodsmodel
    var cellList = [String:CartGoodsCell]()//toString(indexPath.row) + toString(indexPath.section) => cell
    var cidList = [String:String]()//toString(indexPath.row) + toString(indexPath.section) => cart_id
    var allpricelabel: UILabel!
    var jslabel: UILabel!
    var cartbar = UIView()
    var cellkeyList = [String:[String]]()//store_id => [cellkey]
    var checkstore = [String:Bool]()//store_id => bool
    var storecellList = [String:CartStoreCell]()
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购物车"
        ScreenWidth = self.view.frame.width
        cartview = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: self.view.frame.height-64), style: UITableViewStyle.Grouped)
        cartview.dataSource = self
        cartview.delegate = self
        self.view.addSubview(cartview)
        /**结算信息区**/
        cartbar.frame = CGRect(x: 0, y: self.view.frame.height-173, width: ScreenWidth, height: 60)
        cartbar.backgroundColor = UIColor.clearColor()
        self.view.addSubview(cartbar)
        let cartbarimg = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 60))
        cartbarimg.image = UIImage(named: "cartbar.png")
        cartbar.addSubview(cartbarimg)
        let clearimg = UIImageView(frame: CGRect(x: 10, y: 15, width: 30, height: 30))
        clearimg.image = UIImage(named: "checked.png")
        cartbar.addSubview(clearimg)
        clearimg.userInteractionEnabled = true
        clearimg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "unallcheck"))
        let heji = UILabel(frame: CGRect(x: 45, y: 15, width: 40, height: 20))
        heji.font = UIFont.systemFontOfSize(16)
        heji.text = "合计"
        heji.textAlignment = NSTextAlignment.Center
        cartbar.addSubview(heji)
        let bhyf = UILabel(frame: CGRect(x: 45, y: 33, width: 45, height: 20))
        bhyf.font = UIFont.systemFontOfSize(10)
        bhyf.textColor = UIColor.grayColor()
        bhyf.text = "不含运费"
        bhyf.textAlignment = NSTextAlignment.Center
        cartbar.addSubview(bhyf)
        allpricelabel = UILabel(frame: CGRect(x: 85, y: 15, width: 120, height: 30))
        allpricelabel.font = UIFont.systemFontOfSize(20)
        allpricelabel.textColor = UIColor(red: 181/255, green: 19/255, blue: 26/255, alpha: 1.0)
        allpricelabel.text = "￥0.00"
        allpricelabel.textAlignment = NSTextAlignment.Center
        cartbar.addSubview(allpricelabel)
        let jsbtn = UIView(frame: CGRect(x: ScreenWidth-110, y: 0, width: 110, height: 60))
        jsbtn.backgroundColor = UIColor(red: 181/255, green: 0/255, blue: 7/255, alpha: 1.0)
        cartbar.addSubview(jsbtn)
        jslabel = UILabel(frame: CGRect(x: 0, y: 15, width: 110, height: 30))
        jslabel.font = UIFont.systemFontOfSize(20)
        jslabel.textColor = UIColor.whiteColor()
        jslabel.text = "结算"
        jslabel.textAlignment = NSTextAlignment.Center
        jsbtn.addSubview(jslabel)
        jsbtn.userInteractionEnabled = true
        jsbtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "topay"))
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        activity.startAnimating()
        NSThread.detachNewThreadSelector("refreshData", toTarget: self, withObject: nil)
        /**添加黑色提示框**/
        tipshow.frame = CGRect(x: (ScreenWidth-150)/2, y: (self.view.frame.height-80)/3, width: 150, height: 80)
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
        /**设置下拉刷新**/
        cartview.addHeaderWithTarget(self, action: "pullrefreshData")
        /**添加通知监听**/
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "refreshData", name: "CartRefreshData", object: nil)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**加载数据**/
    func pullrefreshData() {
        refreshData()
    }
    
    func taprefreshData() {
        activity.startAnimating()
        NSThread.detachNewThreadSelector("refreshData", toTarget: self, withObject: nil)
    }
    
    func refreshData() {
        //清理数据
        cartList = [String:Cartmodel]()
        cartListHelper.removeAll(keepCapacity: false)
        allgoodsnum = 0
        allprice = 0.0
        checkoutgoods = [String:Goodsmodel]()
        cartbar.hidden = true
        cellkeyList = [String:[String]]()
        cidList = [String:String]()
        checkstore = [String:Bool]()
        for (key,val) in storecellList {
            let cell = val as CartStoreCell
            cell.checkpic.image = UIImage(named: "uncheck.png")
        }
        for (key,val) in cellList {
            let cell = val as CartGoodsCell
            cell.checkpic.image = UIImage(named: "uncheck.png")
        }
        storecellList = [String:CartStoreCell]()
        cellList = [String:CartGoodsCell]()
        //数据加载
        loadData()
        if cartList.isEmpty {
            cartview.hidden = true
            nothing.frame = CGRect(x: (ScreenWidth-200)/2, y: self.view.frame.height/3, width: 200, height: 30)
            nothing.font = UIFont.systemFontOfSize(16)
            nothing.textColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
            nothing.text = "这里空空如也哦~"
            nothing.textAlignment = NSTextAlignment.Center
            self.view.addSubview(nothing)
            reloadbtn.frame = CGRect(x: (ScreenWidth-200)/2, y: self.view.frame.height/3+40, width: 200, height: 30)
            reloadbtn.font = UIFont.systemFontOfSize(16)
            reloadbtn.textColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
            reloadbtn.text = "点我重新加载"
            reloadbtn.textAlignment = NSTextAlignment.Center
            reloadbtn.layer.borderWidth = 1
            reloadbtn.layer.borderColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0).CGColor
            reloadbtn.layer.cornerRadius = 5
            reloadbtn.userInteractionEnabled = true
            reloadbtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "taprefreshData"))
            self.view.addSubview(reloadbtn)
            nothing.hidden = false
            reloadbtn.hidden = false
        } else {
            cartview.hidden = false
            cartview.reloadData()
            let contentH = cartview.contentSize.height
            cartview.contentSize = CGSizeMake(0, contentH+173)
            nothing.hidden = true
            reloadbtn.hidden = true
        }
    }
    
    func loadData() {
        if !islogin() {
            activity.stopAnimating()
            cartview.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "请您先登录", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let key = getkey()
        let paramstr = NSString(format: "key=%@", key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_cart&op=cart_list")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if respdata == nil {
            activity.stopAnimating()
            cartview.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let data_array: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")
        if let datas = data_array as? NSDictionary {
            if datas.objectForKey("error") != nil {
                activity.stopAnimating()
                cartview.headerEndRefreshing()
                let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                return
            }
            let cart_list: AnyObject! = datas.objectForKey("cart_list")
            if let cl = cart_list as? NSArray {
                for goods in cl {
                    let newgoods = Goodsmodel()
                    let goodsinfo = goods as! NSDictionary
                    newgoods.goods_name = goodsinfo.objectForKey("goods_name") as! String
                    newgoods.goods_id = goodsinfo.objectForKey("goods_id") as! String
                    newgoods.goods_num = goodsinfo.objectForKey("goods_num") as! String
                    let price: AnyObject! = goodsinfo.objectForKey("goods_price")
                    newgoods.goods_price = String(price)
                    newgoods.goods_image = goodsinfo.objectForKey("goods_image_url") as! String
                    newgoods.cart_id = goodsinfo.objectForKey("cart_id") as! String
                    let store_id = goodsinfo.objectForKey("store_id") as! String
                    let store_name = goodsinfo.objectForKey("store_name") as! String
                    newgoods.store_id = store_id
                    newgoods.store_name = store_name
                    if cartList[store_id] == nil {
                        cartList[store_id] = Cartmodel()
                        cartListHelper.append(store_id)
                    }
                    cartList[store_id]?.store_id = store_id
                    cartList[store_id]?.store_name = store_name
                    cartList[store_id]?.goodsList.append(newgoods)
                    checkstore[store_id] = false
                }
            }
        }
        activity.stopAnimating()
        cartview.headerEndRefreshing()
        cartview.reloadData()
    }
    
    /**tableview数据设置**/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cartList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sid = cartListHelper[section]
        let cartinfo = cartList[sid] as Cartmodel!
        return cartinfo.goodsList.count+1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        }
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: "CartStoreCell", bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: "CartStoreCellID")
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("CartStoreCellID", forIndexPath: indexPath) as! CartStoreCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let sid = cartListHelper[indexPath.section]
            let cartinfo = cartList[sid] as Cartmodel!
            cell.storename.text = cartinfo.store_name
            cell.checkpic.tag = Int(cartinfo.store_id)!
            cell.checkpic.userInteractionEnabled = true
            cell.checkpic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "storeswitchbtn:"))
            storecellList[cartinfo.store_id] = cell
            let check = checkstore[cartinfo.store_id]
            if check == true {
                cell.checkpic.image = UIImage(named: "checked.png")
            } else {
                cell.checkpic.image = UIImage(named: "uncheck.png")
            }
            return cell
        } else {
            var nibname = ""
            var cellID = ""
            if ScreenWidth == 320 {
                nibname = "CartGoodsCell"
                cellID = "CartGoodsCellID"
            }
            if ScreenWidth == 375 {
                nibname = "CartGoodsCell375"
                cellID = "CartGoodsCellID375"
            }
            if ScreenWidth == 414 {
                nibname = "CartGoodsCell414"
                cellID = "CartGoodsCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! CartGoodsCell
            let taglabel = String(indexPath.row) + String(indexPath.section)
            cellList[taglabel] = cell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let sid = cartListHelper[indexPath.section]
            let cartinfo = cartList[sid] as Cartmodel!
            let goodsinfo = cartinfo.goodsList[indexPath.row-1]
            cidList[taglabel] = goodsinfo.cart_id
            let store_id = goodsinfo.store_id
            if cellkeyList[store_id] == nil {
                cellkeyList[store_id] = [String]()
            }
            cellkeyList[store_id]!.append(taglabel)
            if checkoutgoods[goodsinfo.cart_id] != nil {
                cell.checkpic.image = UIImage(named: "checked.png")
            } else {
                cell.checkpic.image = UIImage(named: "uncheck.png")
            }
            cell.goodsname.text = goodsinfo.goods_name
            cell.goodsprice.text = "￥" + goodsinfo.goods_price
            cell.buynum.text = "x" + goodsinfo.goods_num
            cell.buynum.tag = Int(taglabel)!
            cell.buynum.userInteractionEnabled = true
            cell.buynum.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "startchange:"))
            cell.editicon.tag = Int(taglabel)!
            cell.editicon.userInteractionEnabled = true
            cell.editicon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "startchange:"))
            /**图片的延时加载**/
            let cellimgdata: NSArray = [cell, indexPath.section, indexPath.row]
            NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
            /**修改购买数量组件**/
            cell.reducenum.backgroundColor = UIColor.whiteColor()
            cell.reducenum.layer.borderWidth = 1
            cell.reducenum.layer.borderColor = UIColor.lightGrayColor().CGColor
            let rdlabel = UILabel(frame: CGRect(x: 0, y: 2.5, width: 25, height: 20))
            rdlabel.font = UIFont.systemFontOfSize(18)
            rdlabel.textColor = UIColor.grayColor()
            rdlabel.text = "-"
            rdlabel.textAlignment = NSTextAlignment.Center
            cell.reducenum.addSubview(rdlabel)
            cell.reducenum.tag = Int(taglabel)!
            cell.reducenum.userInteractionEnabled = true
            cell.reducenum.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "reducenum:"))
            
            cell.numshow.backgroundColor = UIColor.whiteColor()
            cell.numshow.layer.borderWidth = 1
            cell.numshow.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.numlabel.font = UIFont.systemFontOfSize(14)
            cell.numlabel.textColor = UIColor.grayColor()
            cell.numlabel.text = goodsinfo.goods_num
            cell.numlabel.textAlignment = NSTextAlignment.Center
            
            cell.addnum.backgroundColor = UIColor.whiteColor()
            cell.addnum.layer.borderWidth = 1
            cell.addnum.layer.borderColor = UIColor.lightGrayColor().CGColor
            let addlabel = UILabel(frame: CGRect(x: 0, y: 2.5, width: 25, height: 20))
            addlabel.font = UIFont.systemFontOfSize(18)
            addlabel.textColor = UIColor.grayColor()
            addlabel.text = "+"
            addlabel.textAlignment = NSTextAlignment.Center
            cell.addnum.addSubview(addlabel)
            cell.addnum.tag = Int(taglabel)!
            cell.addnum.userInteractionEnabled = true
            cell.addnum.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addnum:"))
            
            cell.confirmbtn.tag = Int(taglabel)!
            cell.confirmbtn.userInteractionEnabled = true
            cell.confirmbtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changenum:"))
            
            cell.checkpic.tag = Int(taglabel)!
            cell.checkpic.userInteractionEnabled = true
            cell.checkpic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "switchbtn:"))
            
            cell.goodsprice.hidden = false
            cell.buynum.hidden = false
            cell.editicon.hidden = false
            cell.reducenum.hidden = true
            cell.numshow.hidden = true
            cell.addnum.hidden = true
            cell.confirmbtn.hidden = true
            return cell
        }
    }
    
    func uploadImageForCellAtIndexPath(cellimgdata: NSArray) {
        let secnum = cellimgdata.objectAtIndex(1) as! Int
        let rownum = cellimgdata.objectAtIndex(2) as! Int
        let sid = cartListHelper[secnum]
        let cartinfo = cartList[sid] as Cartmodel!
        let goodsinfo = cartinfo.goodsList[rownum-1]
        let picurl = goodsinfo.goods_image
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
        let cell = cellimgdata.objectAtIndex(0) as! CartGoodsCell
        cell.goodspic.image = img
    }
    
    /**tableview单元格操作设置**/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 0 {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let gdcontroller = sb.instantiateViewControllerWithIdentifier("GoodsDetailID") as! GoodsDetailViewController
            let sid = cartListHelper[indexPath.section]
            let cartinfo = cartList[sid] as Cartmodel!
            let goodsinfo = cartinfo.goodsList[indexPath.row-1]
            gdcontroller.goods_id = goodsinfo.goods_id
            gdcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(gdcontroller, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row != 0 {
            return UITableViewCellEditingStyle.Delete
        } else {
            return UITableViewCellEditingStyle.None
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        cartview.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let sid = cartListHelper[indexPath.section]
            let cartinfo = cartList[sid] as Cartmodel!
            let goodsinfo = cartinfo.goodsList[indexPath.row-1]
            let cart_id = goodsinfo.cart_id
            let delrs = delgoods(cart_id)
            if delrs {
                cartList[sid]?.goodsList.removeAtIndex(indexPath.row-1)
                if cartList[sid]?.goodsList.count == 0 {
                    cartList.removeValueForKey(sid)
                }
                if checkoutgoods[cart_id] != nil {
                    checkoutgoods.removeValueForKey(cart_id)
                    calcgoods()
                }
                if cartList.isEmpty {
                    cartview.hidden = true
                    nothing.hidden = false
                    reloadbtn.hidden = false
                } else {
                    cartview.reloadData()
                }
            } else {
                tipstr.text = "删除失败"
                tipimg.image = UIImage(named: "error.png")
                tipshow.hidden = false
                //延时关闭提示框
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
            }
        }
    }
    
    /**切换选中状态**/
    func storeswitchbtn(recognizer: UITapGestureRecognizer) {
        let store_id = String(recognizer.view!.tag)
        let check = checkstore[store_id]
        if check == false {
            for (key,val) in cartList {
                let cartinfo = val as Cartmodel
                if cartinfo.store_id == store_id {
                    let goodsList = cartinfo.goodsList
                    for goods in goodsList {
                        checkoutgoods[goods.cart_id] = goods
                    }
                    break
                }
            }
            let cellkeys = cellkeyList[store_id]!
            for key in cellkeys {
                let cell = cellList[key] as CartGoodsCell!
                cell.checkpic.image = UIImage(named: "checked.png")
            }
            let scell = storecellList[store_id] as CartStoreCell!
            scell.checkpic.image = UIImage(named: "checked.png")
            checkstore[store_id] = true
            calcgoods()
        } else {
            for (key,val) in cartList {
                let cartinfo = val as Cartmodel
                if cartinfo.store_id == store_id {
                    let goodsList = cartinfo.goodsList
                    for goods in goodsList {
                        checkoutgoods.removeValueForKey(goods.cart_id)
                    }
                    break
                }
            }
            let cellkeys = cellkeyList[store_id]!
            for key in cellkeys {
                let cell = cellList[key] as CartGoodsCell!
                cell.checkpic.image = UIImage(named: "uncheck.png")
            }
            let scell = storecellList[store_id] as CartStoreCell!
            scell.checkpic.image = UIImage(named: "uncheck.png")
            checkstore[store_id] = false
            calcgoods()
        }
    }
    
    func switchbtn(recognizer: UITapGestureRecognizer) {
        let cellkey = String(recognizer.view!.tag)
        let cell = cellList[cellkey] as CartGoodsCell!
        let cart_id = cidList[cellkey] as String!
        if checkoutgoods[cart_id] == nil {
            var loop = true
            for (key,val) in cartList {
                if !loop {
                    break
                }
                let cartinfo = val as Cartmodel
                let goodsList = cartinfo.goodsList
                for goods in goodsList {
                    let cid = goods.cart_id
                    if cid == cart_id {
                        checkoutgoods[cart_id] = goods
                        loop = false
                        break
                    }
                }
            }
            cell.checkpic.image = UIImage(named: "checked.png")
            calcgoods()
        } else {
            let goodsinfo = checkoutgoods[cart_id] as Goodsmodel!
            checkoutgoods.removeValueForKey(cart_id)
            cell.checkpic.image = UIImage(named: "uncheck.png")
            //取消店铺选中状态
            let store_id = goodsinfo.store_id
            let scell = storecellList[store_id] as CartStoreCell!
            scell.checkpic.image = UIImage(named: "uncheck.png")
            checkstore[store_id] = false
            calcgoods()
        }
    }
    
    func calcgoods() {
        allgoodsnum = 0
        allprice = 0.00
        for (key,val) in checkoutgoods {
            let goods = val as Goodsmodel
            allgoodsnum++
            let price = goods.goods_price as NSString
            let num = goods.goods_num as NSString
            allprice += price.doubleValue*num.doubleValue
        }
        if allgoodsnum > 0 {
            allpricelabel.text = "￥" + String(allprice)
            jslabel.text = "结算(" + String(allgoodsnum) + ")"
            cartbar.hidden = false
        } else {
            cartbar.hidden = true
        }
    }
    /**更改商品数量**/
    func reducenum(recognizer: UITapGestureRecognizer) {
        let cellkey = String(recognizer.view!.tag)
        let cell = cellList[cellkey] as CartGoodsCell!
        let num = Int(cell.numlabel.text!)!
        if (num - 1) <= 0 {
            let alert = UIAlertView(title: "提示", message: "请至少购买1件该商品", delegate: self, cancelButtonTitle: "知道了")
            alert.show()
        } else {
            cell.numlabel.text = String(num - 1)
        }
    }
    
    func addnum(recognizer: UITapGestureRecognizer) {
        let cellkey = String(recognizer.view!.tag)
        let cell = cellList[cellkey] as CartGoodsCell!
        let num = Int(cell.numlabel.text!)!
        cell.numlabel.text = String(num + 1)
    }
    
    func startchange(recognizer: UITapGestureRecognizer) {
        let cellkey = String(recognizer.view!.tag)
        let cell = cellList[cellkey] as CartGoodsCell!
        cell.goodsprice.hidden = true
        cell.buynum.hidden = true
        cell.editicon.hidden = true
        cell.reducenum.hidden = false
        cell.numshow.hidden = false
        cell.addnum.hidden = false
        cell.confirmbtn.hidden = false
    }
    
    func changenum(recognizer: UITapGestureRecognizer) {
        let cellkey = String(recognizer.view!.tag)
        let cell = cellList[cellkey] as CartGoodsCell!
        let cart_id = cidList[cellkey] as String!
        //提交更新商品购买数量
        let rs = dochangenum(cart_id, cell.numlabel.text!)
        if rs != "failed" {
            cell.buynum.text = "x" + cell.numlabel.text!
            cell.goodsprice.text = rs
            for (key,val) in cartList {
                let cartinfo = val as Cartmodel
                let goodsList = cartinfo.goodsList
                for goods in goodsList {
                    let cid = goods.cart_id
                    if cid == cart_id {
                        goods.goods_price = rs
                        goods.goods_num = cell.numlabel.text!
                    }
                }
            }
            //重新计算总价
            for (key,val) in checkoutgoods {
                if cart_id == key {
                    val.goods_price = rs
                    val.goods_num = cell.numlabel.text!
                    break
                }
            }
            calcgoods()
        } else {
            tipstr.text = "修改失败"
            tipimg.image = UIImage(named: "error.png")
            tipshow.hidden = false
            //延时关闭提示框
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
        }
        cell.goodsprice.hidden = false
        cell.buynum.hidden = false
        cell.editicon.hidden = false
        cell.reducenum.hidden = true
        cell.numshow.hidden = true
        cell.addnum.hidden = true
        cell.confirmbtn.hidden = true
    }
    
    func dochangenum(cart_id: String, _ buynum: String) -> String {
        activity.startAnimating()
        let key = getkey()
        let paramstr = NSString(format: "cart_id=%@&quantity=%@&key=%@", cart_id, buynum, key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_cart&op=cart_edit_quantity")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        activity.stopAnimating()
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        let quantity: AnyObject! = data_array.objectForKey("quantity")
        if let _ = quantity as? Int {
            let newprice: AnyObject! = data_array.objectForKey("goods_price")
            //NSLog("%@", toString(newprice))
            return String(newprice)
        } else {
            return "failed"
        }
    }
    
    /**删除购物车商品**/
    func delgoods(cart_id: String) -> Bool {
        activity.startAnimating()
        var rs = false
        let key = getkey()
        let paramstr = NSString(format: "cart_id=%@&key=%@", cart_id, key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_cart&op=cart_del")
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
    
    //取消全选
    func unallcheck() {
        allgoodsnum = 0
        allprice = 0.0
        checkoutgoods = [String:Goodsmodel]()
        for (key,_) in checkstore {
            checkstore[key] = false
        }
        for (_,val) in storecellList {
            let cell = val as CartStoreCell
            cell.checkpic.image = UIImage(named: "uncheck.png")
        }
        for (_,val) in cellList {
            let cell = val as CartGoodsCell
            cell.checkpic.image = UIImage(named: "uncheck.png")
        }
        cartbar.hidden = true
    }
    
    /**结算下单**/
    func topay() {
        var buygoodsstr = ""
        for (key,val) in checkoutgoods {
            let cart_id = key as String
            let goods = val as Goodsmodel
            let buynum = goods.goods_num
            buygoodsstr += cart_id + "|" + buynum + ","
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let buycontroller = sb.instantiateViewControllerWithIdentifier("BuyViewID") as! BuyViewController
        buycontroller.ifcart = true
        buycontroller.choosegoods = buygoodsstr
        buycontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(buycontroller, animated: true)
    }
}