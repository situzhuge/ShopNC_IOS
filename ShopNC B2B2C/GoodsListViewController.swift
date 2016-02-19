//
//  GoodsListViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/10.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class GoodsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate {
    var goodsList = [Goodsmodel]()
    var gc_id = ""
    var keyword = ""
    var ScreenW: CGFloat!
    var curpage = 1
    var page = 10
    var newgoods: UILabel!
    var pricesort: UILabel!
    var salenumsort: UILabel!
    var clicksort: UILabel!
    var orderstr = ""
    var goodslistview: UITableView!
    var pricesortimg: UIImageView!
    var filterview: UIView!
    var haveMore = true
    var statusbar_hidden = false
    var activity: UIActivityIndicatorView!
    var topsearchbar: UISearchBar!
    var barcode = ""
    //店铺商品
    var store_id = ""
    var stc_id = ""
    var stc_name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenW = self.view.frame.width
        if barcode != "" {
            stc_name = "条码扫描结果"
        }
        if stc_name == "" {
            /**顶部搜索条**/
            topsearchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/6*5, height: 44))
            for sv in topsearchbar.subviews {
                if sv.isKindOfClass(NSClassFromString("UIView")!) && sv.subviews.count>0 {
                    sv.subviews.first!.removeFromSuperview()//去掉搜索框的灰色背景
                }
            }
            topsearchbar.delegate = self
            if store_id != "" {
                topsearchbar.placeholder = "搜索店铺内商品"
            } else {
                if self.view.frame.width == 320 {
                    topsearchbar.placeholder = "搜索商品                                       "
                } else {
                    topsearchbar.placeholder = "搜索商品                                                   "
                }
            }
            if keyword != "" {
                topsearchbar.text = keyword
            }
            //搜索框父view
            let searchview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
            searchview.backgroundColor = UIColor.clearColor()
            searchview.addSubview(topsearchbar)
            self.navigationItem.titleView = searchview
        } else {
            self.title = stc_name
        }
        /**页面布局**/
        //过滤器
        filterview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        filterview.backgroundColor = UIColor.whiteColor()
        filterview.layer.borderWidth = 0.5
        filterview.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1.0).CGColor
        self.view.addSubview(filterview)
        
        newgoods = UILabel(frame: CGRect(x: 0, y: 10, width: ScreenW/4, height: 20))
        newgoods.font = UIFont.systemFontOfSize(14)
        newgoods.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        newgoods.text = "新品"
        newgoods.tag = 1
        newgoods.textAlignment = NSTextAlignment.Center
        newgoods.userInteractionEnabled = true
        let newgoods_singleTap = UITapGestureRecognizer(target: self, action: "filter:")
        newgoods.addGestureRecognizer(newgoods_singleTap)
        filterview.addSubview(newgoods)
        
        pricesort = UILabel(frame: CGRect(x: ScreenW/4, y: 10, width: ScreenW/4, height: 20))
        pricesort.font = UIFont.systemFontOfSize(14)
        pricesort.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        pricesort.text = "价格"
        pricesort.tag = 4//默认按价格升序排列
        pricesort.textAlignment = NSTextAlignment.Center
        pricesort.userInteractionEnabled = true
        let pricesort_singleTap = UITapGestureRecognizer(target: self, action: "filter:")
        pricesort.addGestureRecognizer(pricesort_singleTap)
        filterview.addSubview(pricesort)
        pricesortimg = UIImageView(frame: CGRect(x: ScreenW/3+30, y: 18, width: 7, height: 4))
        pricesortimg.hidden = true
        filterview.addSubview(pricesortimg)
        
        salenumsort = UILabel(frame: CGRect(x: ScreenW/2, y: 10, width: ScreenW/4, height: 20))
        salenumsort.font = UIFont.systemFontOfSize(14)
        salenumsort.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        salenumsort.text = "销量"
        salenumsort.tag = 2
        salenumsort.textAlignment = NSTextAlignment.Center
        salenumsort.userInteractionEnabled = true
        let salenumsort_singleTap = UITapGestureRecognizer(target: self, action: "filter:")
        salenumsort.addGestureRecognizer(salenumsort_singleTap)
        filterview.addSubview(salenumsort)
        
        clicksort = UILabel(frame: CGRect(x: ScreenW/4*3, y: 10, width: ScreenW/4, height: 20))
        clicksort.font = UIFont.systemFontOfSize(14)
        clicksort.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        clicksort.text = "人气"
        clicksort.tag = 3
        clicksort.textAlignment = NSTextAlignment.Center
        clicksort.userInteractionEnabled = true
        let clicksort_singleTap = UITapGestureRecognizer(target: self, action: "filter:")
        clicksort.addGestureRecognizer(clicksort_singleTap)
        filterview.addSubview(clicksort)
        //商品列表
        goodslistview = UITableView(frame: CGRect(x: 0, y: 40, width: ScreenW, height: self.view.frame.height-104), style: UITableViewStyle.Plain)
        goodslistview.delegate = self
        goodslistview.dataSource = self
        self.view.addSubview(goodslistview)
        goodslistview.hidden = true
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        NSThread.detachNewThreadSelector("refreshData", toTarget: self, withObject: nil)
    }
    
    func loadData() {
        var urlstr = ""
        if store_id == "" {
            urlstr = API_URL + "index.php?act=goods&op=goods_list&page=" + String(page) + "&curpage=" + String(curpage)
        } else {
            urlstr = API_URL + "index.php?act=store&op=store_goods&page=" + String(page) + "&curpage=" + String(curpage) + "&store_id=" + store_id
        }
        if gc_id != "" {
            urlstr += "&gc_id=" + gc_id
        }
        if stc_id != "" {
            urlstr += "&stc_id=" + stc_id
        }
        if keyword != "" {
            urlstr += "&keyword=" + keyword
        }
        if barcode != "" {
            urlstr += "&barcode=" + barcode
        }
        if orderstr != "" {
            urlstr += orderstr
        }
        let final_url = urlstr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        //NSLog("%@", urlstr);
        let url = NSURL(string: final_url!)
        let data = NSData(contentsOfURL: url!)
        if data == nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let json_array = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
        let datas: AnyObject! = json_array.objectForKey("datas")!.objectForKey("goods_list")
        if let data_array = datas as? NSArray {
            let havemorestr = json_array.objectForKey("hasmore") as! Int
            if havemorestr == 1 {
                haveMore = true
            } else {
                haveMore = false
            }
            for var i=0;i<data_array.count;i++ {
                let newgoods = Goodsmodel()
                let goodsdata = data_array.objectAtIndex(i) as! NSDictionary
                newgoods.goods_id = goodsdata.objectForKey("goods_id") as! String
                newgoods.goods_name = goodsdata.objectForKey("goods_name") as! String
                newgoods.goods_price = goodsdata.objectForKey("goods_price") as! String
                newgoods.goods_salenum = goodsdata.objectForKey("goods_salenum") as! String
                newgoods.goods_eval_star = goodsdata.objectForKey("evaluation_good_star") as! String
                newgoods.godos_eval_count = goodsdata.objectForKey("evaluation_count") as! String
                newgoods.goods_image = goodsdata.objectForKey("goods_image_url") as! String
                newgoods.goods_mprice = goodsdata.objectForKey("goods_marketprice") as! String
                let group_flag: AnyObject! = goodsdata.objectForKey("group_flag")
                if let gf = group_flag as? Int {
                    if gf == 1 {
                        newgoods.is_group = true
                    }
                }
                let xianshi_flag: AnyObject! = goodsdata.objectForKey("xianshi_flag")
                if let xf = xianshi_flag as? Int {
                    if xf == 1 {
                        newgoods.is_xianshi = true
                    }
                }
                let is_fcode = goodsdata.objectForKey("is_fcode") as! String
                if is_fcode == "1" { newgoods.is_fcode = true }
                let is_virtual = goodsdata.objectForKey("is_virtual") as! String
                if is_virtual == "1" { newgoods.is_xvni = true }
                let is_presell = goodsdata.objectForKey("is_presell") as! String
                if is_presell == "1" { newgoods.is_presale = true }
                let have_gift = goodsdata.objectForKey("have_gift") as! String
                if have_gift == "1" { newgoods.have_gift = true }
                goodsList.append(newgoods)
            }
        } else {
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
        }
        activity.stopAnimating()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if btnlabel == "确定" {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func refreshData() {
        activity.startAnimating()
        goodsList.removeAll(keepCapacity: false)
        curpage = 1
        loadData()
        if goodsList.isEmpty {
            goodslistview.hidden = true
            let nothing = UILabel(frame: CGRect(x: (ScreenW-200)/2, y: self.view.frame.height/3, width: 200, height: 30))
            nothing.font = UIFont.systemFontOfSize(16)
            nothing.textColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
            nothing.text = "这里空空如也哦~"
            nothing.textAlignment = NSTextAlignment.Center
            self.view.addSubview(nothing)
        } else {
            goodslistview.hidden = false
            goodslistview.contentOffset.y = 0
            goodslistview.reloadData()
        }
    }
    
    func addData() {
        if haveMore {
            activity.startAnimating()
            curpage++
            loadData()
            goodslistview.reloadData()
        }
    }
    
    /**过滤器**/
    func filter(recognizer: UITapGestureRecognizer) {
        switch recognizer.view!.tag {
            case 1://新品
                if store_id == "" { orderstr = "" } else { orderstr = "&key=1&order=2" }
                clearfilter()
                newgoods.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
            case 2://销量
                if store_id == "" { orderstr = "&key=1&order=2" } else { orderstr = "&key=3&order=2" }
                clearfilter()
                salenumsort.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
            case 3://人气
                if store_id == "" { orderstr = "&key=2&order=2" } else { orderstr = "&key=4&order=2" }
                clearfilter()
                clicksort.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
            case 4://价格升序
                if store_id == "" { orderstr = "&key=3&order=1" } else { orderstr = "&key=2&order=1" }
                clearfilter()
                pricesort.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
                pricesortimg.image = UIImage(named: "uparrow.png")
                pricesortimg.hidden = false
                pricesort.tag = 5
            case 5://价格降序
                if store_id == "" { orderstr = "&key=3&order=2" } else { orderstr = "&key=2&order=2" }
                clearfilter()
                pricesort.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
                pricesortimg.image = UIImage(named: "downarrow.png")
                pricesortimg.hidden = false
            default://新品
                if store_id == "" { orderstr = "" } else { orderstr = "&key=1&order=2" }
                clearfilter()
                newgoods.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        }
        NSThread.detachNewThreadSelector("refreshData", toTarget: self, withObject: nil)
    }
    
    func clearfilter() {
        newgoods.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        pricesort.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        salenumsort.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        clicksort.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        pricesortimg.hidden = true
        pricesort.tag = 4
    }
    
    /**设置顶部状态栏**/
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return statusbar_hidden
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
        UIView.setAnimationsEnabled(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**tableview设置**/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsList.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibname = ""
        var cellID = ""
        if ScreenW == 320 {
            nibname = "GoodsListCell"
            cellID = "GoodsListCellID"
        }
        if ScreenW == 375 {
            nibname = "GoodsListCell375"
            cellID = "GoodsListCellID375"
        }
        if ScreenW == 414 {
            nibname = "GoodsListCell414"
            cellID = "GoodsListCellID414"
        }
        var nibregistered = false
        if !nibregistered {
            let nib = UINib(nibName: nibname, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: cellID)
            nibregistered = true
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! GoodsListCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.goodsname.text = goodsList[indexPath.row].goods_name
        cell.goodsprice.text = goodsList[indexPath.row].goods_price
        cell.salenum.text = goodsList[indexPath.row].goods_salenum
        cell.commentnum.text = "（" + goodsList[indexPath.row].godos_eval_count + "人）"
        cell.star_1.image = UIImage(named: "star-empty.png")
        cell.star_2.image = UIImage(named: "star-empty.png")
        cell.star_3.image = UIImage(named: "star-empty.png")
        cell.star_4.image = UIImage(named: "star-empty.png")
        cell.star_5.image = UIImage(named: "star-empty.png")
        let evalstar_str = goodsList[indexPath.row].goods_eval_star
        let evalstar = Int(evalstar_str)
        if  evalstar > 0 {
            for var i=1;i<=evalstar;i++ {
                if i == 1 { cell.star_1.image = UIImage(named: "star-full.png") }
                if i == 2 { cell.star_2.image = UIImage(named: "star-full.png") }
                if i == 3 { cell.star_3.image = UIImage(named: "star-full.png") }
                if i == 4 { cell.star_4.image = UIImage(named: "star-full.png") }
                if i == 5 { cell.star_5.image = UIImage(named: "star-full.png") }
            }
        }
        if !goodsList[indexPath.row].have_gift { cell.zengpin.hidden = true } else { cell.zengpin.hidden = false }
        if !goodsList[indexPath.row].is_xvni { cell.xvni.hidden = true } else { cell.xvni.hidden = false }
        if !goodsList[indexPath.row].is_group { cell.tuangou.hidden = true } else { cell.tuangou.hidden = false }
        if !goodsList[indexPath.row].is_presale { cell.yvshou.hidden = true } else { cell.yvshou.hidden = false }
        if !goodsList[indexPath.row].is_xianshi { cell.xianshi.hidden = true } else { cell.xianshi.hidden = false }
        if !goodsList[indexPath.row].is_fcode { cell.fma.hidden = true } else { cell.fma.hidden = false }
        /**图片的延时加载**/
        let cellimgdata: NSArray = [cell, indexPath.row]
        NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
        return cell
    }
    
    func uploadImageForCellAtIndexPath(cellimgdata: NSArray) {
        let rownum = cellimgdata.objectAtIndex(1) as! Int
        let picurl = goodsList[rownum].goods_image
        let picurl_arr = picurl.componentsSeparatedByString("/")
        var img: UIImage
        var data: NSData!
        if picurl_arr[picurl_arr.count - 1] == "" {
            img = UIImage(named: "goods_nopic.png")!
        } else {
            //调用图片缓存or从网络抓取图片数据
            let imagedatapath = NSHomeDirectory() + "/Library/Caches/Goods/" + picurl_arr[picurl_arr.count - 1]
            if NSFileManager.defaultManager().fileExistsAtPath(imagedatapath) {
                data = NSFileManager.defaultManager().contentsAtPath(imagedatapath)!
            } else {
                let url = NSURL(string: picurl)!
                data = NSData(contentsOfURL: url)
                if data != nil {
                    data.writeToFile(imagedatapath, atomically: false)
                }
            }
            if data != nil {
                img = UIImage(data: data)!
            } else {
                img = UIImage(named: "goods_nopic.png")!
            }
        }
        let cell = cellimgdata.objectAtIndex(0) as! GoodsListCell
        cell.pic.image = img
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let gdcontroller = sb.instantiateViewControllerWithIdentifier("GoodsDetailID") as! GoodsDetailViewController
        gdcontroller.goods_id = goodsList[indexPath.row].goods_id
        gdcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gdcontroller, animated: true)
    }
    
    /**tableview滑动控制**/
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let nowoffsetY = goodslistview.contentOffset.y
        let cellsH = 120*page
        let addOffsetY = Float(cellsH*curpage) - Float(self.view.frame.height) + Float(40)
        if Float(nowoffsetY) >= addOffsetY {
            NSThread.detachNewThreadSelector("addData", toTarget: self, withObject: nil)
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            statusbar_hidden = true
            self.setNeedsStatusBarAppearanceUpdate()
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            filterview.hidden = true
            goodslistview.frame = self.view.frame
        } else {
            statusbar_hidden = false
            self.setNeedsStatusBarAppearanceUpdate()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            filterview.hidden = false
            goodslistview.frame = CGRect(x: 0, y: 40, width: ScreenW, height: self.view.frame.height-40)
        }
    }
    
    /**设置搜索框**/
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if store_id == "" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let svcontroller = sb.instantiateViewControllerWithIdentifier("SearchViewID") as! SearchViewController
            svcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(svcontroller, animated: false)
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let ssvcontroller = sb.instantiateViewControllerWithIdentifier("StoreSearchViewID") as! StoreSearchViewController
            ssvcontroller.store_id = store_id
            ssvcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(ssvcontroller, animated: false)
        }
    }
}