//
//  StoreClassViewController.swift
//  ShopNC B2B2C
//
//  Created by 李梓平 on 14/12/26.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class StoreClassViewController: UITableViewController, UISearchBarDelegate {
    var activity: UIActivityIndicatorView!
    var ScreenW: CGFloat!
    var topsearchbar: UISearchBar!
    var store_id = ""
    var pclass_id = ""
    var pclass_name = ""
    var storeclass = [Goodsclassmodel]()
    var subclassList = [String:[Goodsclassmodel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenW = self.view.frame.width
        if pclass_name == "" {
            /**顶部搜索条**/
            topsearchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: ScreenW/6*5, height: 44))
            for sv in topsearchbar.subviews {
                if sv.isKindOfClass(NSClassFromString("UIView")!) && sv.subviews.count>0 {
                    sv.subviews.first!.removeFromSuperview()//去掉搜索框的灰色背景
                }
            }
            topsearchbar.delegate = self
            topsearchbar.placeholder = "搜索店铺内商品"
            //搜索框父view
            let searchview = UIView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 44))
            searchview.backgroundColor = UIColor.clearColor()
            searchview.addSubview(topsearchbar)
            self.navigationItem.titleView = searchview
        } else {
            self.title = pclass_name
        }
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
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
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**加载店铺分类数据**/
    func loadData() {
        if storeclass.isEmpty {
            let url = NSURL(string: API_URL + "index.php?act=store&op=store_goods_class&store_id=" + store_id)
            let data = NSData(contentsOfURL: url!)
            if data == nil {
                activity.stopAnimating()
                let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                return
            }
            let data_array = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
            let class_array_data: AnyObject! = data_array.objectForKey("store_goods_class")
            if let class_array = class_array_data as? NSArray {
                let seeallgoods = Goodsclassmodel()
                seeallgoods.gc_id = "0"
                seeallgoods.gc_name = "查看全部商品"
                storeclass.append(seeallgoods)
                for i in class_array {
                    let classinfo = i as! NSDictionary
                    let pidval:AnyObject! = classinfo.objectForKey("pid")
                    let pid = String(pidval)
                    if pid == "0" {
                        let newrootclass = Goodsclassmodel()
                        newrootclass.gc_id = classinfo.objectForKey("id") as! String
                        newrootclass.gc_name = classinfo.objectForKey("name") as! String
                        storeclass.append(newrootclass)
                        subclassList[newrootclass.gc_id] = [Goodsclassmodel]()
                        subclassList[newrootclass.gc_id]!.append(seeallgoods)
                    } else {
                        let newsubclass = Goodsclassmodel()
                        newsubclass.gc_id = classinfo.objectForKey("id") as! String
                        newsubclass.gc_name = classinfo.objectForKey("name") as! String
                        subclassList[pid]?.append(newsubclass)
                    }
                }
            } else {
                activity.stopAnimating()
                let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                return
            }
        }
        tableView.reloadData()
        activity.stopAnimating()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if btnlabel == "确定" {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    /**tableview相关设置**/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeclass.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibregistered = false
        if !nibregistered {
            tableView.registerClass(UITableViewCell().classForCoder, forCellReuseIdentifier: "StoreClassCellID")
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("StoreClassCellID", forIndexPath: indexPath) 
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        cell.textLabel!.text = storeclass[indexPath.row].gc_name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sc_id = storeclass[indexPath.row].gc_id
        if pclass_name == "" && (sc_id != "0" && !subclassList[sc_id]!.isEmpty) {//跳转到店铺二级分类页面
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let sccontroller = sb.instantiateViewControllerWithIdentifier("StoreClassViewID") as! StoreClassViewController
            sccontroller.store_id = store_id
            sccontroller.pclass_id = storeclass[indexPath.row].gc_id
            sccontroller.pclass_name = storeclass[indexPath.row].gc_name
            sccontroller.storeclass = subclassList[sc_id]!
            sccontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sccontroller, animated: true)
        } else {//跳转到商品列表页面
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let glcontroller = sb.instantiateViewControllerWithIdentifier("GoodsListID") as! GoodsListViewController
            glcontroller.store_id = store_id
            if pclass_name == "" && sc_id == "0" {
                glcontroller.stc_name = "全部店铺商品"
            } else {
                if pclass_name != "" && sc_id == "0" {
                    glcontroller.stc_name = pclass_name
                    glcontroller.stc_id = pclass_id
                } else {
                    glcontroller.stc_name = storeclass[indexPath.row].gc_name
                    glcontroller.stc_id = sc_id
                }
            }
            glcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(glcontroller, animated: true)
        }
    }
    
    /**设置搜索框**/
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let ssvcontroller = sb.instantiateViewControllerWithIdentifier("StoreSearchViewID") as! StoreSearchViewController
        ssvcontroller.store_id = store_id
        ssvcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ssvcontroller, animated: false)
    }
}