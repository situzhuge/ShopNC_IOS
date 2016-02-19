//个人中心显示页面

import UIKit

class UserViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var activity: UIActivityIndicatorView!
    var ScreenWidth: CGFloat!
    var ScreenHeight: CGFloat!
    var funcList = [Usercentermodel]()
    var jfval: UILabel!
    var yckval: UILabel!
    var czkval: UILabel!
    var unlogin: UIView!
    var avatar: UIImageView!
    var username: UILabel!
    var mainscrollview: UIScrollView!
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ScreenWidth = self.view.frame.width
        ScreenHeight = self.view.frame.height
        /**添加主scrollview**/
        mainscrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        mainscrollview.delegate = self
        mainscrollview.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        mainscrollview.showsVerticalScrollIndicator = false
        self.view.addSubview(mainscrollview)
        /**用户基本信息区**/
        let bgimg = UIImageView(frame: CGRect(x: 0, y: -20, width: ScreenWidth, height: ScreenWidth/1.8))
        if ScreenWidth == 375 {
            bgimg.image = UIImage(named: "userbg375.png")
        } else {
            bgimg.image = UIImage(named: "userbg.png")
        }
        bgimg.userInteractionEnabled = true
        mainscrollview.addSubview(bgimg)
        //登录按钮
        unlogin = UIView(frame: CGRect(x: (ScreenWidth-ScreenWidth/3.66)/2, y: ScreenWidth/1.8/2.945, width: ScreenWidth/3.66, height: ScreenWidth/3.66/3))
        unlogin.backgroundColor = UIColor.clearColor()
        unlogin.layer.borderWidth = 1
        unlogin.layer.borderColor = UIColor.whiteColor().CGColor
        unlogin.layer.cornerRadius = 3
        unlogin.userInteractionEnabled = true
        unlogin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tologin"))
        bgimg.addSubview(unlogin)
        let unloginlabel = UILabel(frame: CGRect(x: 0, y: (ScreenWidth/3.66/3-20)/2, width: ScreenWidth/3.66, height: 20))
        unloginlabel.font = UIFont.systemFontOfSize(16)
        unloginlabel.textColor = UIColor.whiteColor()
        unloginlabel.textAlignment = NSTextAlignment.Center
        unloginlabel.text = "点此登录"
        unlogin.addSubview(unloginlabel)
        //图像区
        avatar = UIImageView(frame: CGRect(x: (ScreenWidth-ScreenWidth/6.2)/2, y: ScreenWidth/6.2/1.67, width: ScreenWidth/6.2, height: ScreenWidth/6.2))
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = ScreenWidth/6.2/2
        avatar.userInteractionEnabled = true
        avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pullLoadInfo"))
        bgimg.addSubview(avatar)
        username = UILabel(frame: CGRect(x: 0, y: ScreenWidth/6.2/1.67+ScreenWidth/6.2, width: ScreenWidth, height: 20))
        username.font = UIFont.systemFontOfSize(12)
        username.textColor = UIColor.whiteColor()
        username.textAlignment = NSTextAlignment.Center
        bgimg.addSubview(username)
        //黑色信息条
        let infoH = ScreenWidth/1.8/2.875
        let userinfo = UIView(frame: CGRect(x: 0, y: ScreenWidth/1.8-infoH, width: ScreenWidth, height: infoH))
        userinfo.backgroundColor = UIColor.clearColor()
        let uinfobg = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: infoH))
        uinfobg.image = UIImage(named: "uinfobg.png")
        userinfo.addSubview(uinfobg)
        bgimg.addSubview(userinfo)
        //设置按钮
        let setting = UILabel(frame: CGRect(x: ScreenWidth-45, y: ScreenWidth/1.8-infoH-25, width: 40, height: 20))
        setting.text = "更多"
        setting.font = UIFont.systemFontOfSize(12)
        setting.textColor = UIColor.whiteColor()
        setting.textAlignment = NSTextAlignment.Center
        setting.userInteractionEnabled = true
        setting.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tosetting"))
        bgimg.addSubview(setting)
        //积分
        jfval = UILabel(frame: CGRect(x: 0, y: 15, width: ScreenWidth/3, height: 20))
        jfval.text = "0"
        jfval.font = UIFont.systemFontOfSize(16)
        jfval.textColor = UIColor.whiteColor()
        jfval.textAlignment = NSTextAlignment.Center
        userinfo.addSubview(jfval)
        let jflabel = UILabel(frame: CGRect(x: 0, y: 35, width: ScreenWidth/3, height: 20))
        jflabel.text = "积分"
        jflabel.font = UIFont.systemFontOfSize(12)
        jflabel.textColor = UIColor.whiteColor()
        jflabel.textAlignment = NSTextAlignment.Center
        userinfo.addSubview(jflabel)
        //预存款
        yckval = UILabel(frame: CGRect(x: ScreenWidth/3, y: 15, width: ScreenWidth/3, height: 20))
        yckval.text = "0"
        yckval.font = UIFont.systemFontOfSize(16)
        yckval.textColor = UIColor.whiteColor()
        yckval.textAlignment = NSTextAlignment.Center
        userinfo.addSubview(yckval)
        let ycklabel = UILabel(frame: CGRect(x: ScreenWidth/3, y: 35, width: ScreenWidth/3, height: 20))
        ycklabel.text = "预存款"
        ycklabel.font = UIFont.systemFontOfSize(12)
        ycklabel.textColor = UIColor.whiteColor()
        ycklabel.textAlignment = NSTextAlignment.Center
        userinfo.addSubview(ycklabel)
        //充值卡余额
        czkval = UILabel(frame: CGRect(x: ScreenWidth/3*2, y: 15, width: ScreenWidth/3, height: 20))
        czkval.text = "0"
        czkval.font = UIFont.systemFontOfSize(16)
        czkval.textColor = UIColor.whiteColor()
        czkval.textAlignment = NSTextAlignment.Center
        userinfo.addSubview(czkval)
        let czklabel = UILabel(frame: CGRect(x: ScreenWidth/3*2, y: 35, width: ScreenWidth/3, height: 20))
        czklabel.text = "充值卡余额"
        czklabel.font = UIFont.systemFontOfSize(12)
        czklabel.textColor = UIColor.whiteColor()
        czklabel.textAlignment = NSTextAlignment.Center
        userinfo.addSubview(czklabel)
        /**功能块展示**/
        let cellW = (ScreenWidth-40)/3
        let cellH = cellW*1.215
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(cellW, cellH)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let collectview = UICollectionView(frame: CGRect(x: 5, y: ScreenWidth/1.8-20+5, width: ScreenWidth-10, height: cellH*2+20), collectionViewLayout: layout)
        collectview.delegate = self
        collectview.dataSource = self
        collectview.backgroundColor = UIColor.clearColor()
        mainscrollview.addSubview(collectview)
        mainscrollview.contentSize = CGSizeMake(0, 0)
        //添加功能块数据
        let orderfunc = Usercentermodel()
        orderfunc.funccode = "orderlist"
        orderfunc.funcname = "我的订单"
        orderfunc.functip = "查看所有"
        orderfunc.iconpic = "ordericon.png"
        funcList.append(orderfunc)
