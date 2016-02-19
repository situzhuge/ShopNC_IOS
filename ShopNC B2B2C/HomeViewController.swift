//
//  HomeViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/15.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

//class HomeViewController: UITableViewController, UIScrollViewDelegate, UISearchBarDelegate {
class HomeViewController: UITableViewController, UISearchBarDelegate {
    var activity: UIActivityIndicatorView!
    var ScreenW: CGFloat!
    var homeCellList = [Ordercellmodel]()
    var advcell = HomeAdvCell()
    var timer = NSTimer()
    var adv_totalnum = 0
    var finishLoad = false
    var clickData = [String:[String]]()
    var clicknum = 0
    var haveFocus = false
    var topsearchbar: UISearchBar!
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSThread.sleepForTimeInterval(1)
        ScreenW = self.view.frame.width
        /**顶部搜索条**/
        if ScreenW == 320 {
            topsearchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.55, height: 44))
        } else {
            topsearchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/5*3, height: 44))
        }
        for sv in topsearchbar.subviews {
            if sv.isKindOfClass(NSClassFromString("UIView")!) && sv.subviews.count>0 {
                sv.subviews.first!.removeFromSuperview()//去掉搜索框的灰色背景
            }
        }
        topsearchbar.delegate = self
        if self.view.frame.width == 320 {
            topsearchbar.placeholder = "搜索商品                    "
        } else {
            topsearchbar.placeholder = "搜索商品                                "
        }
        //搜索框父view
        let searchview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        searchview.backgroundColor = UIColor.clearColor()
        searchview.addSubview(topsearchbar)
        self.navigationItem.titleView = searchview
        tableView.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //条形码按钮
        var modebtn = UIButton()
        modebtn.frame.size = CGSizeMake(30, 30)
        modebtn.addTarget(self, action: "toScan", forControlEvents: UIControlEvents.TouchUpInside)
        modebtn.setBackgroundImage(UIImage(named: "barcode.png"), forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: modebtn)
        /**添加黑色提示框**/
        tipshow.frame = CGRect(x: (ScreenW-150)/2, y: (self.view.frame.height-80)/3, width: 150, height: 80)
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
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        activity.startAnimating()
        NSThread.detachNewThreadSelector("loadData", toTarget: self, withObject: nil)
        addTimer()
        /**设置下拉刷新**/
        tableView.addHeaderWithTarget(self, action: "pullrefreshData")
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
    
    /**下拉刷新**/
    func pullrefreshData() {
        homeCellList = [Ordercellmodel]()
        advcell = HomeAdvCell()
        adv_totalnum = 0
        finishLoad = false
        clickData = [String:[String]]()
        clicknum = 0
        haveFocus = false
        loadData()
    }
    
    /**调取用户数据**/
    func loadData() {
        let url = NSURL(string: API_URL + "index.php?act=index")
        let data = NSData(contentsOfURL: url!)
        if data == nil {
            activity.stopAnimating()
            tableView.headerEndRefreshing()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let datas_array: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")
        if let datas = datas_array as? NSArray {
            for val in datas {
                let homedata = val as! NSDictionary
                //轮播焦点广告
                if homedata.objectForKey("adv_list") != nil {
                    let datalist = homedata.objectForKey("adv_list")!.objectForKey("item") as! NSArray
                    var data_array = [Homemodel]()
                    for cv in datalist {
                        let newhomedata = Homemodel()
                        let cval = cv as! NSDictionary
                        newhomedata.type = cval.objectForKey("type") as! String
                        newhomedata.data = cval.objectForKey("data") as! String
                        newhomedata.image = cval.objectForKey("image") as! String
                        data_array.append(newhomedata)
                    }
                    let newcell = Ordercellmodel()
                    newcell.type = "adv_list"
                    newcell.data = data_array
                    homeCellList.append(newcell)
                    haveFocus = true
                }
                //home1类型
                if homedata.objectForKey("home1") != nil {
                    let datalist = homedata.objectForKey("home1") as! NSDictionary
                    let newhomedata = Homemodel()
                    newhomedata.type = datalist.objectForKey("type") as! String
                    newhomedata.data = datalist.objectForKey("data") as! String
                    newhomedata.image = datalist.objectForKey("image") as! String
                    let title = datalist.objectForKey("title") as! String
                    if title != "" {
                        let newcell = Ordercellmodel()
                        newcell.type = "gap"
                        newcell.data = title
                        homeCellList.append(newcell)
                    }
                    let newcell = Ordercellmodel()
                    newcell.type = "home1"
                    newcell.data = newhomedata
                    homeCellList.append(newcell)
                }
                //home2类型
                if homedata.objectForKey("home2") != nil {
                    let datalist = homedata.objectForKey("home2") as! NSDictionary
                    var data_array = [String:Homemodel]()
                    let square_image_str: AnyObject! = datalist.objectForKey("square_image")
                    if let square_image = square_image_str as? String {
                        let newhomedata = Homemodel()
                        newhomedata.type = datalist.objectForKey("square_type") as! String
                        newhomedata.data = datalist.objectForKey("square_data") as! String
                        newhomedata.image = datalist.objectForKey("square_image") as! String
                        data_array["square"] = newhomedata
                    }
                    let rectangle1_image_str: AnyObject! = datalist.objectForKey("rectangle1_image")
                    if let rectangle1_image = rectangle1_image_str as? String {
                        let newhomedata = Homemodel()
                        newhomedata.type = datalist.objectForKey("rectangle1_type") as! String
                        newhomedata.data = datalist.objectForKey("rectangle1_data") as! String
                        newhomedata.image = datalist.objectForKey("rectangle1_image") as! String
                        data_array["rectangle1"] = newhomedata
                    }
                    let rectangle2_image_str: AnyObject! = datalist.objectForKey("rectangle2_image")
                    if let rectangle2_image = rectangle2_image_str as? String {
                        let newhomedata = Homemodel()
                        newhomedata.type = datalist.objectForKey("rectangle2_type") as! String
                        newhomedata.data = datalist.objectForKey("rectangle2_data") as! String
                        newhomedata.image = datalist.objectForKey("rectangle2_image") as! String
                        data_array["rectangle2"] = newhomedata
                    }
                    let title = datalist.objectForKey("title") as! String
                    if title != "" {
                        let newcell = Ordercellmodel()
                        newcell.type = "gap"
                        newcell.data = title
                        homeCellList.append(newcell)
                    }
                    let newcell = Ordercellmodel()
                    newcell.type = "home2"
                    newcell.data = data_array
                    homeCellList.append(newcell)
                }
                //home3类型
                if homedata.objectForKey("home3") != nil {
                    let titlestr: AnyObject! = homedata.objectForKey("home3")!.objectForKey("title")
                    if let title = titlestr as? String {
                        if title != "" {
                            let newcell = Ordercellmodel()
                            newcell.type = "gap"
                            newcell.data = title
                            homeCellList.append(newcell)
                        }
                    }
                    let datalist = homedata.objectForKey("home3")!.objectForKey("item") as! NSArray
                    let advallnum = datalist.count
                    let cellnum = Int(round(Float(datalist.count)/2.00))
                    var pointer = -1
                    var num = 1
                    for var i=1;i<=cellnum;i++ {
                        var data_array = [Homemodel]()
                        let newhomedata = Homemodel()
                        let goodsone = datalist[i+pointer] as! NSDictionary
                        newhomedata.type = goodsone.objectForKey("type") as! String
                        newhomedata.data = goodsone.objectForKey("data") as! String
                        newhomedata.image = goodsone.objectForKey("image") as! String
                        data_array.append(newhomedata)
                        num++
                        if advallnum >= num {
                            let newhomedata2 = Homemodel()
                            let goodstwo = datalist[i+pointer+1] as! NSDictionary
                            newhomedata2.type = goodstwo.objectForKey("type") as! String
                            newhomedata2.data = goodstwo.objectForKey("data") as! String
                            newhomedata2.image = goodstwo.objectForKey("image") as! String
                            data_array.append(newhomedata2)
                            num++
                        }
                        let newcell = Ordercellmodel()
                        newcell.type = "home3"
                        newcell.data = data_array
                        homeCellList.append(newcell)
                        pointer++
                    }
                }
                //home4类型
                if homedata.objectForKey("home4") != nil {
                    let datalist = homedata.objectForKey("home4") as! NSDictionary
                    var data_array = [String:Homemodel]()
                    let square_image_str: AnyObject! = datalist.objectForKey("square_image")
                    if let square_image = square_image_str as? String {
                        let newhomedata = Homemodel()
                        newhomedata.type = datalist.objectForKey("square_type") as! String
                        newhomedata.data = datalist.objectForKey("square_data") as! String
                        newhomedata.image = datalist.objectForKey("square_image") as! String
                        data_array["square"] = newhomedata
                    }
                    let rectangle1_image_str: AnyObject! = datalist.objectForKey("rectangle1_image")
                    if let rectangle1_image = rectangle1_image_str as? String {
                        let newhomedata = Homemodel()
                        newhomedata.type = datalist.objectForKey("rectangle1_type") as! String
                        newhomedata.data = datalist.objectForKey("rectangle1_data") as! String
                        newhomedata.image = datalist.objectForKey("rectangle1_image") as! String
                        data_array["rectangle1"] = newhomedata
                    }
                    let rectangle2_image_str: AnyObject! = datalist.objectForKey("rectangle2_image")
                    if let rectangle2_image = rectangle2_image_str as? String {
                        let newhomedata = Homemodel()
                        newhomedata.type = datalist.objectForKey("rectangle2_type") as! String
                        newhomedata.data = datalist.objectForKey("rectangle2_data") as! String
                        newhomedata.image = datalist.objectForKey("rectangle2_image") as! String
                        data_array["rectangle2"] = newhomedata
                    }
                    let title = datalist.objectForKey("title") as! String
                    if title != "" {
                        let newcell = Ordercellmodel()
                        newcell.type = "gap"
                        newcell.data = title
                        homeCellList.append(newcell)
                    }
                    let newcell = Ordercellmodel()
                    newcell.type = "home4"
                    newcell.data = data_array
                    homeCellList.append(newcell)
                }
                //商品类型
                if homedata.objectForKey("goods") != nil {
                    let titlestr: AnyObject! = homedata.objectForKey("goods")!.objectForKey("title")
                    if let title = titlestr as? String {
                        if title != "" {
                            let newcell = Ordercellmodel()
                            newcell.type = "gap"
                            newcell.data = title
                            homeCellList.append(newcell)
                        }
                    }
                    let datalist = homedata.objectForKey("goods")!.objectForKey("item") as! NSArray
                    let cellnum = Int(round(Float(datalist.count)/2.00))
                    let goodsallnum = datalist.count
                    var pointer = -1
                    var num = 1
                    for var i=1;i<=cellnum;i++ {
                        var data_array = [Goodsmodel]()
                        let newhomedata = Goodsmodel()
                        let goodsone = datalist[i+pointer] as! NSDictionary
                        newhomedata.goods_id = goodsone.objectForKey("goods_id") as! String
                        newhomedata.goods_name = goodsone.objectForKey("goods_name") as! String
                        newhomedata.goods_price = goodsone.objectForKey("goods_promotion_price") as! String
                        newhomedata.goods_image = goodsone.objectForKey("goods_image") as! String
                        data_array.append(newhomedata)
                        num++
                        if goodsallnum >= num {
                            let newhomedata2 = Goodsmodel()
                            let goodstwo = datalist[i+pointer+1] as! NSDictionary
                            newhomedata2.goods_id = goodstwo.objectForKey("goods_id") as! String
                            newhomedata2.goods_name = goodstwo.objectForKey("goods_name") as! String
                            newhomedata2.goods_price = goodstwo.objectForKey("goods_promotion_price") as! String
                            newhomedata2.goods_image = goodstwo.objectForKey("goods_image") as! String
                            data_array.append(newhomedata2)
                            num++
                        }
                        let newcell = Ordercellmodel()
                        newcell.type = "goods"
                        newcell.data = data_array
                        homeCellList.append(newcell)
                        pointer++
                    }
                }
            }
        } else {
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
        }
        tableView.headerEndRefreshing()
        activity.stopAnimating()
        tableView.reloadData()
        finishLoad = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeCellList.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let data = homeCellList[indexPath.row] as Ordercellmodel
        let type = data.type
        var height: CGFloat = 0
        switch type {
        case "adv_list":
            if ScreenW == 320 {
                height = 120
            }
            if ScreenW == 375 {
                height = 140
            }
            if ScreenW == 414 {
                height = 155
            }
        case "home1":
            if ScreenW == 320 {
                height = 130
            }
            if ScreenW == 375 {
                height = 152
            }
            if ScreenW == 414 {
                height = 168
            }
        case "home2":
            if ScreenW == 320 {
                height = 140
            }
            if ScreenW == 375 {
                height = 160
            }
            if ScreenW == 414 {
                height = 176
            }
        case "home3":
            if ScreenW == 320 {
                height = 50
            }
            if ScreenW == 375 {
                height = 56
            }
            if ScreenW == 414 {
                height = 61
            }
        case "home4":
            if ScreenW == 320 {
                height = 140
            }
            if ScreenW == 375 {
                height = 160
            }
            if ScreenW == 414 {
                height = 176
            }
        case "goods":
            if ScreenW == 320 {
                height = 215
            }
            if ScreenW == 375 {
                height = 242
            }
            if ScreenW == 414 {
                height = 262
            }
        default:
            height = 20
        }
        return height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = homeCellList[indexPath.row] as Ordercellmodel
        let type = data.type
        var nibname = ""
        var cellID = ""
        if type == "adv_list" {
            if ScreenW == 320 {
                nibname = "HomeAdvCell"
                cellID = "HomeAdvCellID"
            }
            if ScreenW == 375 {
                nibname = "HomeAdvCell375"
                cellID = "HomeAdvCellID375"
            }
            if ScreenW == 414 {
                nibname = "HomeAdvCell414"
                cellID = "HomeAdvCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! HomeAdvCell
            let imageW = cell.advview.frame.width
            let imageH = cell.advview.frame.height
            let adv_list = data.data as! NSArray
            let totalnum = adv_list.count //轮播图片总数
            for var i=0;i<totalnum;i++ {
                let imgview = UIImageView()
                let imageX = CGFloat(i) * CGFloat(imageW)
                imgview.frame = CGRectMake(imageX, 0, imageW, imageH)
                //加载网络图片
                let advinfo = adv_list.objectAtIndex(i) as! Homemodel
                let image_url = advinfo.image
                //设置图片点击事件
                imgview.userInteractionEnabled = true
                imgview.tag = clicknum
                let cknum = String(clicknum)
                clickData[cknum] = [advinfo.type, advinfo.data]
                clicknum++
                let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                imgview.addGestureRecognizer(singleTap)
                //将图片放到scorllview上面
                cell.advview.showsHorizontalScrollIndicator = false
                cell.advview.addSubview(imgview)
                imgview.image = UIImage(named: "home_nopic.png")
                let cellimgdata: NSArray = [imgview, image_url, "focus"]
                NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
            }
            let contentW = CGFloat(totalnum) * imageW
            cell.advview.contentSize = CGSizeMake(contentW, 0)
            cell.advview.pagingEnabled = true
            cell.advview.delegate = self
            cell.advview.tag = 1
            cell.page.currentPage = 0
            cell.page.numberOfPages = totalnum
            adv_totalnum = totalnum
            cell.page.currentPageIndicatorTintColor = UIColor.whiteColor()
            cell.page.pageIndicatorTintColor = UIColor.lightTextColor()
            advcell = cell
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "home1" {
            if ScreenW == 320 {
                nibname = "HomeOneCell"
                cellID = "HomeOneCellID"
            }
            if ScreenW == 375 {
                nibname = "HomeOneCell375"
                cellID = "HomeOneCellID375"
            }
            if ScreenW == 414 {
                nibname = "HomeOneCell414"
                cellID = "HomeOneCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! HomeOneCell
            let advinfo = data.data as! Homemodel
            let image_url = advinfo.image
            cell.pic.image = UIImage(named: "home_nopic.png")
            let cellimgdata: NSArray = [cell, image_url, "home1"]
            NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
            //设置图片点击事件
            cell.pic.userInteractionEnabled = true
            cell.pic.tag = clicknum
            let cknum = String(clicknum)
            clickData[cknum] = [advinfo.type, advinfo.data]
            clicknum++
            let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
            cell.pic.addGestureRecognizer(singleTap)
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "home2" {
            if ScreenW == 320 {
                nibname = "HomeTwoCell"
                cellID = "HomeTwoCellID"
            }
            if ScreenW == 375 {
                nibname = "HomeTwoCell375"
                cellID = "HomeTwoCellID375"
            }
            if ScreenW == 414 {
                nibname = "HomeTwoCell414"
                cellID = "HomeTwoCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! HomeTwoCell
            let adv_list = data.data as! NSDictionary
            if adv_list.objectForKey("square") != nil {
                let info = adv_list.objectForKey("square") as! Homemodel
                let image_url = info.image
                let cellimgdata: NSArray = [cell, image_url, "home2one"]
                NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                //设置图片点击事件
                cell.picone.userInteractionEnabled = true
                cell.picone.tag = clicknum
                let cknum = String(clicknum)
                clickData[cknum] = [info.type, info.data]
                clicknum++
                let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                cell.picone.addGestureRecognizer(singleTap)
            }
            if adv_list.objectForKey("rectangle1") != nil {
                let info = adv_list.objectForKey("rectangle1") as! Homemodel
                let image_url = info.image
                cell.pictwo.image = UIImage(named: "home_nopic.png")
                let cellimgdata: NSArray = [cell, image_url, "home2two"]
                NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                //设置图片点击事件
                cell.pictwo.userInteractionEnabled = true
                cell.pictwo.tag = clicknum
                let cknum = String(clicknum)
                clickData[cknum] = [info.type, info.data]
                clicknum++
                let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                cell.pictwo.addGestureRecognizer(singleTap)
            }
            if adv_list.objectForKey("rectangle2") != nil {
                let info = adv_list.objectForKey("rectangle2") as! Homemodel
                let image_url = info.image
                cell.picthree.image = UIImage(named: "home_nopic.png")
                let cellimgdata: NSArray = [cell, image_url, "home2three"]
                NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                //设置图片点击事件
                cell.picthree.userInteractionEnabled = true
                cell.picthree.tag = clicknum
                let cknum = String(clicknum)
                clickData[cknum] = [info.type, info.data]
                clicknum++
                let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                cell.picthree.addGestureRecognizer(singleTap)
            }
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "home3" {
            if ScreenW == 320 {
                nibname = "HomeThreeCell"
                cellID = "HomeThreeCellID"
            }
            if ScreenW == 375 {
                nibname = "HomeThreeCell375"
                cellID = "HomeThreeCellID375"
            }
            if ScreenW == 414 {
                nibname = "HomeThreeCell414"
                cellID = "HomeThreeCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! HomeThreeCell
            let adv_list = data.data as! NSArray
            for (key,val) in adv_list.enumerate() {
                let info = val as! Homemodel
                let image_url = info.image
                if key == 0 {
                    cell.picone.image = UIImage(named: "home_nopic.png")
                    let cellimgdata: NSArray = [cell, image_url, "home3one"]
                    NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                    //设置图片点击事件
                    cell.picone.userInteractionEnabled = true
                    cell.picone.tag = clicknum
                    let cknum = String(clicknum)
                    clickData[cknum] = [info.type, info.data]
                    clicknum++
                    let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                    cell.picone.addGestureRecognizer(singleTap)
                } else {
                    cell.pictwo.image = UIImage(named: "home_nopic.png")
                    let cellimgdata: NSArray = [cell, image_url, "home3two"]
                    NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                    //设置图片点击事件
                    cell.pictwo.userInteractionEnabled = true
                    cell.pictwo.tag = clicknum
                    let cknum = String(clicknum)
                    clickData[cknum] = [info.type, info.data]
                    clicknum++
                    let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                    cell.pictwo.addGestureRecognizer(singleTap)
                }
            }
            if adv_list.count == 1 {
                cell.pictwo.hidden = true
            } else {
                cell.pictwo.hidden = false
            }
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "home4" {
            if ScreenW == 320 {
                nibname = "HomeFourCell"
                cellID = "HomeFourCellID"
            }
            if ScreenW == 375 {
                nibname = "HomeFourCell375"
                cellID = "HomeFourCellID375"
            }
            if ScreenW == 414 {
                nibname = "HomeFourCell414"
                cellID = "HomeFourCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! HomeFourCell
            let adv_list = data.data as! NSDictionary
            if adv_list.objectForKey("square") != nil {
                let info = adv_list.objectForKey("square") as! Homemodel
                let image_url = info.image
                cell.picone.image = UIImage(named: "home_nopic.png")
                let cellimgdata: NSArray = [cell, image_url, "home4three"]
                NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                //设置图片点击事件
                cell.picthree.userInteractionEnabled = true
                cell.picthree.tag = clicknum
                let cknum = String(clicknum)
                clickData[cknum] = [info.type, info.data]
                clicknum++
                let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                cell.picthree.addGestureRecognizer(singleTap)
            }
            if adv_list.objectForKey("rectangle1") != nil {
                let info = adv_list.objectForKey("rectangle1") as! Homemodel
                let image_url = info.image
                cell.pictwo.image = UIImage(named: "home_nopic.png")
                let cellimgdata: NSArray = [cell, image_url, "home4one"]
                NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                //设置图片点击事件
                cell.picone.userInteractionEnabled = true
                cell.picone.tag = clicknum
                let cknum = String(clicknum)
                clickData[cknum] = [info.type, info.data]
                clicknum++
                let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                cell.picone.addGestureRecognizer(singleTap)
            }
            if adv_list.objectForKey("rectangle2") != nil {
                let info = adv_list.objectForKey("rectangle2") as! Homemodel
                let image_url = info.image
                let cellimgdata: NSArray = [cell, image_url, "home4two"]
                NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                //设置图片点击事件
                cell.pictwo.userInteractionEnabled = true
                cell.pictwo.tag = clicknum
                let cknum = String(clicknum)
                clickData[cknum] = [info.type, info.data]
                clicknum++
                let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                cell.pictwo.addGestureRecognizer(singleTap)
            }
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if type == "goods" {
            if ScreenW == 320 {
                nibname = "HomeGoodsCell"
                cellID = "HomeGoodsCellID"
            }
            if ScreenW == 375 {
                nibname = "HomeGoodsCell375"
                cellID = "HomeGoodsCellID375"
            }
            if ScreenW == 414 {
                nibname = "HomeGoodsCell414"
                cellID = "HomeGoodsCellID414"
            }
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! HomeGoodsCell
            let adv_list = data.data as! NSArray
            for (key,val) in adv_list.enumerate() {
                let info = val as! Goodsmodel
                let image_url = info.goods_image
                if key == 0 {
                    cell.goodsonename.text = info.goods_name
                    cell.goodsoneprice.text = "￥" + info.goods_price
                    let cellimgdata: NSArray = [cell, image_url, "goodsone"]
                    NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                    //设置图片点击事件
                    cell.goodsonepic.userInteractionEnabled = true
                    cell.goodsonepic.tag = clicknum
                    let cknum = String(clicknum)
                    clickData[cknum] = ["goods", info.goods_id]
                    clicknum++
                    let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                    cell.goodsonepic.addGestureRecognizer(singleTap)
                } else {
                    cell.goodstwoname.text = info.goods_name
                    cell.goodstwoprice.text = "￥" + info.goods_price
                    let cellimgdata: NSArray = [cell, image_url, "goodstwo"]
                    NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                    //设置图片点击事件
                    cell.goodstwopic.userInteractionEnabled = true
                    cell.goodstwopic.tag = clicknum
                    let cknum = String(clicknum)
                    clickData[cknum] = ["goods", info.goods_id]
                    clicknum++
                    let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                    cell.goodstwopic.addGestureRecognizer(singleTap)
                }
            }
            if adv_list.count == 1 {
                cell.goodstwoview.hidden = true
            } else {
                cell.goodstwoview.hidden = false
            }
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else {
            nibname = "HomeGapCell"
            cellID = "HomeGapCellID"
            var nibregistered = false
            if !nibregistered {
                let nib = UINib(nibName: nibname, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                nibregistered = true
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! HomeGapCell
            cell.gaptitle.text = data.data as? String
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    /**设置焦点图**/
    func nextimage() {
        if finishLoad && haveFocus {
            var page = advcell.page.currentPage
            if page == adv_totalnum-1 {
                page = 0
            } else {
                page++
            }
            let x = CGFloat(page) * advcell.advview.frame.width
            advcell.advview.setContentOffset(CGPointMake(x, 0), animated: true)
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if finishLoad && scrollView.tag == 1 {
            let page = advcell.advview.contentOffset.x / advcell.advview.frame.width
            advcell.page.currentPage = Int(page)
        }
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if finishLoad && scrollView.tag == 1 {
            removeTimer()
        }
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if finishLoad && scrollView.tag == 1 {
            addTimer()
        }
    }
    
    func addTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "nextimage", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func removeTimer() {
        timer.invalidate()
    }
    
    /**延时缓存加载图片**/
    func uploadImageForCellAtIndexPath(cellimgdata: NSArray) {
        let picurl = cellimgdata.objectAtIndex(1) as! String
        let picurl_arr = picurl.componentsSeparatedByString("/")
        var img: UIImage
        var data: NSData!
        let type = cellimgdata.objectAtIndex(2) as! String
        if picurl_arr[picurl_arr.count - 1] == "" {
            if type == "goodsone" || type == "goodstwo" || type == "home2one" || type == "home4three" {
                img = UIImage(named: "goods_nopic.png")!
            } else {
                img = UIImage(named: "home_nopic.png")!
            }
        } else {
            //调用图片缓存or从网络抓取图片数据
            let imagedatapath = NSHomeDirectory() + "/Library/Caches/Adv/" + picurl_arr[picurl_arr.count - 1]
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
                if type == "goodsone" || type == "goodstwo" || type == "home2one" || type == "home4three" {
                    img = UIImage(named: "goods_nopic.png")!
                } else {
                    img = UIImage(named: "home_nopic.png")!
                }
            }
        }
        
        if type == "focus" {
            let imageview = cellimgdata.objectAtIndex(0) as! UIImageView
            imageview.image = img
        } else {
            switch type {
            case "home1":
                let cell = cellimgdata.objectAtIndex(0) as! HomeOneCell
                cell.pic.image = img
            case "home2one":
                let cell = cellimgdata.objectAtIndex(0) as! HomeTwoCell
                cell.picone.image = img
            case "home2two":
                let cell = cellimgdata.objectAtIndex(0) as! HomeTwoCell
                cell.pictwo.image = img
            case "home2three":
                let cell = cellimgdata.objectAtIndex(0) as! HomeTwoCell
                cell.picthree.image = img
            case "home3one":
                let cell = cellimgdata.objectAtIndex(0) as! HomeThreeCell
                cell.picone.image = img
            case "home3two":
                let cell = cellimgdata.objectAtIndex(0) as! HomeThreeCell
                cell.pictwo.image = img
            case "home4one":
                let cell = cellimgdata.objectAtIndex(0) as! HomeFourCell
                cell.picone.image = img
            case "home4two":
                let cell = cellimgdata.objectAtIndex(0) as! HomeFourCell
                cell.pictwo.image = img
            case "home4three":
                let cell = cellimgdata.objectAtIndex(0) as! HomeFourCell
                cell.picthree.image = img
            case "goodsone":
                let cell = cellimgdata.objectAtIndex(0) as! HomeGoodsCell
                cell.goodsonepic.image = img
            case "goodstwo":
                let cell = cellimgdata.objectAtIndex(0) as! HomeGoodsCell
                cell.goodstwopic.image = img
            default:
                let cell = cellimgdata.objectAtIndex(0) as! HomeOneCell
                cell.pic.image = img
            }
        }
    }
    
    /**处理点击事件**/
    func picClick(recognizer: UITapGestureRecognizer) {
        let cknum = recognizer.view!.tag
        let clickdata = clickData[String(cknum)] as NSArray!
        let type = clickdata.objectAtIndex(0) as! String
        let data = clickdata.objectAtIndex(1) as! String
        if type == "goods" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let gdcontroller = sb.instantiateViewControllerWithIdentifier("GoodsDetailID") as! GoodsDetailViewController
            gdcontroller.goods_id = data
            gdcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(gdcontroller, animated: true)
        }
        if type == "special" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let spcontroller = sb.instantiateViewControllerWithIdentifier("SpecialViewID") as! SpecialViewController
            spcontroller.sp_id = data
            spcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(spcontroller, animated: true)
        }
        if type == "keyword" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let glcontroller = sb.instantiateViewControllerWithIdentifier("GoodsListID") as! GoodsListViewController
            glcontroller.keyword = data
            glcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(glcontroller, animated: true)
        }
        if type == "url" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let wvcontroller = sb.instantiateViewControllerWithIdentifier("WebViewID") as! WebViewController
            wvcontroller.navititle = "网页浏览"
            wvcontroller.urlstr = data
            wvcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(wvcontroller, animated: true)
        }
    }
    
    /**设置搜索框**/
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let svcontroller = sb.instantiateViewControllerWithIdentifier("SearchViewID") as! SearchViewController
        svcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(svcontroller, animated: false)
    }
    
    /**到条形码扫描界面**/
    func toScan() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let scancontroller = sb.instantiateViewControllerWithIdentifier("ScanViewID") as! ScanViewController
        scancontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(scancontroller, animated: false)
    }
}