//
//  GoodsAttrViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/20.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit
import Foundation

class GoodsAttrViewController: UIViewController, UIScrollViewDelegate, UIAlertViewDelegate {
    var activity: UIActivityIndicatorView!
    var goods_id = ""
    var ScreenWidth: CGFloat!
    var navititle = ""
    var goods_name = ""
    var goods_image_url = ""
    var price = ""
    var attrList = [Attrmodel]()
    var specgoods = [String:String]()
    var choosespec = [String:String]()
    var choosespeccode = [String:String]()
    var mainscrollview = UIScrollView()
    var mode = ""
    var picview = UIImageView()
    var nameshow: UILabel!
    var priceshow: UILabel!
    var attrH = 10
    var attrview = [String:UIView]()
    var attrlables = [UILabel]()
    var numshowlabel: UILabel!
    var stock = UILabel()
    var stocknum = 0
    var buynum = 1
    var cartnumshow = UIView()
    var cartnumlabel: UILabel!
    var fcode = false
    var xvni = false
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navititle
        ScreenWidth = self.view.frame.width
        self.view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        picview.frame = CGRect(x: 10, y: 10, width: ScreenWidth/4, height: ScreenWidth/4)
        picview.image = UIImage(named: "goods_nopic.png")
        if goods_image_url != "" {
            let picurl_arr = goods_image_url.componentsSeparatedByString("/")
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
                    let url = NSURL(string: goods_image_url)!
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
            picview.image = img
        }
        self.view.addSubview(picview)
        nameshow = UILabel(frame: CGRect(x: ScreenWidth/4+20, y: 10, width: ScreenWidth-ScreenWidth/4-30, height: 50))
        nameshow.font = UIFont.systemFontOfSize(16)
        nameshow.numberOfLines = 2
        nameshow.text = goods_name
        self.view.addSubview(nameshow)
        let amountlable = UILabel(frame: CGRect(x: ScreenWidth/4+20, y: 65, width: 50, height: 20))
        amountlable.font = UIFont.systemFontOfSize(16)
        amountlable.textColor = UIColor.grayColor()
        amountlable.text = "单价："
        self.view.addSubview(amountlable)
        priceshow = UILabel(frame: CGRect(x: ScreenWidth/4+60, y: 65, width: 100, height: 20))
        priceshow.font = UIFont.systemFontOfSize(16)
        priceshow.text = price
        priceshow.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        self.view.addSubview(priceshow)
        /**规格数量选择**/
        mainscrollview.frame = CGRect(x: 0, y: ScreenWidth/4+20, width: ScreenWidth, height: self.view.frame.height-134-ScreenWidth/4)
        mainscrollview.delegate = self
        mainscrollview.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        self.view.addSubview(mainscrollview)
        var i = 0
        let attrviewList = attrview as NSDictionary
        for attr in attrList {
            attrlables[i].frame = CGRect(x: 10, y: attrH, width: 60, height: 20)
            attrlables[i].font = UIFont.systemFontOfSize(14)
            attrlables[i].text = attr.name
            attrlables[i].textColor = UIColor.blackColor()
            mainscrollview.addSubview(attrlables[i])
            i++
            for (key,val) in attr.info {
                let attrcode = key as String
                let attrtext = val as String
                let childview = attrviewList.objectForKey(attrcode) as! UIView
                childview.frame = CGRect(x: 70, y: attrH, width: 230, height: 30)
                childview.backgroundColor = UIColor.whiteColor()
                childview.layer.borderWidth = 0.5
                childview.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).CGColor
                childview.layer.cornerRadius = 3
                childview.tag = Int(attrcode)!
                childview.userInteractionEnabled = true
                childview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "attrchoose:"))
                mainscrollview.addSubview(childview)
                attrlables[i].frame = CGRect(x: 10, y: 5, width: 180, height: 20)
                attrlables[i].font = UIFont.systemFontOfSize(14)
                attrlables[i].text = attrtext
                attrlables[i].textColor = UIColor.blackColor()
                childview.addSubview(attrlables[i])
                for (ck,cv) in choosespec {
                    let cval = cv as String
                    if attrtext == cval {
                        childview.layer.borderColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0).CGColor
                        choosespeccode[attr.name] = attrcode
                        break
                    } else {
                        if mode == "buynow" {
                            childview.userInteractionEnabled = false
                            attrlables[i].textColor = UIColor.grayColor()
                        }
                    }
                }
                i++
                attrH += 35
            }
            attrH += 10
        }
        let numlabel = UILabel()
        numlabel.frame = CGRect(x: 10, y: attrH, width: 60, height: 20)
        numlabel.font = UIFont.systemFontOfSize(14)
        numlabel.text = "数量"
        numlabel.textColor = UIColor.blackColor()
        mainscrollview.addSubview(numlabel)
        let reducenum = UIView(frame: CGRect(x: 70, y: attrH, width: 40, height: 30))
        reducenum.backgroundColor = UIColor.whiteColor()
        reducenum.layer.borderWidth = 0.5
        reducenum.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).CGColor
        reducenum.layer.cornerRadius = 3
        mainscrollview.addSubview(reducenum)
        reducenum.userInteractionEnabled = true
        let reducenumsingleTap = UITapGestureRecognizer(target: self, action: "reducenum")
        reducenum.addGestureRecognizer(reducenumsingleTap)
        let reducenumlable = UILabel(frame: CGRect(x: 10, y: 3, width: 20, height: 20))
        reducenumlable.text = "-"
        reducenumlable.font = UIFont.systemFontOfSize(20)
        reducenumlable.textAlignment = NSTextAlignment.Center
        reducenum.addSubview(reducenumlable)
        let numshow = UIView(frame: CGRect(x: 115, y: attrH, width: 60, height: 30))
        numshow.backgroundColor = UIColor.whiteColor()
        numshow.layer.borderWidth = 0.5
        numshow.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).CGColor
        numshow.layer.cornerRadius = 3
        mainscrollview.addSubview(numshow)
        numshowlabel = UILabel(frame: CGRect(x: 10, y: 5, width: 40, height: 20))
        numshowlabel.text = String(buynum)
        numshowlabel.font = UIFont.systemFontOfSize(20)
        numshowlabel.textAlignment = NSTextAlignment.Center
        numshow.addSubview(numshowlabel)
        let addnum = UIView(frame: CGRect(x: 180, y: attrH, width: 40, height: 30))
        addnum.backgroundColor = UIColor.whiteColor()
        addnum.layer.borderWidth = 0.5
        addnum.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).CGColor
        addnum.layer.cornerRadius = 3
        mainscrollview.addSubview(addnum)
        addnum.userInteractionEnabled = true
        let addnumsingleTap = UITapGestureRecognizer(target: self, action: "addnum")
        addnum.addGestureRecognizer(addnumsingleTap)
        let addnumlable = UILabel(frame: CGRect(x: 10, y: 3, width: 20, height: 20))
        addnumlable.text = "+"
        addnumlable.font = UIFont.systemFontOfSize(20)
        addnumlable.textAlignment = NSTextAlignment.Center
        addnum.addSubview(addnumlable)
        stock.frame = CGRect(x: 70, y: attrH+35, width: 100, height: 20)
        stock.font = UIFont.systemFontOfSize(12)
        stock.textColor = UIColor.grayColor()
        mainscrollview.addSubview(stock)
        mainscrollview.contentSize = CGSizeMake(0, CGFloat(attrH+65))
        /**底部操作栏**/
        let BBView = UIView(frame: CGRect(x: 0, y: self.view.frame.height-114, width: ScreenWidth, height: 50))
        BBView.backgroundColor = UIColor(red: 229/255, green: 232/255, blue: 238/255, alpha: 1.0)
        self.view.addSubview(BBView)
        if mode == "attrchoose" {
            var btnx = CGFloat(80)
            var cartx = CGFloat(50)
            if ScreenWidth == 320 {
                btnx = CGFloat(60)
                cartx = CGFloat(45)
            }
            //立即购买按钮
            let buynowbtn = UIButton(frame: CGRect(x: 10, y: 5, width: (ScreenWidth-70)/2, height: 40))
            buynowbtn.backgroundColor = UIColor(red: 162/255, green: 101/255, blue: 51/255, alpha: 1.0)
            buynowbtn.layer.cornerRadius = 3
            buynowbtn.addTarget(self, action: "gotobuynow", forControlEvents: UIControlEvents.TouchUpInside)
            buynowbtn.setTitle("立即购买", forState: UIControlState.Normal)
            buynowbtn.titleLabel?.font = UIFont.systemFontOfSize(16)
            buynowbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            BBView.addSubview(buynowbtn)
            //加入购物车按钮
            let addcartbtn = UIButton(frame: CGRect(x: 15+(ScreenWidth-70)/2, y: 5, width: (ScreenWidth-70)/2, height: 40))
            addcartbtn.backgroundColor = UIColor(red: 181/255, green: 0/255, blue: 7/255, alpha: 1.0)
            addcartbtn.layer.cornerRadius = 3
            addcartbtn.addTarget(self, action: "addcart", forControlEvents: UIControlEvents.TouchUpInside)
            addcartbtn.setTitle("添加购物车", forState: UIControlState.Normal)
            addcartbtn.titleLabel?.font = UIFont.systemFontOfSize(16)
            addcartbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            BBView.addSubview(addcartbtn)
            //购物车图标
            let cartshowbtn = UIImageView(frame: CGRect(x: ScreenWidth-cartx, y: 5, width: 40, height: 40))
            cartshowbtn.image = UIImage(named: "cartshow.png")
            BBView.addSubview(cartshowbtn)
            cartshowbtn.userInteractionEnabled = true
            let cartshowbtnsingleTap = UITapGestureRecognizer(target: self, action: "gotocart")
            cartshowbtn.addGestureRecognizer(cartshowbtnsingleTap)
            //购物车商品数量
            cartnumshow.frame = CGRect(x: 18, y: 5, width: 20, height: 15)
            cartnumshow.backgroundColor = UIColor(red: 181/255, green: 0/255, blue: 7/255, alpha: 1.0)
            cartnumshow.layer.cornerRadius = 5
            cartshowbtn.addSubview(cartnumshow)
            cartnumlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
            cartnumlabel.font = UIFont.systemFontOfSize(10)
            cartnumlabel.textColor = UIColor.whiteColor()
            cartnumlabel.textAlignment = NSTextAlignment.Center
            cartnumshow.addSubview(cartnumlabel)
            cartnumshow.hidden = true
        } else {
            let buynowbtn = UIButton(frame: CGRect(x: 10, y: 5, width: ScreenWidth-20, height: 40))
            buynowbtn.backgroundColor = UIColor(red: 162/255, green: 101/255, blue: 51/255, alpha: 1.0)
            buynowbtn.layer.cornerRadius = 3
            buynowbtn.addTarget(self, action: "gotobuynow", forControlEvents: UIControlEvents.TouchUpInside)
            buynowbtn.setTitle("立即购买", forState: UIControlState.Normal)
            buynowbtn.titleLabel?.font = UIFont.systemFontOfSize(16)
            buynowbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            BBView.addSubview(buynowbtn)
        }
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
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
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "sethidetip", name: "closeTip", object: nil)
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
        //获取购物车商品数量
        if mode == "attrchoose" {
            let cartnum = getcartgoodsnum()
            if cartnum > 0 {
                cartnumlabel.text = String(cartnum)
                cartnumshow.hidden = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**购买数量控制**/
    func addnum() {
        if (buynum + 1) > stocknum {
            let alert = UIAlertView(title: "提示", message: "该商品库存不足", delegate: self, cancelButtonTitle: "知道了")
            alert.show()
        } else {
            buynum++
            numshowlabel.text = String(buynum)
            notifyUpdateNum()
        }
    }
    
    func reducenum() {
        if (buynum - 1) <= 0 {
            let alert = UIAlertView(title: "提示", message: "请至少购买1件该商品", delegate: self, cancelButtonTitle: "知道了")
            alert.show()
        } else {
            buynum--
            numshowlabel.text = String(buynum)
            notifyUpdateNum()
        }
    }
    
    func notifyUpdateNum() {
        let center = NSNotificationCenter.defaultCenter()
        var dataarray = [String:String]()
        dataarray["buy_num"] = String(buynum)
        center.postNotificationName("updateNum", object: self, userInfo: dataarray)
    }
    
    /**选择规格**/
    func attrchoose(recognizer: UITapGestureRecognizer) {
        let speccode = String(recognizer.view!.tag)
        clearborder(speccode)
        recognizer.view!.layer.borderColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0).CGColor
        var goodsattrcodestr = ""
        for (key,val) in choosespeccode {
            goodsattrcodestr += val + "|"
        }
        let set = NSCharacterSet(charactersInString: "|")
        goodsattrcodestr = goodsattrcodestr.stringByTrimmingCharactersInSet(set)
        for (key,val) in specgoods {
            if key == goodsattrcodestr {
                if goods_id != val {
                    goods_id = val
                    activity.startAnimating()
                    NSThread.detachNewThreadSelector("reloadData", toTarget: self, withObject: nil)
                }
                break
            }
        }
    }
    
    func clearborder(speccode: String) {
        var excspecList = [AnyObject]()
        for attr in attrList {
            for (key,_) in attr.info {
                if key == speccode {
                    let excinfo = attr.info as NSDictionary
                    excspecList = Array(excinfo.allKeys)
                    let attrviewList = attrview as NSDictionary
                    for spec in excspecList {
                        let specval = spec as! String
                        let childview = attrviewList.objectForKey(specval) as! UIView
                        childview.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).CGColor
                    }
                    choosespeccode[attr.name] = key
                    return
                }
            }
        }
    }
    
    /**重新调取商品数据**/
    func reloadData() {
        let url = NSURL(string: API_URL + "index.php?act=goods&op=goods_detail&goods_id=" + goods_id)
        let data = NSData(contentsOfURL: url!)
        if data == nil {
            return
        }
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        if data_array.objectForKey("error") != nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let goods_info = data_array.objectForKey("goods_info") as! NSDictionary
        nameshow.text = goods_info.objectForKey("goods_name") as? String
        let price = goods_info.objectForKey("goods_price") as! String
        let pmprice = goods_info.objectForKey("goods_promotion_price") as! String
        if pmprice != "" {
            priceshow.text = "￥" + pmprice
        } else {
            priceshow.text = "￥" + price
        }
        let goodsimagestr = data_array.objectForKey("goods_image") as! String
        let picList = goodsimagestr.componentsSeparatedByString(",")
        goods_image_url = picList[0]
        if goods_image_url != "" {
            let picurl_arr = goods_image_url.componentsSeparatedByString("/")
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
                    let url = NSURL(string: goods_image_url)!
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
            picview.image = img
        }
        buynum = 1
        numshowlabel.text = String(buynum)
        //通知商品详情页刷新数据
        let center = NSNotificationCenter.defaultCenter()
        var dataarray = [String:String]()
        dataarray["goods_id"] = goods_id
        center.postNotificationName("reloadGoods", object: self, userInfo: dataarray)
        activity.stopAnimating()
    }
    
    //隐藏黑色提示框
    func hidetip() {
        tipshow.hidden = true
    }
    
    /**添加购物车**/
    func addcart() {
        if !islogin() {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let logincontroller = sb.instantiateViewControllerWithIdentifier("LoginViewID") as! LoginViewController
            logincontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(logincontroller, animated: true)
        } else {
            activity.startAnimating()
            let key = getkey()
            let paramstr = NSString(format: "goods_id=%@&quantity=%d&key=%@", goods_id, buynum, key)
            let paramstrlen = paramstr.length
            let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: API_URL + "index.php?act=member_cart&op=cart_add")
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postdata
            let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let data_array: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")
            if let datas = data_array as? String {
                if datas == "1" {
                    tipstr.text = "成功加入购物车"
                    tipimg.image = UIImage(named: "success.png")
                    tipshow.hidden = false
                }
            } else {
                tipstr.text = "加入购物车失败"
                tipimg.image = UIImage(named: "error.png")
                tipshow.hidden = false
            }
            //获取购物车商品数量
            let cartnum = getcartgoodsnum()
            if cartnum > 0 {
                cartnumlabel.text = String(cartnum)
                cartnumshow.hidden = false
            }
            activity.stopAnimating()
            //延时关闭提示框
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
        }
    }
    
    /**获取最新购物车商品数**/
    func getcartgoodsnum() -> Int {
        var num = 0
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
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return num
        }
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        let cart_list: AnyObject! = data_array.objectForKey("cart_list")
        if let cl = cart_list as? NSArray {
            num = cl.count
        }
        return num
    }
    
    /**去购买页面**/
    func gotobuynow() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let buycontroller = sb.instantiateViewControllerWithIdentifier("BuyViewID") as! BuyViewController
        buycontroller.iffcode = fcode
        buycontroller.ifxvni = xvni
        if xvni {
            buycontroller.choosegoods = goods_id
            buycontroller.xvni_num = buynum
        } else {
            buycontroller.choosegoods = goods_id + "|" + String(buynum)
        }
        buycontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(buycontroller, animated: true)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if btnlabel == "确定" {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}