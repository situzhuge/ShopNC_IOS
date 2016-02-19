//
//  SearchViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/5.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    var keyword = ""
    var ScreenW: CGFloat!
    var topsearchbar: UISearchBar!
    var nothing: UILabel!
    var shview: UITableView!
    var shlist = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenW = self.view.frame.width
        self.view.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0)
        /**顶部搜索条**/
        topsearchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/10*9, height: 44))
        for sv in topsearchbar.subviews {
            if sv.isKindOfClass(NSClassFromString("UIView")!) && sv.subviews.count>0 {
                sv.subviews.first!.removeFromSuperview()//去掉搜索框的灰色背景
            }
        }
        topsearchbar.delegate = self
        if self.view.frame.width == 320 {
            topsearchbar.placeholder = "搜索商品                             "
        } else {
            topsearchbar.placeholder = "搜索商品                                         "
        }
        if keyword != "" {
            topsearchbar.text = keyword
        }
        //搜索框父view
        let searchview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        searchview.backgroundColor = UIColor.clearColor()
        searchview.addSubview(topsearchbar)
        self.navigationItem.titleView = searchview
        //搜索历史
        let shlabel = UILabel(frame: CGRect(x: 10, y: 15, width: 100, height: 20))
        shlabel.text = "搜索历史记录"
        shlabel.font = UIFont.systemFontOfSize(14)
        shlabel.textColor = UIColor.grayColor()
        self.view.addSubview(shlabel)
        //清空按钮
        let clearbtn = UILabel(frame: CGRect(x: ScreenW-50, y: 15, width: 40, height: 20))
        clearbtn.text = "清空"
        clearbtn.textAlignment = NSTextAlignment.Center
        clearbtn.font = UIFont.systemFontOfSize(12)
        clearbtn.textColor = UIColor.grayColor()
        clearbtn.layer.borderWidth = 1
        clearbtn.layer.borderColor = UIColor.grayColor().CGColor
        clearbtn.layer.cornerRadius = 3
        clearbtn.userInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: "clearHistory")
        clearbtn.addGestureRecognizer(singleTap)
        self.view.addSubview(clearbtn)
        nothing = UILabel(frame: CGRect(x: (ScreenW-200)/2, y: self.view.frame.height/4, width: 200, height: 30))
        nothing.font = UIFont.systemFontOfSize(16)
        nothing.textColor = UIColor.grayColor()
        nothing.text = "暂无任何搜索记录"
        nothing.textAlignment = NSTextAlignment.Center
        self.view.addSubview(nothing)
        shview = UITableView(frame: CGRect(x: 0, y: 40, width: ScreenW, height: self.view.frame.height-64-216))
        shview.dataSource = self
        shview.delegate = self
        shview.backgroundColor = UIColor.clearColor()
        self.view.addSubview(shview)
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
        self.navigationItem.hidesBackButton = true
        topsearchbar.becomeFirstResponder()
        topsearchbar.text = ""
        topsearchbar.tintColor = UIColor.grayColor()
        loadHistoryData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**设置搜索框**/
    //修改取消按钮颜色
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        for sv in searchBar.subviews {
            if sv.isKindOfClass(NSClassFromString("UIView")!) && sv.subviews.count>0 {
                for ssv in sv.subviews {
                    if ssv.isKindOfClass(NSClassFromString("UIButton")!) {
                        let cbtn = ssv as! UIButton
                        cbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                        cbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
                        break
                    }
                }
            }
        }
    }
    
    //设置取消按钮的响应
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    //键盘搜索回调
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //添加搜索历史
        addHistory(topsearchbar.text!)
        //跳转商品列表页面
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let glcontroller = sb.instantiateViewControllerWithIdentifier("GoodsListID") as! GoodsListViewController
        glcontroller.keyword = topsearchbar.text!
        glcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(glcontroller, animated: true)
    }
    
    /**调取历史记录信息**/
    func loadHistoryData() {
        shlist.removeAll(keepCapacity: false)
        let datapath = NSHomeDirectory() + "/Library/Caches/history.txt"
        if NSFileManager.defaultManager().fileExistsAtPath(datapath) {
            let data = NSFileManager.defaultManager().contentsAtPath(datapath)!
            let shstr = NSString(data: data, encoding: NSUTF8StringEncoding)
            let tmpstr = shstr as! String
            let shstr_arr = tmpstr.componentsSeparatedByString(",")
            let allnum = shstr_arr.count
            for var i=allnum-1;i>=0;i-- {
                let sh = shstr_arr[i]
                if sh != "" {
                    shlist.append(sh)
                }
            }
            shview.reloadData()
            shview.hidden = false
            nothing.hidden = true
        } else {
            shview.hidden = true
            nothing.hidden = false
        }
    }
    
    /**添加搜索历史记录**/
    func addHistory(keyword: String) {
        var newstr = ""
        let datapath = NSHomeDirectory() + "/Library/Caches/history.txt"
        if NSFileManager.defaultManager().fileExistsAtPath(datapath) {
            let data = NSFileManager.defaultManager().contentsAtPath(datapath)!
            let shstr = NSString(data: data, encoding: NSUTF8StringEncoding)
            let tmpstr = shstr as! String
            //如果已存在则加到队尾和写入数据后直接返回
            var sh_arr = tmpstr.componentsSeparatedByString(",")
            for (key,val) in sh_arr.enumerate() {
                if val == keyword {
                    sh_arr.removeAtIndex(key)
                    sh_arr.append(val)
                    var str = ""
                    for sh in sh_arr {
                        str += sh + ","
                    }
                    //写入数据
                    let newdata = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                    newdata.writeToFile(datapath, atomically: false)
                    return
                }
            }
            newstr = tmpstr + keyword + ","
        } else {
            newstr = keyword + ","
        }
        //写入数据
        let newdata = newstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        newdata.writeToFile(datapath, atomically: false)
    }
    
    /**清空搜索历史记录**/
    func clearHistory() {
        let filepath = NSHomeDirectory() + "/Library/Caches/history.txt"
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filepath)
        } catch _ {
        }
        loadHistoryData()
    }
    
    /**tableview相关设置**/
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shlist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibregistered = false
        if !nibregistered {
            tableView.registerClass(UITableViewCell().classForCoder, forCellReuseIdentifier: "SearchHistoryCellID")
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchHistoryCellID", forIndexPath: indexPath) 
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        cell.textLabel!.text = shlist[indexPath.row]
        cell.textLabel!.textColor = UIColor.grayColor()
        cell.textLabel!.font = UIFont.systemFontOfSize(14)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //将该搜索记录置顶
        let datapath = NSHomeDirectory() + "/Library/Caches/history.txt"
        if NSFileManager.defaultManager().fileExistsAtPath(datapath) {
            let data = NSFileManager.defaultManager().contentsAtPath(datapath)!
            let shstr = NSString(data: data, encoding: NSUTF8StringEncoding)
            let tmpstr = shstr as! String
            //加到队尾和写入数据
            var sh_arr = tmpstr.componentsSeparatedByString(",")
            for (key,val) in sh_arr.enumerate() {
                if val == shlist[indexPath.row] {
                    sh_arr.removeAtIndex(key)
                    sh_arr.append(val)
                    var str = ""
                    for sh in sh_arr {
                        str += sh + ","
                    }
                    //写入数据
                    let newdata = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                    newdata.writeToFile(datapath, atomically: false)
                }
            }
        }
        //跳转到商品列表界面
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let glcontroller = sb.instantiateViewControllerWithIdentifier("GoodsListID") as! GoodsListViewController
        glcontroller.keyword = shlist[indexPath.row]
        glcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(glcontroller, animated: true)
    }
}