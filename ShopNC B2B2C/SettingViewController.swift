//
//  SettingViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/27.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    var ScreenWidth: CGFloat!
    var funcBtnList = ["发票管理", "清理图片缓存"]
    var aboutBtnList = ["在线帮助", "意见反馈", "关于我们"]
    var logoutBtn: UIButton!
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "更多"
        ScreenWidth = self.view.frame.width
        self.view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        let settingtableview = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: self.view.frame.height-64), style: UITableViewStyle.Grouped)
        settingtableview.backgroundColor = UIColor.whiteColor()
        settingtableview.delegate = self
        settingtableview.dataSource = self
        settingtableview.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 1.0)
        self.view.addSubview(settingtableview)
        /**退出按钮**/
        logoutBtn = UIButton(frame: CGRect(x: 10, y: 290, width: ScreenWidth-20, height: 40))
        logoutBtn.backgroundColor = UIColor(red: 196/255, green: 0/255, blue: 8/255, alpha: 1.0)
        logoutBtn.layer.cornerRadius = 3
        logoutBtn.addTarget(self, action: "logout", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBtn.setTitle("退出登录", forState: UIControlState.Normal)
        logoutBtn.titleLabel?.font = UIFont.systemFontOfSize(18)
        logoutBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        settingtableview.addSubview(logoutBtn)
        if !islogin() {
            logoutBtn.hidden = true
        }
        /**添加黑色提示框**/
        tipshow.frame = CGRect(x: (ScreenWidth-180)/2, y: (self.view.frame.height-80)/3, width: 180, height: 80)
        tipshow.backgroundColor = UIColor.clearColor()
        tipshow.layer.cornerRadius = 10
        let tipbg = UIImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 80))
        tipbg.image = UIImage(named: "tipbg.png")
        tipshow.addSubview(tipbg)
        tipstr = UILabel(frame: CGRect(x: 10, y: 45, width: 160, height: 20))
        tipstr.font = UIFont.systemFontOfSize(18)
        tipstr.textAlignment = NSTextAlignment.Center
        tipstr.textColor = UIColor.whiteColor()
        tipshow.addSubview(tipstr)
        tipimg.frame = CGRect(x: 75, y: 10, width: 30, height: 30)
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
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**表格相关设置**/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibregistered = false
        if !nibregistered {
            tableView.registerClass(UITableViewCell().classForCoder, forCellReuseIdentifier: "SettingCellID")
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingCellID", forIndexPath: indexPath) 
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if indexPath.section == 0 {
            cell.textLabel!.text = funcBtnList[indexPath.row] as String
        } else {
            cell.textLabel!.text = aboutBtnList[indexPath.row] as String
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //发票管理
        if indexPath.section == 0 && indexPath.row == 0 {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let invlistcontroller = sb.instantiateViewControllerWithIdentifier("InvoiceListViewID") as! InvoiceListViewController
            invlistcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(invlistcontroller, animated: true)
        }
        //清理图片缓存
        if indexPath.section == 0 && indexPath.row == 1 {
            let alert = UIAlertView(title: "提示", message: "确定要清理图片缓存吗？", delegate: self, cancelButtonTitle: "否", otherButtonTitles: "是")
            alert.tag = 2
            alert.show()
        }
        //在线帮助
        if indexPath.section == 1 && indexPath.row == 0 {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let wvcontroller = sb.instantiateViewControllerWithIdentifier("WebViewID") as! WebViewController
            wvcontroller.navititle = "在线帮助"
            wvcontroller.urlstr = API_URL + "help.html"
            wvcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(wvcontroller, animated: true)
        }
        //意见反馈
        if indexPath.section == 1 && indexPath.row == 1 {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let fbcontroller = sb.instantiateViewControllerWithIdentifier("FeedbackViewID") as! FeedbackViewController
            fbcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(fbcontroller, animated: true)
        }
        //关于我们
        if indexPath.section == 1 && indexPath.row == 2 {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let abcontroller = sb.instantiateViewControllerWithIdentifier("AboutusViewID") as! AboutusViewController
            abcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(abcontroller, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    /**退出登录**/
    func logout() {
        let alert = UIAlertView(title: "提示", message: "确定要退出登录吗？", delegate: self, cancelButtonTitle: "否", otherButtonTitles: "是")
        alert.tag = 1
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if alertView.tag == 1 && btnlabel == "是" {
            dologout()
        }
        if alertView.tag == 2 && btnlabel == "是" {
            clearcache()
        }
    }
    
    func dologout() {
        let filepath = NSHomeDirectory() + "/Library/Caches/login.txt"
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filepath)
        } catch _ {
        }
        //通知用户中心清空数据
        let center = NSNotificationCenter.defaultCenter()
        center.postNotificationName("clearData", object: self, userInfo: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**清理图片缓存**/
    func clearcache() {
        let goodscachepath = NSHomeDirectory() + "/Library/Caches/Goods/"
        var allcachefiles = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(goodscachepath)
        for item in allcachefiles! as [String] {
            let filepath = NSHomeDirectory() + "/Library/Caches/Goods/" + item
            do {
                try NSFileManager.defaultManager().removeItemAtPath(filepath)
            } catch _ {
            }
        }
        let gccachepath = NSHomeDirectory() + "/Library/Caches/GoodsClass/"
        allcachefiles = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(gccachepath)
        for item in allcachefiles! as [String] {
            let filepath = NSHomeDirectory() + "/Library/Caches/GoodsClass/" + item
            do {
                try NSFileManager.defaultManager().removeItemAtPath(filepath)
            } catch _ {
            }
        }
        let avtcachepath = NSHomeDirectory() + "/Library/Caches/Avatar/"
        allcachefiles = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(avtcachepath)
        for item in allcachefiles! as [String] {
            let filepath = NSHomeDirectory() + "/Library/Caches/Avatar/" + item
            do {
                try NSFileManager.defaultManager().removeItemAtPath(filepath)
            } catch _ {
            }
        }
        let advcachepath = NSHomeDirectory() + "/Library/Caches/Adv/"
        allcachefiles = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(advcachepath)
        for item in allcachefiles! as [String] {
            let filepath = NSHomeDirectory() + "/Library/Caches/Avatar/" + item
            do {
                try NSFileManager.defaultManager().removeItemAtPath(filepath)
            } catch _ {
            }
        }
        tipstr.text = "图片缓存清除成功"
        tipimg.image = UIImage(named: "success.png")
        tipshow.hidden = false
        //延时关闭提示框
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
    }
    
    //隐藏黑色提示框
    func hidetip() {
        tipshow.hidden = true
    }
}