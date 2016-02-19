//
//  ShipInfoViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/5.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class ShipInfoViewController: UIViewController, UIAlertViewDelegate {
    var order_id = ""
    var screenW: CGFloat!
    var shipname: UILabel!
    var shipcode: UILabel!
    var shipinfoview: UIScrollView!
    var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "查看物流"
        screenW = self.view.frame.width
        self.view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: 65))
        titleview.backgroundColor = UIColor(red: 75/255, green: 87/255, blue: 114/255, alpha: 1.0)
        self.view.addSubview(titleview)
        shipname = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 20))
        shipname.font = UIFont.systemFontOfSize(18)
        shipname.textColor = UIColor.whiteColor()
        titleview.addSubview(shipname)
        shipcode = UILabel(frame: CGRect(x: 10, y: 35, width: 300, height: 20))
        shipcode.font = UIFont.systemFontOfSize(16)
        shipcode.textColor = UIColor.whiteColor()
        titleview.addSubview(shipcode)
        let shipinfotitle = UIView(frame: CGRect(x: 0, y: 75, width: screenW, height: 40))
        shipinfotitle.backgroundColor = UIColor.whiteColor()
        shipinfotitle.layer.borderWidth = 1
        shipinfotitle.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).CGColor
        self.view.addSubview(shipinfotitle)
        let shipinfotitlelabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
        shipinfotitlelabel.font = UIFont.systemFontOfSize(14)
        shipinfotitlelabel.text = "物流信息"
        shipinfotitle.addSubview(shipinfotitlelabel)
        shipinfoview = UIScrollView(frame: CGRect(x: 0, y: 115, width: screenW, height: self.view.frame.height-115-64))
        shipinfoview.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(shipinfoview)
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        activity.startAnimating()
        NSThread.detachNewThreadSelector("loadData", toTarget: self, withObject: nil)
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
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**加载网络数据**/
    func loadData() {
        let key = getkey()
        let paramstr = NSString(format: "key=%@&order_id=%@", key, order_id)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_order&op=search_deliver")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if respdata == nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let datas_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        if datas_array.objectForKey("error") != nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        if datas_array.objectForKey("express_name") != nil {
            shipname.text = datas_array.objectForKey("express_name") as? String
        }
        if datas_array.objectForKey("shipping_code") != nil {
            let code = datas_array.objectForKey("shipping_code") as? String
            shipcode.text = "运单编号：" + code!
        }
        if datas_array.objectForKey("deliver_info") != nil {
            let shipinfo = datas_array.objectForKey("deliver_info") as! NSArray
            var height = CGFloat(10)
            for i in shipinfo {
                let info = i as! NSDictionary
                let time = UILabel(frame: CGRect(x: 10, y: height, width: screenW-20, height: 20))
                time.font = UIFont.systemFontOfSize(14)
                let timestr = info.objectForKey("time") as! String
                time.text = "*" + timestr
                shipinfoview.addSubview(time)
                height += 20
                let context = UILabel(frame: CGRect(x: 10, y: height, width: screenW-20, height: 20))
                context.font = UIFont.systemFontOfSize(14)
                let contextstr = info.objectForKey("context") as! String
                context.text = contextstr
                shipinfoview.addSubview(context)
                height += 30
            }
            shipinfoview.contentSize = CGSizeMake(0, height)
        }
        activity.stopAnimating()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if btnlabel == "确定" {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}