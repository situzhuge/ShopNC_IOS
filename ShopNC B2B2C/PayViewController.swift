//
//  PayViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/8.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {
    var pay_sn = ""
    var order_sn = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "在线支付"
        let webview = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-64))
        webview.scalesPageToFit = true
        self.view.addSubview(webview)
        if pay_sn != "" {
            let url = NSURL(string: API_URL + "index.php?act=member_payment&op=pay&pay_sn=" + pay_sn + "&key=" + getkey())
            let request = NSURLRequest(URL: url!)
            webview.loadRequest(request)
        }
        if order_sn != "" {
            let url = NSURL(string: API_URL + "index.php?act=member_payment&op=vr_pay&pay_sn=" + order_sn + "&key=" + getkey())
            let request = NSURLRequest(URL: url!)
            webview.loadRequest(request)
        }
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
}