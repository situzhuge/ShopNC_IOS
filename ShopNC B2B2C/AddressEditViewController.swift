//
//  AddressEditViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/4.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class AddressEditViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    var adrinfo: Addressmodel!
    var mode = ""
    var ScreenWidth: CGFloat!
    var activity: UIActivityIndicatorView!
    var mainview = UIScrollView()
    //数据信息
    var contacttext = UITextField()
    var areainfotext = UITextField()
    var addresstext = UITextField()
    var telphonetext = UITextField()
    var mobphonetext = UITextField()
    var area_id = ""
    var city_id = ""
    //地区选择信息
    var areaview: UIView!
    var areapicker: UIPickerView!
    var provinceList = [Areamodel]()
    var cityList = [Areamodel]()
    var areaList = [Areamodel]()
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        if mode == "add" {
            self.title = "新增收货地址"
        }
        if mode == "edit" {
            self.title = "编辑收货地址"
        }
        ScreenWidth = self.view.frame.width
        mainview.frame = self.view.frame
        mainview.contentSize = CGSizeMake(0, self.view.frame.height+50)
        self.view.addSubview(mainview)
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        contacttext.frame = CGRect(x: 10, y: 20, width: ScreenWidth-20, height: 40)
        contacttext.placeholder = "请输入收货人姓名"
        contacttext.font = UIFont.systemFontOfSize(14)
        contacttext.clearButtonMode = UITextFieldViewMode.WhileEditing
        contacttext.backgroundColor = UIColor.whiteColor()
        contacttext.borderStyle = UITextBorderStyle.RoundedRect
        contacttext.leftView = padding
        contacttext.tag = 1
        contacttext.autocapitalizationType = UITextAutocapitalizationType.None
        contacttext.delegate = self
        mainview.addSubview(contacttext)
        areainfotext.frame = CGRect(x: 10, y: 65, width: ScreenWidth-20, height: 40)
        areainfotext.placeholder = "请选择地区"
        areainfotext.font = UIFont.systemFontOfSize(14)
        areainfotext.clearButtonMode = UITextFieldViewMode.WhileEditing
        areainfotext.backgroundColor = UIColor.whiteColor()
        areainfotext.borderStyle = UITextBorderStyle.RoundedRect
        areainfotext.leftView = padding
        areainfotext.tag = 2
        areainfotext.delegate = self
        mainview.addSubview(areainfotext)
        addresstext.frame = CGRect(x: 10, y: 110, width: ScreenWidth-20, height: 40)
        addresstext.placeholder = "请输入详细地址"
        addresstext.font = UIFont.systemFontOfSize(14)
        addresstext.clearButtonMode = UITextFieldViewMode.WhileEditing
        addresstext.backgroundColor = UIColor.whiteColor()
        addresstext.borderStyle = UITextBorderStyle.RoundedRect
        addresstext.leftView = padding
        addresstext.tag = 3
        addresstext.delegate = self
        mainview.addSubview(addresstext)
        telphonetext.frame = CGRect(x: 10, y: 155, width: ScreenWidth-20, height: 40)
        telphonetext.placeholder = "请输入座机电话号码"
        telphonetext.font = UIFont.systemFontOfSize(14)
        telphonetext.clearButtonMode = UITextFieldViewMode.WhileEditing
        telphonetext.backgroundColor = UIColor.whiteColor()
        telphonetext.borderStyle = UITextBorderStyle.RoundedRect
        telphonetext.leftView = padding
        telphonetext.tag = 4
        telphonetext.delegate = self
        telphonetext.keyboardType = UIKeyboardType.PhonePad
        mainview.addSubview(telphonetext)
        mobphonetext.frame = CGRect(x: 10, y: 200, width: ScreenWidth-20, height: 40)
        mobphonetext.placeholder = "请输入手机电话号码"
        mobphonetext.font = UIFont.systemFontOfSize(14)
        mobphonetext.clearButtonMode = UITextFieldViewMode.WhileEditing
        mobphonetext.backgroundColor = UIColor.whiteColor()
        mobphonetext.borderStyle = UITextBorderStyle.RoundedRect
        mobphonetext.leftView = padding
        mobphonetext.tag = 5
        mobphonetext.delegate = self
        mobphonetext.keyboardType = UIKeyboardType.PhonePad
        mainview.addSubview(mobphonetext)
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
        /**编辑模式添加数据**/
        if mode == "edit" {
            contacttext.text = adrinfo.true_name
            areainfotext.text = adrinfo.area_info
            addresstext.text = adrinfo.address
            telphonetext.text = adrinfo.tel_phone
            mobphonetext.text = adrinfo.mob_phone
            area_id = adrinfo.area_id
            city_id = adrinfo.city_id
        }
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        /**地区选择器**/
        areaview = UIView(frame: CGRect(x: 0, y: self.view.frame.height-300, width: ScreenWidth, height: 300))
        areaview.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
        self.view.addSubview(areaview)
        let areabtn = UILabel(frame: CGRect(x: ScreenWidth-70, y: 10, width: 60, height: 30))
        areabtn.text = "完成"
        areabtn.textAlignment = NSTextAlignment.Center
        areabtn.font = UIFont.systemFontOfSize(16)
        areabtn.layer.borderColor = UIColor.blackColor().CGColor
        areabtn.layer.borderWidth = 1
        areabtn.layer.cornerRadius = 3
        areabtn.userInteractionEnabled = true
        areabtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addareainfo"))
        areaview.addSubview(areabtn)
        areapicker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        areapicker.showsSelectionIndicator = true
        areapicker.dataSource = self
        areapicker.delegate = self
        areaview.addSubview(areapicker)
        areaview.hidden = true
        //加载地区数据
        NSThread.detachNewThreadSelector("autoarea", toTarget: self, withObject: nil)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "save")
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**输入框相关设置**/
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 2 {
            contacttext.resignFirstResponder()
            areainfotext.resignFirstResponder()
            addresstext.resignFirstResponder()
            telphonetext.resignFirstResponder()
            mobphonetext.resignFirstResponder()
            areaview.hidden = false
            return false
        } else {
            areaview.hidden = true
            return true
        }
    }
    
    /**保存数据**/
    func save() {
        activity.startAnimating()
        var rs = false
        let key = getkey()
        let contact = contacttext.text
        let areainfo = areainfotext.text
        let address = addresstext.text
        let telphone = telphonetext.text
        let mobphone = mobphonetext.text
        if contact == "" || areainfo == "" || address == "" || telphone == "" || mobphone == ""  {
            let alert = UIAlertView(title: "提示", message: "所有项目都要填写", delegate: self, cancelButtonTitle: "知道了")
            alert.show()
            activity.stopAnimating()
            return
        }
        if mode == "add" {
            let paramstr = NSString(format: "key=%@&true_name=%@&city_id=%@&area_id=%@&area_info=%@&address=%@&tel_phone=%@&mob_phone=%@", key, contact!, city_id, area_id, areainfo!, address!, telphone!, mobphone!)
            let paramstrlen = paramstr.length
            let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: API_URL + "index.php?act=member_address&op=address_add")
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postdata
            let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            activity.stopAnimating()
            if respdata == nil {
                let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                return
            }
            let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
            if data_array.objectForKey("error") == nil {
                let address_id: AnyObject! = data_array.objectForKey("address_id")
                if let aid = address_id as? Int {
                    rs = true
                }
            }
        }
        if mode == "edit" {
            let address_id = adrinfo.address_id
            let paramstr = NSString(format: "key=%@&true_name=%@&city_id=%@&area_id=%@&area_info=%@&address=%@&tel_phone=%@&mob_phone=%@&address_id=%@", key, contact!, city_id, area_id, areainfo!, address!, telphone!, mobphone!, address_id)
            let paramstrlen = paramstr.length
            let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: API_URL + "index.php?act=member_address&op=address_edit")
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postdata
            let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            activity.stopAnimating()
            if respdata == nil {
                let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                return
            }
            let data_array_str: AnyObject! = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas")
            if let data_array = data_array_str as? String {
                if data_array == "1" {
                    rs = true
                }
            }
        }
        if rs {
            //通知收货地址列表界面刷新数据
            let center = NSNotificationCenter.defaultCenter()
            center.postNotificationName("AdrRefreshData", object: self, userInfo: nil)
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            tipstr.text = "保存失败"
            tipimg.image = UIImage(named: "error.png")
            tipshow.hidden = false
            //延时关闭提示框
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
        }
    }
    
    //隐藏黑色提示框
    func hidetip() {
        tipshow.hidden = true
    }
    
    /**地区选择器相关设置**/
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var num = 0
        if component == 0 {
            num = provinceList.count
        }
        if component == 1 {
            num = cityList.count
        }
        if component == 2 {
            num = areaList.count
        }
        return num
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var area_name = ""
        if component == 0 {
            area_name = provinceList[row].area_name
        }
        if component == 1 {
            area_name = cityList[row].area_name
        }
        if component == 2 {
            area_name = areaList[row].area_name
        }
        return area_name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            cityList.removeAll(keepCapacity: false)
            let data = ["city", provinceList[row].area_id]
            loadarea(data)
            areaList.removeAll(keepCapacity: false)
            let adata = ["area", cityList[0].area_id]
            loadarea(adata)
        }
        if component == 1 {
            areaList.removeAll(keepCapacity: false)
            let data = ["area", cityList[row].area_id]
            loadarea(data)
        }
    }
    
    /**调取地区信息**/
    func loadarea(data: NSArray) {
        activity.startAnimating()
        let key = getkey()
        var paramstr: NSString!
        let type = data.objectAtIndex(0) as! String
        let area_id = data.objectAtIndex(1) as! String
        if type == "province" {
            paramstr = NSString(format: "key=%@", key)
        } else {
            paramstr = NSString(format: "key=%@&area_id=%@", key, area_id)
        }
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_address&op=area_list")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        let area_array: AnyObject! = data_array.objectForKey("area_list")
        if let area_list = area_array as? NSArray {
            for areainfo in area_list {
                let area = areainfo as! NSDictionary
                let aid = area.objectForKey("area_id") as! String
                let aname = area.objectForKey("area_name") as! String
                let newarea = Areamodel()
                newarea.area_id = aid
                newarea.area_name = aname
                if type == "province" {
                    provinceList.append(newarea)
                }
                if type == "city" {
                    cityList.append(newarea)
                }
                if type == "area" {
                    areaList.append(newarea)
                }
            }
        }
        areapicker.reloadAllComponents()
        activity.stopAnimating()
    }
    
    /**根据选择填写地区信息**/
    func addareainfo() {
        let prow = areapicker.selectedRowInComponent(0)
        let crow = areapicker.selectedRowInComponent(1)
        let arow = areapicker.selectedRowInComponent(2)
        areainfotext.text = provinceList[prow].area_name + cityList[crow].area_name + areaList[arow].area_name
        city_id = cityList[crow].area_id
        area_id = areaList[arow].area_id
        areaview.hidden = true
    }
    
    /**自动选择已有地区**/
    func autoarea() {
        let pdata = ["province", ""]
        loadarea(pdata)
        let cdata = ["city", provinceList[0].area_id]
        loadarea(cdata)
        let adata = ["area", cityList[0].area_id]
        loadarea(adata)
    }
}