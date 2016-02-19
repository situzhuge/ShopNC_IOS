//
//  GoodsParamViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/18.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class GoodsParamViewController: UITableViewController {
    var goodsparamList = [Goodsparammodel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "产品参数"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    /**设置tableview**/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsparamList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibregistered = false
        if !nibregistered {
            tableView.registerClass(UITableViewCell().classForCoder, forCellReuseIdentifier: "GoodsparamcellID")
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("GoodsparamcellID", forIndexPath: indexPath) 
        cell.textLabel!.text = goodsparamList[indexPath.row].title + " : " + goodsparamList[indexPath.row].value
        cell.textLabel!.font = UIFont.systemFontOfSize(14)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
}