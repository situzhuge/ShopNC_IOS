//
//  ScanViewController.swift
//  ShopNC B2B2C
//
//  Created by 李梓平 on 15/1/16.
//  Copyright (c) 2015年 ShopNC. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    var screenW: CGFloat!
    var screenH: CGFloat!
    var torchbtn = UIButton()
    var mode = "LedOff"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenW = self.view.frame.width
        screenH = self.view.frame.height-64
        self.title = "商品条码扫描"
        self.view.backgroundColor = UIColor.blackColor()
        let labIntroudction = UILabel(frame:CGRectMake(0, (screenH-200)/2+220, screenW, 50))
        labIntroudction.backgroundColor = UIColor.clearColor()
        labIntroudction.numberOfLines = 2
        labIntroudction.textColor = UIColor.whiteColor()
        labIntroudction.textAlignment = NSTextAlignment.Center
        labIntroudction.text = "将商品条码置于矩形方框内，即可自动扫描"
        self.view.addSubview(labIntroudction)
        let imageView = UIImageView(frame:CGRectMake((screenW-300)/2, (screenH-200)/2, 300, 200))
        imageView.image = UIImage(named:"pick_bg.png")
        self.view.addSubview(imageView)
        //闪光灯按钮
        torchbtn.frame.size = CGSizeMake(30, 30)
        torchbtn.addTarget(self, action: "torchmode", forControlEvents: UIControlEvents.TouchUpInside)
        torchbtn.setBackgroundImage(UIImage(named: "ledoff.png"), forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: torchbtn)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        if allow_camera() {
            self.setupCamera()
        } else {
            let alert = UIAlertView(title: "提示", message: "是否允许使用相机", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "允许")
            alert.show()
        }
        self.session.startRunning()
        UIView.setAnimationsEnabled(true)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if btnlabel == "允许" {
            let str = "allow"
            let keydata = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            let datapath = NSHomeDirectory() + "/Library/Caches/allowcamera.txt"
            keydata.writeToFile(datapath, atomically: false)
            self.setupCamera()
        }
        if btnlabel == "取消" {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupCamera(){
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error : NSError?
        let input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch var error1 as NSError {
            error = error1
            input = nil
        }
        if (error != nil) {
            print(error?.description)
            return
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = CGRectMake(0,0,screenW,screenH);
        self.view.layer.insertSublayer(self.layer!, atIndex: 0)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        }
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        var goods_barcode = ""
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            goods_barcode = metadataObject.stringValue
        }
        self.session.stopRunning()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let glcontroller = sb.instantiateViewControllerWithIdentifier("GoodsListID") as! GoodsListViewController
        glcontroller.barcode = goods_barcode
        glcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(glcontroller, animated: true)
    }
    
    /**闪光灯设置**/
    func torchmode() {
        if mode == "LedOn" {
            torchbtn.setBackgroundImage(UIImage(named: "ledoff.png"), forState: UIControlState.Normal)
            mode = "LedOff"
            turnOffLed()
        } else {
            torchbtn.setBackgroundImage(UIImage(named: "ledon.png"), forState: UIControlState.Normal)
            mode = "LedOn"
            turnOnLed()
        }
    }
    
    func turnOnLed() {
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
            } catch _ {
            }
            device.torchMode = AVCaptureTorchMode.On
            device.unlockForConfiguration()
        }
    }
    
    func turnOffLed() {
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
            } catch _ {
            }
            device.torchMode = AVCaptureTorchMode.Off
            device.unlockForConfiguration()
        }
    }
}