//
//  GoodsSubClassViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/7.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class GoodsSubClassViewController: UITableViewController, UIAlertViewDelegate {
    var goodsclassList = [Goodsclassmodel]()
    var navititle = ""
    var gc_id = ""
    var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navititle
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
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        self.tabBarController?.tabBar.translucent = true
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() {
        let url = NSURL(string: API_URL + "index.php?act=goods_class&gc_id=" + gc_id)
        let data = NSData(contentsOfURL: url!)
        if data == nil {
            activity.stopAnimating()
            tableView.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.tag = 1
            alert.show()
            return
        }
        let datas: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")!.objectForKey("class_list")
        if let data_array = datas as? NSArray {
            let seeall = Goodsclassmodel()
            seeall.gc_name = navititle
            goodsclassList.append(seeall)
            for var i=0;i<data_array.count;i++ {
                let newgc = Goodsclassmodel()
                let datagc = data_array.objectAtIndex(i) as! NSDictionary
                newgc.gc_id = datagc.objectForKey("gc_id") as! String
                newgc.gc_name = datagc.objectForKey("gc_name") as! String
                goodsclassList.append(newgc)
            }
        } else {
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.tag = 2
            alert.show()
        }
        activity.stopAnimating()
        tableView.hidden = false
        tableView.reloadData()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if alertView.tag != 3 && btnlabel == "确定" {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsclassList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibregistered = false
        if !nibregistered {
            tableView.registerClass(UITableViewCell().classForCoder, forCellReuseIdentifier: "GoodsSubClassCellID")
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("GoodsSubClassCellID", forIndexPath: indexPath) 
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        if indexPath.row == 0 {
            cell.textLabel!.text = "查看全部商品"
        } else {
            cell.textLabel!.text = goodsclassList[indexPath.row].gc_name
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let glcontroller = sb.instantiateViewControllerWithIdentifier("GoodsListID") as! GoodsListViewController
            glcontroller.gc_id = gc_id
            glcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(glcontroller, animated: true)
            return
        }
        let url = NSURL(string: API_URL + "index.php?act=goods_class&gc_id=" + goodsclassList[indexPath.row].gc_id)
        let data = NSData(contentsOfURL: url!)
        if data == nil {
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.tag = 3
            alert.show()
            return
        }
        let data_array: AnyObject = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")!.objectForKey("class_list")!
        if data_array.isKindOfClass(NSClassFromString("NSArray")!) {//进入子类目
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let gsccontroller = sb.instantiateViewControllerWithIdentifier("GoodsSubClassID") as! GoodsSubClassViewController
            gsccontroller.navititle = goodsclassList[indexPath.row].gc_name
            gsccontroller.gc_id = goodsclassList[indexPath.row].gc_id
            self.navigationController?.pushViewController(gsccontroller, animated: true)
        } else {//进入商品列表
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let glcontroller = sb.instantiateViewControllerWithIdentifier("GoodsListID") as! GoodsListViewController
            glcontroller.gc_id = goodsclassList[indexPath.row].gc_id
            glcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(glcontroller, animated: true)
        }
    }
}