//   liubw     let xnorderfunc = Usercentermodel()
//        xnorderfunc.funccode = "xnorderlist"
//        xnorderfunc.funcname = "虚拟订单"
//        xnorderfunc.functip = "查看所有"
//        xnorderfunc.iconpic = "ordericon.png"
//        funcList.append(xnorderfunc)
        let favfunc = Usercentermodel()
        favfunc.funccode = "favgoods"
        favfunc.funcname = "收藏商品"
        favfunc.functip = "收藏过的商品"
        favfunc.iconpic = "favicon.png"
        funcList.append(favfunc)
        let storefunc = Usercentermodel()
        storefunc.funccode = "favstore"
        storefunc.funcname = "收藏店铺"
        storefunc.functip = "收藏过的店铺"
        storefunc.iconpic = "favstoreicon.png"
        funcList.append(storefunc)
        let quanfunc = Usercentermodel()
        quanfunc.funccode = "quanlist"
        quanfunc.funcname = "我的代金券"
        quanfunc.functip = "查看所有"
        quanfunc.iconpic = "quanicon.png"
        funcList.append(quanfunc)
        let addressfunc = Usercentermodel()
        addressfunc.funccode = "addresslist"
        addressfunc.funcname = "收货地址"
        addressfunc.functip = "查看所有"
        addressfunc.iconpic = "addressicon.png"
        funcList.append(addressfunc)
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
        /**调取用户基本信息**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        if islogin() {
            activity.startAnimating()
            NSThread.detachNewThreadSelector("loadInfo", toTarget: self, withObject: nil)
            unlogin.hidden = true
            avatar.hidden = false
            username.hidden = false
        } else {
            unlogin.hidden = false
            avatar.hidden = true
            username.hidden = true
        }
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "reloadData", name: "reloadData", object: nil)
        center.addObserver(self, selector: "clearData", name: "clearData", object: nil)
    }
    
    /**设置顶部状态栏**/
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**设置功能区块**/
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return funcList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var nibname = ""
        var cellid = ""
        if ScreenWidth == 320 {
            nibname = "UserCenterCell"
            cellid = "UserCenterCellID"
        }
        if ScreenWidth == 375 {
            nibname = "UserCenterCell375"
            cellid = "UserCenterCellID375"
        }
        if ScreenWidth == 414 {
            nibname = "UserCenterCell414"
            cellid = "UserCenterCellID414"
        }
        var nibregistered = false
        if !nibregistered {
            let nib = UINib(nibName: nibname, bundle: nil)
            collectionView.registerNib(nib, forCellWithReuseIdentifier: cellid)
            nibregistered = true
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellid, forIndexPath: indexPath) as! UserCenterCell
        cell.backgroundColor = UIColor.whiteColor()
        cell.iconimg.image = UIImage(named: funcList[indexPath.row].iconpic)
        cell.funcname.text = funcList[indexPath.row].funcname
        cell.functip.text = funcList[indexPath.row].functip
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if !islogin() {
            let logincontroller = sb.instantiateViewControllerWithIdentifier("LoginViewID") as! LoginViewController
            logincontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(logincontroller, animated: true)
        } else {
            if indexPath.row == 0 {
                let orderlistcontroller = sb.instantiateViewControllerWithIdentifier("OrderListViewID") as! OrderListViewController
                orderlistcontroller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(orderlistcontroller, animated: true)
            }
            if indexPath.row == 1 {
                let favgoodscontroller = sb.instantiateViewControllerWithIdentifier("FavGoodsViewID") as! FavGoodsViewController
                favgoodscontroller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(favgoodscontroller, animated: true)
            }
            if indexPath.row == 2 {
                let fscontroller = sb.instantiateViewControllerWithIdentifier("FavStoreViewID") as! FavStoreViewController
                fscontroller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(fscontroller, animated: true)
            }
            if indexPath.row == 3 {
                let vlcontroller = sb.instantiateViewControllerWithIdentifier("VoucherListViewID") as! VoucherListViewController
                vlcontroller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vlcontroller, animated: true)
            }
            if indexPath.row == 4 {
                let adrlistcontroller = sb.instantiateViewControllerWithIdentifier("AddressListViewID") as! AddressListViewController
                adrlistcontroller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(adrlistcontroller, animated: true)
            }
        }
    }
    
    /**调取用户基本信息**/
    func pullLoadInfo() {
        activity.startAnimating()
        NSThread.detachNewThreadSelector("loadInfo", toTarget: self, withObject: nil)
        NSLog("%@", getkey())
    }
    
    func loadInfo() {
        let key = getkey()
        let paramstr = NSString(format: "key=%@", key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_index")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if respdata == nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "用户数据加载失败请重新登陆", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            avatar.image = UIImage(named: "gcnopic.png")//用户数据加载失败的时候显示的头像
            avatar.hidden = false
            return
        }
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        //如果返回错误信息则需要重新登录
        if data_array.objectForKey("error") != nil {
            let filepath = NSHomeDirectory() + "/Library/Caches/login.txt"
            do {
                try NSFileManager.defaultManager().removeItemAtPath(filepath)
            } catch _ {
            }
            //通知用户中心清空数据
            let center = NSNotificationCenter.defaultCenter()
            center.postNotificationName("clearData", object: self, userInfo: nil)
            self.navigationController?.popViewControllerAnimated(true)
            activity.stopAnimating()
            return
        }
        let member_info = data_array.objectForKey("member_info") as! NSDictionary
        let point = member_info.objectForKey("point") as! String
        jfval.text = point
        let predepoit = member_info.objectForKey("predepoit") as! String
        yckval.text = predepoit
        let available_rc_balance = member_info.objectForKey("available_rc_balance") as! String
        czkval.text = available_rc_balance
        let usernamestr = member_info.objectForKey("user_name") as! String
        username.text = usernamestr
        let avatar_url = member_info.objectForKey("avator") as! String
        if avatar_url != "" {
            let picurl_arr = avatar_url.componentsSeparatedByString("/")
            var img: UIImage
            var data: NSData!
            if picurl_arr[picurl_arr.count - 1] == "" {
                img = UIImage(named: "goods_nopic.png")!
            } else {
                //调用图片缓存or从网络抓取图片数据
                let imagedatapath = NSHomeDirectory() + "/Library/Caches/Avatar/" + picurl_arr[picurl_arr.count - 1]
                if NSFileManager.defaultManager().fileExistsAtPath(imagedatapath) {
                    data = NSFileManager.defaultManager().contentsAtPath(imagedatapath)!
                } else {
                    let url = NSURL(string: avatar_url)!
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
            avatar.image = img
        }
        activity.stopAnimating()
    }
    
    /**其他功能按钮**/
    func tosetting() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let settingcontroller = sb.instantiateViewControllerWithIdentifier("SettingViewID") as! SettingViewController
        settingcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingcontroller, animated: true)
    }
    
    func tologin() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let logincontroller = sb.instantiateViewControllerWithIdentifier("LoginViewID") as! LoginViewController
        self.navigationController?.pushViewController(logincontroller, animated: true)
    }
    
    func reloadData() {
        avatar.hidden = false
        username.hidden = false
        unlogin.hidden = true
        activity.startAnimating()
        NSThread.detachNewThreadSelector("loadInfo", toTarget: self, withObject: nil)
    }
    
    func clearData() {
        jfval.text = "0"
        yckval.text = "0"
        czkval.text = "0"
        avatar.hidden = true
        username.hidden = true
        unlogin.hidden = false
    }
}
