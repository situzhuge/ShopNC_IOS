//商家详情页

import UIKit

class StoreDetailViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    var store_id = ""
    var ScreenW: CGFloat!
    var activity: UIActivityIndicatorView!
    //页面布局
    var mainscrollview = UIScrollView()
    var titlepic: UIImageView!
    var avatar: UIImageView!
    var storename: UILabel!
    var allgoodsnum: UILabel!
    var allcollectnum: UILabel!
    var scorestr: UILabel!
    var favbtn: UIButton!
    var isfav = false
    var scoreone: UILabel!
    var scoretwo: UILabel!
    var scorethree: UILabel!
    var slideadv: UIScrollView!
    var page: UIPageControl!
    var timer = NSTimer()
    var adv_allnum = 0
    var recgoodsview: UITableView!
    var goodsList = [[Goodsmodel]]()
    var slideData = [Homemodel]()
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "店铺主页"
        ScreenW = self.view.frame.width
        /**添加主scrollview**/
        mainscrollview.frame = CGRect(x: 0, y: 0, width: ScreenW, height: self.view.frame.height)
        mainscrollview.delegate = self
        mainscrollview.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        self.view.addSubview(mainscrollview)
        /**店铺头部信息区**/
        titlepic = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenW/3.2))
        mainscrollview.addSubview(titlepic)
        let storeinfoview = UIView(frame: CGRect(x: 0, y: ScreenW/3.2, width: ScreenW, height: 85))
        storeinfoview.backgroundColor = UIColor.whiteColor()
        mainscrollview.addSubview(storeinfoview)
        storename = UILabel(frame: CGRect(x: 80, y: 5, width: ScreenW-90, height: 20))
        storename.font = UIFont.systemFontOfSize(14)
        storeinfoview.addSubview(storename)
        allgoodsnum = UILabel(frame: CGRect(x: 0, y: 35, width: ScreenW/3, height: 20))
        allgoodsnum.font = UIFont.systemFontOfSize(16)
        allgoodsnum.textAlignment = NSTextAlignment.Center
        allgoodsnum.text = "0"
        storeinfoview.addSubview(allgoodsnum)
        let allgoodsnumlabel = UILabel(frame: CGRect(x: 0, y: 60, width: ScreenW/3, height: 20))
        allgoodsnumlabel.font = UIFont.systemFontOfSize(12)
        allgoodsnumlabel.textColor = UIColor.grayColor()
        allgoodsnumlabel.textAlignment = NSTextAlignment.Center
        allgoodsnumlabel.text = "全部商品"
        storeinfoview.addSubview(allgoodsnumlabel)
        allcollectnum = UILabel(frame: CGRect(x: ScreenW/3, y: 35, width: ScreenW/3, height: 20))
        allcollectnum.font = UIFont.systemFontOfSize(16)
        allcollectnum.textAlignment = NSTextAlignment.Center
        allcollectnum.text = "0"
        storeinfoview.addSubview(allcollectnum)
        let allcollectnumlabel = UILabel(frame: CGRect(x: ScreenW/3, y: 60, width: ScreenW/3, height: 20))
        allcollectnumlabel.font = UIFont.systemFontOfSize(12)
        allcollectnumlabel.textColor = UIColor.grayColor()
        allcollectnumlabel.textAlignment = NSTextAlignment.Center
        allcollectnumlabel.text = "收藏"
        storeinfoview.addSubview(allcollectnumlabel)
        scoreone = UILabel(frame: CGRect(x: ScreenW/3*2, y: 35, width: ScreenW/3, height: 15))
        scoreone.font = UIFont.systemFontOfSize(12)
        scoreone.textAlignment = NSTextAlignment.Center
        scoreone.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        storeinfoview.addSubview(scoreone)
        scoretwo = UILabel(frame: CGRect(x: ScreenW/3*2, y: 50, width: ScreenW/3, height: 15))
        scoretwo.font = UIFont.systemFontOfSize(12)
        scoretwo.textAlignment = NSTextAlignment.Center
        scoretwo.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        storeinfoview.addSubview(scoretwo)
        scorethree = UILabel(frame: CGRect(x: ScreenW/3*2, y: 65, width: ScreenW/3, height: 15))
        scorethree.font = UIFont.systemFontOfSize(12)
        scorethree.textAlignment = NSTextAlignment.Center
        scorethree.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        storeinfoview.addSubview(scorethree)
        let avatarview = UIView(frame: CGRect(x: 10, y: ScreenW/3.2-30, width: 60, height: 60))
        avatarview.backgroundColor = UIColor.whiteColor()
        mainscrollview.addSubview(avatarview)
        avatar = UIImageView(frame: CGRect(x: 2, y: 2, width: 56, height: 56))
        avatarview.addSubview(avatar)
        favbtn = UIButton(frame: CGRect(x: ScreenW-60, y: ScreenW/3.2+5, width: 50, height: 20))
        favbtn.backgroundColor = UIColor(red: 251/255, green: 56/255, blue: 10/255, alpha: 1.0)
        favbtn.layer.cornerRadius = 3
        favbtn.addTarget(self, action: "dofav", forControlEvents: UIControlEvents.TouchUpInside)
        favbtn.setTitle("收藏", forState: UIControlState.Normal)
        favbtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        favbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        mainscrollview.addSubview(favbtn)
        /**轮播广告**/
        slideadv = UIScrollView(frame: CGRect(x: 0, y: ScreenW/3.2+85+5, width: ScreenW, height: ScreenW/2.67))
        slideadv.delegate = self
        mainscrollview.addSubview(slideadv)
        page = UIPageControl(frame: CGRect(x: ScreenW-90, y: ScreenW/3.2+85+5+ScreenW/2.67-20, width: 80, height: 10))
        page.currentPage = 0
        page.currentPageIndicatorTintColor = UIColor.whiteColor()
        page.pageIndicatorTintColor = UIColor.lightTextColor()
        mainscrollview.addSubview(page)
        addTimer()
        /**推荐商品**/
        let reclabel = UILabel(frame: CGRect(x: 10, y: ScreenW/3.2+100+ScreenW/2.67, width: 100, height: 20))
        reclabel.text = "推荐商品"
        reclabel.textColor = UIColor.grayColor()
        reclabel.font = UIFont.systemFontOfSize(14)
        mainscrollview.addSubview(reclabel)
        recgoodsview = UITableView()
        recgoodsview.dataSource = self
        recgoodsview.delegate = self
        recgoodsview.contentSize = CGSizeMake(0, 0)
        recgoodsview.backgroundColor = UIColor.clearColor()
        recgoodsview.separatorStyle = UITableViewCellSeparatorStyle.None
        mainscrollview.addSubview(recgoodsview)
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
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分类", style: UIBarButtonItemStyle.Plain, target: self, action: "storegc")
        UIView.setAnimationsEnabled(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**加载网络数据**/
    func loadData() {
        let url = NSURL(string: API_URL + "index.php?act=store&op=store_info&store_id=" + store_id + "&key=" + getkey())
        let data = NSData(contentsOfURL: url!)
        if data == nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        if data_array.objectForKey("error") != nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        } else {
            let store_info = data_array.objectForKey("store_info") as! NSDictionary
            storename.text = store_info.objectForKey("store_name") as! String!
            let goods_count = store_info.objectForKey("goods_count") as! Int
            allgoodsnum.text = String(goods_count)
            let store_collect = store_info.objectForKey("store_collect") as! Int
            allcollectnum.text = String(store_collect)
//            let store_credit_text = store_info.objectForKey("store_credit_text") as! String
//            let credit_array = store_credit_text.componentsSeparatedByString(",")
//            scoreone.text = " " + credit_array[0]
//            scoretwo.text = "hehe" //liubwtest credit_array[1]
//            scorethree.text = "hehe2" //liubwtest credit_array[2]
            let fav = store_info.objectForKey("is_favorate") as! Int
            if fav == 1 {
                favbtn.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
                favbtn.setTitle("已收藏", forState: UIControlState.Normal)
                favbtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                isfav = true
            }
            
            /**加载页头店铺图片**/
            //加载店铺LOGO
            avatar.image = UIImage(named:"home_nopic.png")
            let avatarimgdata: NSArray = [avatar, store_info.objectForKey("store_avatar") as! String!]
            NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: avatarimgdata)
            
            //加载店铺个性化背景图片   目前是无法显示liubwtest
            titlepic.image = UIImage(named:"home_nopic.png")
            let titleimgdata: NSArray = [titlepic, store_info.objectForKey("mb_title_img") as! String!]
            NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: titleimgdata)
            
            
            /**轮播广告**/
            let adv_arr = store_info.objectForKey("mb_sliders") as! NSArray
            let imageW = slideadv.frame.width
            let imageH = slideadv.frame.height
            let totalnum = adv_arr.count //轮播图片总数
            for var i=0;i<totalnum;i++ {
                let imgview = UIImageView()
                let imageX = CGFloat(i) * CGFloat(imageW)
                imgview.frame = CGRectMake(imageX, 0, imageW, imageH)
                let slideinfo = adv_arr[i] as! NSDictionary
                //加载网络图片
                let image_url = slideinfo.objectForKey("imgUrl") as! String
                //写入轮播图数据
                let newslide = Homemodel()
                newslide.image = image_url
                let type = slideinfo.objectForKey("type") as! Int
                newslide.type = String(type)
                let link: AnyObject! = slideinfo.objectForKey("link")
                newslide.data = String(link)
                slideData.append(newslide)
                //将图片放到scorllview上面
                slideadv.showsHorizontalScrollIndicator = false
                slideadv.addSubview(imgview)
                imgview.image = UIImage(named:"home_nopic.png")
                let imgdata: NSArray = [imgview, image_url]
                NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: imgdata)
                //添加图片点击事件
                imgview.userInteractionEnabled = true
                imgview.tag = i
                let singleTap = UITapGestureRecognizer(target: self, action: "picClick:")
                imgview.addGestureRecognizer(singleTap)
            }
            let contentW = CGFloat(totalnum) * imageW
            slideadv.contentSize = CGSizeMake(contentW, 0)
            slideadv.pagingEnabled = true
            page.numberOfPages = totalnum
            adv_allnum = totalnum
            /**推荐商品数据**/
            let datalist = data_array.objectForKey("rec_goods_list") as! NSArray
            let cellnum = Int(round(Float(datalist.count)/2.00))
            let goodsallnum = datalist.count
            var pointer = -1
            var num = 1
            for var i=1;i<=cellnum;i++ {
                var goods_data_array = [Goodsmodel]()
                let newgoodsdata = Goodsmodel()
                let goodsone = datalist[i+pointer] as! NSDictionary
                newgoodsdata.goods_id = goodsone.objectForKey("goods_id") as! String
                newgoodsdata.goods_name = goodsone.objectForKey("goods_name") as! String
                newgoodsdata.goods_price = goodsone.objectForKey("goods_price") as! String
                newgoodsdata.goods_image = goodsone.objectForKey("goods_image_url") as! String
                goods_data_array.append(newgoodsdata)
                num++
                if goodsallnum >= num {
                    let newgoodsdata2 = Goodsmodel()
                    let goodstwo = datalist[i+pointer+1] as! NSDictionary
                    newgoodsdata2.goods_id = goodstwo.objectForKey("goods_id") as! String
                    newgoodsdata2.goods_name = goodstwo.objectForKey("goods_name") as! String
                    newgoodsdata2.goods_price = goodstwo.objectForKey("goods_price") as! String
                    newgoodsdata2.goods_image = goodstwo.objectForKey("goods_image_url") as! String
                    goods_data_array.append(newgoodsdata2)
                    num++
                }
                goodsList.append(goods_data_array)
                pointer++
            }
            recgoodsview.reloadData()
            //调整recgoodsview和mainscrollview的大小
            var cellH: CGFloat = 0
            if ScreenW == 320 {
                cellH = 215
            } else if ScreenW == 375 {
                cellH = 242
            } else {
                cellH = 262
            }
            recgoodsview.frame = CGRect(x: 0, y: ScreenW/3.2+120+ScreenW/2.67, width: ScreenW, height: CGFloat(cellnum)*cellH)
            mainscrollview.contentSize = CGSizeMake(0, ScreenW/3.2+189+ScreenW/2.67+CGFloat(cellnum)*cellH)
        }
        activity.stopAnimating()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if alertView.tag != 99 && btnlabel == "确定" {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func uploadImageForCellAtIndexPath(imgdata: NSArray) {
        let picurl = imgdata.objectAtIndex(1) as! String
        let picurl_arr = picurl.componentsSeparatedByString("/")
        var img: UIImage
        var data: NSData!
        if picurl_arr[picurl_arr.count - 1] == "" {
            img = UIImage(named: "home_nopic.png")!
        } else {
            //调用图片缓存or从网络抓取图片数据
            let imagedatapath = NSHomeDirectory() + "/Library/Caches/Store/" + picurl_arr[picurl_arr.count - 1]
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
                img = UIImage(named: "home_nopic.png")!
            }
        }
        let imgview = imgdata.objectAtIndex(0) as! UIImageView
        imgview.image = img
    }
    
    /**店铺分类**/
    func storegc() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sccontroller = sb.instantiateViewControllerWithIdentifier("StoreClassViewID") as! StoreClassViewController
        sccontroller.store_id = store_id
        sccontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sccontroller, animated: true)
    }
    
    /**店铺收藏**/
    func dofav() {
        activity.startAnimating()
        let key = getkey()
        let paramstr = NSString(format: "store_id=%@&key=%@", store_id, key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        if isfav {
            request.URL = NSURL(string: API_URL + "index.php?act=member_favorites_store&op=favorites_del")
        } else {
            request.URL = NSURL(string: API_URL + "index.php?act=member_favorites_store&op=favorites_add")
        }
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if respdata == nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.tag = 99
            alert.show()
            return
        }
        let data_array: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")
        if let datas = data_array as? String {
            if datas == "1" {
                if isfav {
                    favbtn.backgroundColor = UIColor(red: 251/255, green: 56/255, blue: 10/255, alpha: 1.0)
                    favbtn.setTitle("收藏", forState: UIControlState.Normal)
                    favbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    isfav = false
                } else {
                    favbtn.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
                    favbtn.setTitle("已收藏", forState: UIControlState.Normal)
                    favbtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                    isfav = true
                }
            }
        } else {
            tipstr.text = "操作失败"
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
    
    /**设置焦点图**/
    func nextimage() {
        var pagenum = page.currentPage
        if pagenum == adv_allnum-1 {
            pagenum = 0
        } else {
            pagenum++
        }
        let x = CGFloat(pagenum) * slideadv.frame.width
        slideadv.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pagenum = slideadv.contentOffset.x / slideadv.frame.width
        page.currentPage = Int(pagenum)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    func addTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "nextimage", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func removeTimer() {
        timer.invalidate()
    }
    
    /**tableview设置**/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if ScreenW == 320 {
            return 215
        } else if ScreenW == 375 {
            return 242
        } else {
            return 262
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var nibname = ""
        var cellID = ""
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
        let goods_list = goodsList[indexPath.row]
        for (key,val) in goods_list.enumerate() {
            let info = val as Goodsmodel
            let image_url = info.goods_image
            if key == 0 {
                cell.goodsonename.text = info.goods_name
                cell.goodsoneprice.text = "￥" + info.goods_price
                let cellimgdata: NSArray = [cell, image_url, "goodsone"]
                NSThread.detachNewThreadSelector("uploadImageForGoodsCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                //设置图片点击事件
                cell.goodsonepic.userInteractionEnabled = true
                cell.goodsonepic.tag = Int(info.goods_id)!
                let singleTap = UITapGestureRecognizer(target: self, action: "goodsClick:")
                cell.goodsonepic.addGestureRecognizer(singleTap)
            } else {
                cell.goodstwoname.text = info.goods_name
                cell.goodstwoprice.text = "￥" + info.goods_price
                let cellimgdata: NSArray = [cell, image_url, "goodstwo"]
                NSThread.detachNewThreadSelector("uploadImageForGoodsCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
                //设置图片点击事件
                cell.goodstwopic.userInteractionEnabled = true
                cell.goodstwopic.tag = Int(info.goods_id)!
                let singleTap = UITapGestureRecognizer(target: self, action: "goodsClick:")
                cell.goodstwopic.addGestureRecognizer(singleTap)
            }
        }
        if goods_list.count == 1 {
            cell.goodstwoview.hidden = true
        } else {
            cell.goodstwoview.hidden = false
        }
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func uploadImageForGoodsCellAtIndexPath(cellimgdata: NSArray) {
        let picurl = cellimgdata.objectAtIndex(1) as! String
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
        let type = cellimgdata.objectAtIndex(2) as! String
        if type == "goodsone" {
            let cell = cellimgdata.objectAtIndex(0) as! HomeGoodsCell
            cell.goodsonepic.image = img
        } else {
            let cell = cellimgdata.objectAtIndex(0) as! HomeGoodsCell
            cell.goodstwopic.image = img
        }
    }
    
    /**商品图片点击**/
    func goodsClick(recognizer: UITapGestureRecognizer) {
        let goods_id = String(recognizer.view!.tag)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let gdcontroller = sb.instantiateViewControllerWithIdentifier("GoodsDetailID") as! GoodsDetailViewController
        gdcontroller.goods_id = goods_id
        gdcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gdcontroller, animated: true)
    }
    
    /**轮播图片点击**/
    func picClick(recognizer: UITapGestureRecognizer) {
        let slideindex = recognizer.view!.tag
        let slideinfo = slideData[slideindex]
        let link = slideData[slideindex].data
        if slideinfo.type == "1" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let wvcontroller = sb.instantiateViewControllerWithIdentifier("WebViewID") as! WebViewController
            wvcontroller.navititle = "网页浏览"
            wvcontroller.urlstr = link
            wvcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(wvcontroller, animated: true)
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let gdcontroller = sb.instantiateViewControllerWithIdentifier("GoodsDetailID") as! GoodsDetailViewController
            gdcontroller.goods_id = link
            gdcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(gdcontroller, animated: true)
        }
    }
}