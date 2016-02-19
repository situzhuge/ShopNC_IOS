//
//  AboutusViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/12/18.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit

class AboutusViewController: UIViewController {
    var screenW: CGFloat!
    var screenH: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenW = self.view.frame.width
        screenH = self.view.frame.height
        self.title = "关于我们"
        self.view.backgroundColor = UIColor(red: 246/255, green: 243/255, blue: 238/255, alpha: 1.0)
        let logo = UIImageView(frame: CGRect(x: (screenW-110)/2, y: screenH/4, width: 110, height: 30))
        logo.image = UIImage(named: "logo.png")
        self.view.addSubview(logo)
        let version = UILabel(frame: CGRect(x: 0, y: screenH/4+40, width: screenW, height: 20))
        version.text = VERSION
        version.font = UIFont.systemFontOfSize(14)
        version.textColor = UIColor.grayColor()
        version.textAlignment = NSTextAlignment.Center
        self.view.addSubview(version)
        let copyright = UILabel(frame: CGRect(x: 0, y: screenH/3*2, width: screenW, height: 20))
        copyright.text = COPYRIGHT
        copyright.font = UIFont.systemFontOfSize(14)
        copyright.textColor = UIColor(red: 162/255, green: 152/255, blue: 143/255, alpha: 1.0)
        copyright.textAlignment = NSTextAlignment.Center
        self.view.addSubview(copyright)
        let copyright2 = UILabel(frame: CGRect(x: 0, y: screenH/3*2+20, width: screenW, height: 20))
        copyright2.text = COPYRIGHT2
        copyright2.font = UIFont.systemFontOfSize(14)
        copyright2.textColor = UIColor(red: 162/255, green: 152/255, blue: 143/255, alpha: 1.0)
        copyright2.textAlignment = NSTextAlignment.Center
        self.view.addSubview(copyright2)
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
        UIView.setAnimationsEnabled(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
