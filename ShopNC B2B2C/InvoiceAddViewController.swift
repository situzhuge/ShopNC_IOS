//
//  InvoiceAddViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/10.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class InvoiceAddViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    var ScreenWidth: CGFloat!
    var typeImg1: UIImageView!
    var typeImg2: UIImageView!
    var type = 1//1-个人, 2-单位
    var company = UITextField()
    var context = UITextField()
    var activity: UIActivityIndicatorView!
    var areaview: UIView!
    var areapicker: UIPickerView!
    var contextList = [String]()
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenWidth = self.view.frame.width
        self.title = "添加新发票"
        typeImg1 = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        typeImg1.image = UIImage(named: "checked.png")
        typeImg1.tag = 1
        typeImg1.userInteractionEnabled = true
        typeImg1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "switchtype:"))
        let typelabel1 = UILabel(frame: CGRect(x: 45, y: 10, width: 50, height: 30))
        typelabel1.font = UIFont.systemFontOfSize(16)
        typelabel1.text = "个人"
        self.view.addSubview(typeImg1)
        self.view.addSubview(typelabel1)
        typeImg2 = UIImageView(frame: CGRect(x: 100, y: 10, width: 30, height: 30))
        typeImg2.image = UIImage(named: "uncheck.png")
        typeImg2.tag = 2
        typeImg2.userInteractionEnabled = true
        typeImg2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "switchtype:"))
        let typelabel2 = UILabel(frame: CGRect(x: 135, y: 10, width: 50, height: 30))
        typelabel2.font = UIFont.systemFontOfSize(16)
        typelabel2.text = "单位"
        self.view.addSubview(typeImg2)
        self.view.addSubview(typelabel2)
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        company.frame = CGRect(x: 10, y: 45, width: ScreenWidth-20, height: 40)
        company.placeholder = "请输入单位名称（个人无需填写）"
        company.font = UIFont.systemFontOfSize(14)
        company.clearButtonMode = UITextFieldViewMode.WhileEditing
        company.backgroundColor = UIColor.whiteColor()
        company.borderStyle = UITextBorderStyle.RoundedRect
        company.leftView = padding
        company.tag = 1
        company.autocapitalizationType = UITextAutocapitalizationType.None
        company.delegate = self
        self.view.addSubview(company)
        context.frame = CGRect(x: 10, y: 90, width: ScreenWidth-20, height: 40)
        context.placeholder = "请选择发票内容"
        context.font = UIFont.systemFontOfSize(14)
        context.clearButtonMode = UITextFieldViewMode.WhileEditing
        context.backgroundColor = UIColor.whiteColor()
        context.borderStyle = UITextBorderStyle.RoundedRect
        context.leftView = padding
        context.tag = 2
        context.delegate = self
        self.view.addSubview(context)
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
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
        /**发票内容选择器**/
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
        areabtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addContextinfo"))
        areaview.addSubview(areabtn)
        areapicker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        areapicker.showsSelectionIndicator = true
        areapicker.dataSource = self
        areapicker.delegate = self
        areaview.addSubview(areapicker)
        areaview.hidden = true
        //加载地区数据
        NSThread.detachNewThreadSelector("loadContext", toTarget: self, withObject: nil)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "save")
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**切换发票类型**/
    func switchtype(recognizer: UITapGestureRecognizer) {
        let choosetype = recognizer.view!.tag
        if choosetype == 2 {
            typeImg1.image = UIImage(named: "uncheck.png")
            typeImg2.image = UIImage(named: "checked.png")
            type = 2
        } else {
            typeImg1.image = UIImage(named: "checked.png")
            typeImg2.image = UIImage(named: "uncheck.png")
            type = 1
        }
    }
    
    /**输入框相关设置**/
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 2 {
            company.resignFirstResponder()
            areaview.hidden = false
            return false
        } else {
            areaview.hidden = true
            return true
        }
    }
    
    /**添加数据**/
    func save() {
        activity.startAnimating()
        var rs = false
        let key = getkey()
        let companyinfo = company.text
        let contextinfo = context.text
        if contextinfo == ""  {
            let alert = UIAlertView(title: "提示", message: "请选择发票内容", delegate: self, cancelButtonTitle: "知道了")
            alert.show()
            activity.stopAnimating()
            return
        }
        var inv_title_select = ""
        var paramstr: NSString!
        if type == 1 {
            inv_title_select = "person"
            paramstr = NSString(format: "key=%@&inv_title_select=%@&inv_content=%@", key, inv_title_select, contextinfo!)
        } else {
            inv_title_select = "company"
            paramstr = NSString(format: "key=%@&inv_title_select=%@&inv_content=%@&inv_title=%@", key, inv_title_select, contextinfo!, companyinfo!)
        }
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_invoice&op=invoice_add")
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
            if data_array.objectForKey("inv_id") != nil {
                rs = true
            }
        }
        if rs {
            //通知发票列表界面刷新数据
            let center = NSNotificationCenter.defaultCenter()
            center.postNotificationName("InvRefreshData", object: self, userInfo: nil)
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
    
    /**发票选择器相关设置**/
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contextList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return contextList[row]
    }
    
    /**加载发票内容数据**/
    func loadContext() {
        let key = getkey()
        let paramstr = NSString(format: "key=%@", key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=member_invoice&op=invoice_content_list")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        if data_array.objectForKey("invoice_content_list") != nil {
            let context_list = data_array.objectForKey("invoice_content_list") as! NSArray
            for val in context_list {
                let context_str = val as! String
                contextList.append(context_str)
            }
        }
        areapicker.reloadAllComponents()
    }
    
    func addContextinfo() {
        let selectrow = areapicker.selectedRowInComponent(0)
        context.text = contextList[selectrow]
        areaview.hidden = true
    }
}
