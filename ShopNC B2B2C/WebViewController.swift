//
//  WebViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/17.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var navititle = ""
    var webview = UIWebView()
    var urlstr = ""
    var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navititle
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        webview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-64)
        webview.scalesPageToFit = true
        self.view.addSubview(webview)
        let final_url = urlstr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let url = NSURL(string: final_url!)
        let request = NSURLRequest(URL: url!)
        webview.loadRequest(request)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**webview的加载设置**/
    func webViewDidStartLoad(webView: UIWebView) {
        activity.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activity.stopAnimating()
    }
}
