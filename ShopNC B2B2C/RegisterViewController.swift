//用户注册页面

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    var ScreenWidth: CGFloat!
    var activity: UIActivityIndicatorView!
    var usernametext = UITextField()
    var passwordtext = UITextField()
    var repasswordtext = UITextField()
    var emailtext = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "快速注册"
        ScreenWidth = self.view.frame.width
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
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
        passwordtext.returnKeyType = UIReturnKeyType.Next
        passwordtext.leftView = padding
        passwordtext.tag = 2
        passwordtext.delegate = self
        self.view.addSubview(passwordtext)
        repasswordtext.frame = CGRect(x: 10, y: 110, width: ScreenWidth-20, height: 40)
        repasswordtext.placeholder = "请确认密码"
        repasswordtext.font = UIFont.systemFontOfSize(14)
        repasswordtext.clearButtonMode = UITextFieldViewMode.WhileEditing
        repasswordtext.secureTextEntry = true
        repasswordtext.backgroundColor = UIColor.whiteColor()
        repasswordtext.borderStyle = UITextBorderStyle.RoundedRect
        repasswordtext.returnKeyType = UIReturnKeyType.Next
        repasswordtext.leftView = padding
        repasswordtext.tag = 3
        repasswordtext.delegate = self
        self.view.addSubview(repasswordtext)
        emailtext.frame = CGRect(x: 10, y: 155, width: ScreenWidth-20, height: 40)
        emailtext.placeholder = "请输入邮箱地址"
        emailtext.font = UIFont.systemFontOfSize(14)
        emailtext.clearButtonMode = UITextFieldViewMode.WhileEditing
        emailtext.backgroundColor = UIColor.whiteColor()
        emailtext.borderStyle = UITextBorderStyle.RoundedRect
        emailtext.returnKeyType = UIReturnKeyType.Go
        emailtext.leftView = padding
        emailtext.tag = 4
        emailtext.delegate = self
        self.view.addSubview(emailtext)
        let btnW = (ScreenWidth-30)/2
        let regbtn = UIButton(frame: CGRect(x: 10, y: 205, width: btnW, height: 40))
        regbtn.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0)
        regbtn.layer.cornerRadius = 3
        regbtn.layer.borderWidth = 1
        regbtn.layer.borderColor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1.0).CGColor
        regbtn.addTarget(self, action: "goback", forControlEvents: UIControlEvents.TouchUpInside)
        regbtn.setTitle("返回登录", forState: UIControlState.Normal)
        regbtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        regbtn.setTitleColor(UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0), forState: UIControlState.Normal)
        self.view.addSubview(regbtn)
        let loginbtn = UIButton(frame: CGRect(x: btnW+20, y: 205, width: btnW, height: 40))
        loginbtn.backgroundColor = UIColor(red: 196/255, green: 0/255, blue: 8/255, alpha: 1.0)
        loginbtn.layer.cornerRadius = 3
        loginbtn.addTarget(self, action: "doregister", forControlEvents: UIControlEvents.TouchUpInside)
        loginbtn.setTitle("立即注册", forState: UIControlState.Normal)
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
        self.view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**编辑框的一些设置和响应处理**/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 1 {
            passwordtext.becomeFirstResponder()
        }
        if textField.tag == 2 {
            repasswordtext.becomeFirstResponder()
        }
        if textField.tag == 3 {
            emailtext.becomeFirstResponder()
        }
        if textField.tag == 4 {
            doregister()
        }
        return true
    }
    
    /**按钮操作**/
    func doregister() {
        if usernametext.text != "" && passwordtext.text != "" && repasswordtext.text != "" && emailtext.text != "" {
            activity.startAnimating()
            register()
        } else {
            let alert = UIAlertView(title: "提示", message: "所有项目都要填写", delegate: self, cancelButtonTitle: "知道了")
            alert.show()
        }
    }
    
    func goback() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**注册操作**/
    func register() {
        let paramstr = NSString(format: "username=%@&password=%@&password_confirm=%@&email=%@&client=ios", usernametext.text!, passwordtext.text!, repasswordtext.text!, emailtext.text!)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: API_URL + "index.php?act=login&op=register")
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
            activity.stopAnimating()
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "注册失败", delegate: self, cancelButtonTitle: "知道了")
            alert.show()
        }
    }
}
