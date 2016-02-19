//登录页面

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    var activity: UIActivityIndicatorView!
    var usernametext = UITextField()
    var passwordtext = UITextField()
    var ScreenWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        ScreenWidth = self.view.frame.width
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        usernametext.frame = CGRect(x: 10, y: 20, width: ScreenWidth-20, height: 40)
        usernametext.placeholder = "请输入用户名"
        usernametext.font = UIFont.systemFontOfSize(14)
        usernametext.clearButtonMode = UITextFieldViewMode.WhileEditing
        usernametext.backgroundColor = UIColor.whiteColor()
        usernametext.borderStyle = UITextBorderStyle.RoundedRect
        usernametext.returnKeyType = UIReturnKeyType.Next
        usernametext.leftView = padding
        usernametext.tag = 1
        usernametext.becomeFirstResponder()
        usernametext.autocapitalizationType = UITextAutocapitalizationType.None
        usernametext.delegate = self
        self.view.addSubview(usernametext)
        passwordtext.frame = CGRect(x: 10, y: 65, width: ScreenWidth-20, height: 40)
        passwordtext.placeholder = "请输入密码"
        passwordtext.font = UIFont.systemFontOfSize(14)
        passwordtext.clearButtonMode = UITextFieldViewMode.WhileEditing
        passwordtext.secureTextEntry = true
        passwordtext.backgroundColor = UIColor.whiteColor()
        passwordtext.borderStyle = UITextBorderStyle.RoundedRect
        passwordtext.returnKeyType = UIReturnKeyType.Go
        passwordtext.leftView = padding
        passwordtext.tag = 2
        passwordtext.delegate = self
        self.view.addSubview(passwordtext)
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        let btnW = (ScreenWidth-30)/2
        let regbtn = UIButton(frame: CGRect(x: 10, y: 115, width: btnW, height: 40))
        regbtn.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0)
        regbtn.layer.cornerRadius = 3
        regbtn.layer.borderWidth = 1
        regbtn.layer.borderColor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1.0).CGColor
        regbtn.addTarget(self, action: "toregister", forControlEvents: UIControlEvents.TouchUpInside)
        regbtn.setTitle("快速注册", forState: UIControlState.Normal)
        regbtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        regbtn.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), forState: UIControlState.Normal)
        self.view.addSubview(regbtn)
        let loginbtn = UIButton(frame: CGRect(x: btnW+20, y: 115, width: btnW, height: 40))
        loginbtn.backgroundColor = UIColor(red: 196/255, green: 0/255, blue: 8/255, alpha: 1.0)
        loginbtn.layer.cornerRadius = 3
        loginbtn.addTarget(self, action: "dologin", forControlEvents: UIControlEvents.TouchUpInside)
        loginbtn.setTitle("登录", forState: UIControlState.Normal)
        loginbtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        loginbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.view.addSubview(loginbtn)
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "goback")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        UIView.setAnimationsEnabled(true)
        if islogin() {
            goback()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goback() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**编辑框的一些设置和响应处理**/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 1 {
            passwordtext.becomeFirstResponder()
        }
        if textField.tag == 2 {
            dologin()
        }
        return true
    }
    
    /**按钮操作**/
    func dologin() {
        if usernametext.text != "" && passwordtext.text != "" {
            activity.startAnimating()
            login()
        } else {
            let alert = UIAlertView(title: "提示", message: "请填写用户名和密码", delegate: self, cancelButtonTitle: "知道了")
            alert.show()
        }
    }
    
    func toregister() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let regcontroller = sb.instantiateViewControllerWithIdentifier("RegViewID") as! RegisterViewController
        self.navigationController?.pushViewController(regcontroller, animated: true)
    }
    
    /**登陆操作**/
    func login() {
        let paramstr = NSString(format: "username=%@&password=%@&client=ios", usernametext.text!, passwordtext.text!)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=login")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        
        if respdata == nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        let key: AnyObject! = data_array.objectForKey("key")
        if let keyval = key as? String {
            let keydata = keyval.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            let datapath = NSHomeDirectory() + "/Library/Caches/login.txt"
            keydata.writeToFile(datapath, atomically: false)
            //通知用户中心刷新数据
            let center = NSNotificationCenter.defaultCenter()
            center.postNotificationName("reloadData", object: self, userInfo: nil)
            //通知购物车刷新数据
            center.postNotificationName("CartRefreshData", object: self, userInfo: nil)
            activity.stopAnimating()
            goback()
        } else {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "用户名或密码错误", delegate: self, cancelButtonTitle: "知道了")
            alert.show()
        }
    }
}