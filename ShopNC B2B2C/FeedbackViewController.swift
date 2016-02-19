//
//  FeedbackViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/18.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    var activity: UIActivityIndicatorView!
    var feedbacktext = UITextView()
    var ScreenWidth: CGFloat!
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenWidth = self.view.frame.width
        self.title = "意见反馈"
        let tiplabel = UILabel(frame: CGRect(x: 10, y: 15, width: 250, height: 20))
        tiplabel.text = "请留下您对我们的宝贵意见或建议"
        tiplabel.font = UIFont.systemFontOfSize(14)
        tiplabel.textColor = UIColor.grayColor()
        self.view.addSubview(tiplabel)
        feedbacktext.frame = CGRect(x: 10, y: 40, width: ScreenWidth-20, height: 120)
        feedbacktext.font = UIFont.systemFontOfSize(14)
        feedbacktext.backgroundColor = UIColor.whiteColor()
        feedbacktext.becomeFirstResponder()
        feedbacktext.autocapitalizationType = UITextAutocapitalizationType.None
        feedbacktext.layer.borderWidth = 1
        feedbacktext.layer.borderColor = UIColor.grayColor().CGColor
        feedbacktext.layer.cornerRadius = 3
        self.view.addSubview(feedbacktext)
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Plain, target: self, action: "submit")
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**保存数据**/
    func submit() {
        let content = feedbacktext.text
        if content == "" {
            tipstr.text = "请填写反馈内容"
            tipimg.image = UIImage(named: "error.png")
            tipshow.hidden = false
            //延时关闭提示框
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
            return
        }
        activity.startAnimating()
        var rs = false
        let key = getkey()
        let paramstr = NSString(format: "key=%@&feedback=%@", key, content)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_feedback&op=feedback_add")
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
        let data_array: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")
        if let data = data_array as? String {
            if data == "1" {
                rs = true
            }
        }
        if rs {
            tipstr.text = "提交成功"
            tipimg.image = UIImage(named: "success.png")
            tipshow.hidden = false
            //延时关闭提示框
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
            feedbacktext.text == ""
        } else {
            tipstr.text = "提交失败"
            tipimg.image = UIImage(named: "error.png")
            tipshow.hidden = false
            //延时关闭提示框
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
        }
        activity.stopAnimating()
    }
    
    //隐藏黑色提示框
    func hidetip() {
        tipshow.hidden = true
    }
}
