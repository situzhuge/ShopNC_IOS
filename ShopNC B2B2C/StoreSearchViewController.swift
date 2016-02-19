//
//  StoreSearchViewController.swift
//  ShopNC B2B2C
//
//  Created by 李梓平 on 14/12/26.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class StoreSearchViewController: UIViewController, UISearchBarDelegate {
    var store_id = ""
    var ScreenW: CGFloat!
    var topsearchbar: UISearchBar!

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
            topsearchbar.placeholder = "搜索店铺商品                           "
        } else {
            topsearchbar.placeholder = "搜索店铺商品                                       "
        }
        //搜索框父view
        let searchview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        searchview.backgroundColor = UIColor.clearColor()
        searchview.addSubview(topsearchbar)
        self.navigationItem.titleView = searchview
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
        //跳转商品列表页面
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let glcontroller = sb.instantiateViewControllerWithIdentifier("GoodsListID") as! GoodsListViewController
        glcontroller.keyword = topsearchbar.text!
        glcontroller.store_id = store_id
        glcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(glcontroller, animated: true)
    }
}
