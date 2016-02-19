//
//  GoodsDetailViewController.swift
//  ShopNC B2B2C
//
//  Created by lzp on 14/11/12.
//  Copyright (c) 2014年 ShopNC. All rights reserved.
//

import UIKit
import Foundation

class GoodsDetailViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate, UIActionSheetDelegate {
    var ScreenWidth: CGFloat!
    var activity: UIActivityIndicatorView!
    var goods_id = ""
    let mainscrollview = UIScrollView()
    let picview = UIScrollView()
    var picList = [String]()
    var smallnavibar = UIImageView()
    var goodsname: UILabel!
    var goodsjingle: UILabel!
    var goodsprice: UILabel!
    var stgval: UILabel!
    var snumval: UILabel!
    var colval: UILabel!
    var star_1 = UIImageView()
    var star_2 = UIImageView()
    var star_3 = UIImageView()
    var star_4 = UIImageView()
    var star_5 = UIImageView()
    var evalnum: UILabel!
    var attrinfo: UILabel!
    var stlable: UILabel!
    var fma = UIImageView()
    var xvni = UIImageView()
    var yvyue = UIImageView()
    var yvshou = UIImageView()
    var mansong: UILabel!
    var zengpin: UILabel!
    var msselectimg: UIImageView!
    var zpselectimg: UIImageView!
    var mobile_body = ""
    var goodsparamList = [Goodsparammodel]()
    var giftList = [Giftmodel]()
    var msList = [Msmodel]()
    var msclick = true
    var zpclick = true
    var recgoods = [Goodsmodel]()
    var collectview: UICollectionView!
    var goods_name = ""
    var goods_image_url = ""
    var goods_price = ""
    var attrList = [Attrmodel]()
    var specgoods = [String:String]()
    var attrview = [String:UIView]()
    var attrlables = [UILabel]()
    var buynum = 1
    var choosespec = [String:String]()
    var buynumshow: UILabel!
    var favimg: UIImageView!
    var fav_id = ""
    var cartnumshow = UIView()
    var cartnumlabel: UILabel!
    var fcode = false
    var ifxvni = false
    var buynowbtn: UIButton!
    var addcartbtn: UIButton!
    var cartshowbtn: UIImageView!
    var store_id = ""
    var stselectimg: UIImageView!
    var finish_load = false
    var picnum: UILabel!
    var picallnum = 0
    //黑色提示框
    var tipshow = UIView()
    var tipstr: UILabel!
    var tipimg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreenWidth = self.view.frame.width
        /**添加主scrollview**/
        mainscrollview.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: self.view.frame.height-50)
        mainscrollview.contentSize = CGSizeMake(0, ((ScreenWidth-40)/3*2.7)+ScreenWidth+533)
        mainscrollview.delegate = self
        mainscrollview.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        self.view.addSubview(mainscrollview)
        /**添加商品图片**/
        picview.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth)
        picview.pagingEnabled = true
        picview.delegate = self
        picview.tag = 99
        picview.showsHorizontalScrollIndicator = false
        mainscrollview.addSubview(picview)
        /**图片数量**/
        let picnumshow = UIImageView(frame: CGRect(x: ScreenWidth-50, y: ScreenWidth-50, width: 40, height: 40))
        picnumshow.image = UIImage(named: "gray_circle.png")
        mainscrollview.addSubview(picnumshow)
        picnum = UILabel(frame: CGRect(x: 0, y: 10, width: 40, height: 20))
        picnum.text = "0/0"
        picnum.textColor = UIColor.whiteColor()
        picnum.textAlignment = NSTextAlignment.Center
        picnum.font = UIFont.systemFontOfSize(14)
        picnumshow.addSubview(picnum)
        /**添加商品名称区块**/
        let GNView = UIView(frame: CGRect(x: 0, y: ScreenWidth, width: ScreenWidth, height: 118))
        GNView.backgroundColor = UIColor.whiteColor()
        GNView.layer.borderWidth = 0.5
        GNView.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).CGColor
        mainscrollview.addSubview(GNView)
        goodsname = UILabel(frame: CGRect(x: 10, y: 10, width: ScreenWidth-20, height: 40))
        goodsname.font = UIFont.systemFontOfSize(16)
        goodsname.textColor = UIColor.blackColor()
        goodsname.textAlignment = NSTextAlignment.Left
        goodsname.numberOfLines = 3
        GNView.addSubview(goodsname)
        goodsjingle = UILabel(frame: CGRect(x: 10, y: 50, width: ScreenWidth-20, height: 35))
        goodsjingle.font = UIFont.systemFontOfSize(14)
        goodsjingle.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        goodsjingle.textAlignment = NSTextAlignment.Left
        goodsjingle.numberOfLines = 3
        GNView.addSubview(goodsjingle)
        goodsprice = UILabel(frame: CGRect(x: 10, y: 90, width: ScreenWidth/3, height: 18))
        goodsprice.font = UIFont.boldSystemFontOfSize(18)
        goodsprice.textColor = UIColor(red: 208/255, green: 31/255, blue: 0/255, alpha: 1.0)
        goodsprice.textAlignment = NSTextAlignment.Left
        goodsprice.numberOfLines = 1
        GNView.addSubview(goodsprice)
        fma.frame = CGRect(x: ScreenWidth-139, y: 90, width: 30, height: 15)
        fma.image = UIImage(named: "fma.png")
        fma.hidden = true
        GNView.addSubview(fma)
        xvni.frame = CGRect(x: ScreenWidth-139+33, y: 90, width: 30, height: 15)
        xvni.image = UIImage(named: "xvni.png")
        xvni.hidden = true
        GNView.addSubview(xvni)
        yvyue.frame = CGRect(x: ScreenWidth-139+66, y: 90, width: 30, height: 15)
        yvyue.image = UIImage(named: "yvyue.png")
        yvyue.hidden = true
        GNView.addSubview(yvyue)
        yvshou.frame = CGRect(x: ScreenWidth-139+99, y: 90, width: 30, height: 15)
        yvshou.image = UIImage(named: "yvshou.png")
        yvshou.hidden = true
        GNView.addSubview(yvshou)
        /**评分信息区块**/
        let EVALView = UIView(frame: CGRect(x: 0, y: ScreenWidth+123, width: ScreenWidth, height: 100))
        EVALView.backgroundColor = UIColor.whiteColor()
        EVALView.layer.borderWidth = 0.5
        EVALView.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).CGColor
        mainscrollview.addSubview(EVALView)
        let gapone = UIImageView(frame: CGRect(x: ScreenWidth/3-5, y: 10, width: 10, height: 40))
        gapone.image = UIImage(named: "gap.png")
        EVALView.addSubview(gapone)
        let gaptwo = UIImageView(frame: CGRect(x: ScreenWidth/3*2-5, y: 10, width: 10, height: 40))
        gaptwo.image = UIImage(named: "gap.png")
        EVALView.addSubview(gaptwo)
        let stglable = UILabel(frame: CGRect(x: ScreenWidth/9, y: 10, width: ScreenWidth/9, height: 20))
        stglable.font = UIFont.systemFontOfSize(14)
        stglable.textColor = UIColor.grayColor()
        stglable.text = "库存"
        stglable.textAlignment = NSTextAlignment.Center
        EVALView.addSubview(stglable)
        stgval = UILabel(frame: CGRect(x: ScreenWidth/9, y: 35, width: ScreenWidth/9, height: 20))
        stgval.font = UIFont.systemFontOfSize(14)
        stgval.textColor = UIColor.blackColor()
        stgval.textAlignment = NSTextAlignment.Center
        EVALView.addSubview(stgval)
        let snumlable = UILabel(frame: CGRect(x: ScreenWidth/9*4, y: 10, width: ScreenWidth/9, height: 20))
        snumlable.font = UIFont.systemFontOfSize(14)
        snumlable.textColor = UIColor.grayColor()
        snumlable.text = "销量"
        snumlable.textAlignment = NSTextAlignment.Center
        EVALView.addSubview(snumlable)
        snumval = UILabel(frame: CGRect(x: ScreenWidth/9*4, y: 35, width: ScreenWidth/9, height: 20))
        snumval.font = UIFont.systemFontOfSize(14)
        snumval.textColor = UIColor.blackColor()
        snumval.textAlignment = NSTextAlignment.Center
        EVALView.addSubview(snumval)
        let collable = UILabel(frame: CGRect(x: ScreenWidth/9*7, y: 10, width: ScreenWidth/9, height: 20))
        collable.font = UIFont.systemFontOfSize(14)
        collable.textColor = UIColor.grayColor()
        collable.text = "收藏"
        collable.textAlignment = NSTextAlignment.Center
        EVALView.addSubview(collable)
        colval = UILabel(frame: CGRect(x: ScreenWidth/9*7, y: 35, width: ScreenWidth/9, height: 20))
        colval.font = UIFont.systemFontOfSize(14)
        colval.textColor = UIColor.blackColor()
        colval.textAlignment = NSTextAlignment.Center
        EVALView.addSubview(colval)
        star_1.frame = CGRect(x: 10, y: 60, width: 25, height: 25)
        star_1.image = UIImage(named: "star-empty.png")
        EVALView.addSubview(star_1)
        star_2.frame = CGRect(x: 40, y: 60, width: 25, height: 25)
        star_2.image = UIImage(named: "star-empty.png")
        EVALView.addSubview(star_2)
        star_3.frame = CGRect(x: 70, y: 60, width: 25, height: 25)
        star_3.image = UIImage(named: "star-empty.png")
        EVALView.addSubview(star_3)
        star_4.frame = CGRect(x: 100, y: 60, width: 25, height: 25)
        star_4.image = UIImage(named: "star-empty.png")
        EVALView.addSubview(star_4)
        star_5.frame = CGRect(x: 130, y: 60, width: 25, height: 25)
        star_5.image = UIImage(named: "star-empty.png")
        EVALView.addSubview(star_5)
        evalnum = UILabel(frame: CGRect(x: 160, y: 65, width: 60, height: 20))
        evalnum.font = UIFont.systemFontOfSize(14)
        evalnum.textColor = UIColor.blackColor()
        evalnum.textAlignment = NSTextAlignment.Left
        EVALView.addSubview(evalnum)
        
//        分享按钮入口   del by  liubw
//        let shareimg = UIImageView(frame: CGRect(x: ScreenWidth-70, y: 55, width: 25, height: 25))
//        shareimg.image = UIImage(named: "share.png")
//        shareimg.userInteractionEnabled = true
//        shareimg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showshare"))
//        EVALView.addSubview(shareimg)
        
//        分享显示
//        let sharelable = UILabel(frame: CGRect(x: ScreenWidth-72, y: 80, width: 30, height: 20))
//        sharelable.text = "分享"
//        sharelable.font = UIFont.systemFontOfSize(12)
//        sharelable.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
//        sharelable.textAlignment = NSTextAlignment.Center
//        EVALView.addSubview(sharelable)
        
        favimg = UIImageView(frame: CGRect(x: ScreenWidth-35, y: 55, width: 25, height: 25))
        favimg.image = UIImage(named: "fav.png")
        favimg.tag = 0
        favimg.userInteractionEnabled = true
        favimg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "favgoods:"))
        EVALView.addSubview(favimg)
        let favlable = UILabel(frame: CGRect(x: ScreenWidth-37, y: 80, width: 30, height: 20))
        favlable.text = "收藏"
        favlable.font = UIFont.systemFontOfSize(12)
        favlable.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        favlable.textAlignment = NSTextAlignment.Center
        EVALView.addSubview(favlable)
        /**规格信息区块**/
        let SPECView = UIView(frame: CGRect(x: 0, y: ScreenWidth+228, width: ScreenWidth, height: 40))
        SPECView.backgroundColor = UIColor.whiteColor()
        SPECView.layer.borderWidth = 0.5
        SPECView.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).CGColor
        mainscrollview.addSubview(SPECView)
        let speclable = UILabel(frame: CGRect(x: 10, y: 10, width: 30, height: 20))
        speclable.font = UIFont.systemFontOfSize(14)
        speclable.textColor = UIColor.blackColor()
        speclable.text = "规格"
        speclable.textAlignment = NSTextAlignment.Left
        SPECView.addSubview(speclable)
        let specselectimg = UIImageView(frame: CGRect(x: ScreenWidth-35, y: 8, width: 25, height: 25))
        specselectimg.image = UIImage(named: "tablearrow.png")
        SPECView.addSubview(specselectimg)
        buynumshow = UILabel(frame: CGRect(x: 45, y:10 , width: 35, height: 20))
        buynumshow.font = UIFont.systemFontOfSize(14)
        buynumshow.textColor = UIColor.grayColor()
        buynumshow.textAlignment = NSTextAlignment.Left
        SPECView.addSubview(buynumshow)
        attrinfo = UILabel(frame: CGRect(x: 80, y:10 , width: ScreenWidth-115, height: 20))
        attrinfo.font = UIFont.systemFontOfSize(14)
        attrinfo.textColor = UIColor.blackColor()
        attrinfo.textAlignment = NSTextAlignment.Left
        SPECView.addSubview(attrinfo)
        SPECView.userInteractionEnabled = true
        let SPECViewsingleTap = UITapGestureRecognizer(target: self, action: "gotoattrchoose")
        SPECView.addGestureRecognizer(SPECViewsingleTap)
        /**促销信息区块**/
        let MSView = UIView(frame: CGRect(x: 0, y: ScreenWidth+273, width: ScreenWidth, height: 40))
        MSView.backgroundColor = UIColor.whiteColor()
        MSView.layer.borderWidth = 0.5
        MSView.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).CGColor
        mainscrollview.addSubview(MSView)
        let msimg = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        msimg.image = UIImage(named: "mansong.png")
        MSView.addSubview(msimg)
        mansong = UILabel(frame: CGRect(x: 40, y:10 , width: ScreenWidth-90, height: 20))
        mansong.font = UIFont.systemFontOfSize(14)
        mansong.textColor = UIColor.blackColor()
        mansong.textAlignment = NSTextAlignment.Left
        MSView.addSubview(mansong)
        msselectimg = UIImageView(frame: CGRect(x: ScreenWidth-35, y: 8, width: 25, height: 25))
        msselectimg.image = UIImage(named: "tablearrow.png")
        MSView.addSubview(msselectimg)
        MSView.userInteractionEnabled = true
        let MSViewsingleTap = UITapGestureRecognizer(target: self, action: "gotogoodsms")
        MSView.addGestureRecognizer(MSViewsingleTap)
        let ZPView = UIView(frame: CGRect(x: 0, y: ScreenWidth+313, width: ScreenWidth, height: 40))
        ZPView.backgroundColor = UIColor.whiteColor()
        ZPView.layer.borderWidth = 0.5
        ZPView.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).CGColor
        mainscrollview.addSubview(ZPView)
        let zpimg = UIImageView(frame: CGRect(x: 5, y: 13, width: 30, height: 15))
        zpimg.image = UIImage(named: "zengpin.png")
        ZPView.addSubview(zpimg)
        zengpin = UILabel(frame: CGRect(x: 40, y:10 , width: ScreenWidth-90, height: 20))
        zengpin.font = UIFont.systemFontOfSize(14)
        zengpin.textColor = UIColor.blackColor()
        zengpin.textAlignment = NSTextAlignment.Left
        ZPView.addSubview(zengpin)
        zpselectimg = UIImageView(frame: CGRect(x: ScreenWidth-35, y: 8, width: 25, height: 25))
        zpselectimg.image = UIImage(named: "tablearrow.png")
        ZPView.addSubview(zpselectimg)
        ZPView.userInteractionEnabled = true
        let ZPViewsingleTap = UITapGestureRecognizer(target: self, action: "gotogoodsgift")
        ZPView.addGestureRecognizer(ZPViewsingleTap)
        /**更多信息区块**/
        let InfoH = ScreenWidth+358
        let DetailView = UIView(frame: CGRect(x: 0, y: InfoH, width: ScreenWidth, height: 40))
        DetailView.backgroundColor = UIColor.whiteColor()
        DetailView.layer.borderWidth = 0.5
        DetailView.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).CGColor
        mainscrollview.addSubview(DetailView)
        let dticonimg = UIImageView(frame: CGRect(x: 8, y: 8, width: 25, height: 25))
        dticonimg.image = UIImage(named: "detailicon.png")
        DetailView.addSubview(dticonimg)
        let dtlable = UILabel(frame: CGRect(x: 40, y: 10, width: 80, height: 20))
        dtlable.font = UIFont.systemFontOfSize(14)
        dtlable.textColor = UIColor.blackColor()
        dtlable.text = "图文详情"
        dtlable.textAlignment = NSTextAlignment.Left
        DetailView.addSubview(dtlable)
        let dtselectimg = UIImageView(frame: CGRect(x: ScreenWidth-35, y: 8, width: 25, height: 25))
        dtselectimg.image = UIImage(named: "tablearrow.png")
        DetailView.addSubview(dtselectimg)
        DetailView.userInteractionEnabled = true
        let DetailViewsingleTap = UITapGestureRecognizer(target: self, action: "gotogoodsinfo")
        DetailView.addGestureRecognizer(DetailViewsingleTap)
        
        let ParamView = UIView(frame: CGRect(x: 0, y: InfoH+40, width: ScreenWidth, height: 40))
        ParamView.backgroundColor = UIColor.whiteColor()
        ParamView.layer.borderWidth = 0.5
        ParamView.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).CGColor
        mainscrollview.addSubview(ParamView)
        let pmiconimg = UIImageView(frame: CGRect(x: 8, y: 8, width: 25, height: 25))
        pmiconimg.image = UIImage(named: "attricon.png")
        ParamView.addSubview(pmiconimg)
        let pmlable = UILabel(frame: CGRect(x: 40, y: 10, width: 80, height: 20))
        pmlable.font = UIFont.systemFontOfSize(14)
        pmlable.textColor = UIColor.blackColor()
        pmlable.text = "产品参数"
        pmlable.textAlignment = NSTextAlignment.Left
        ParamView.addSubview(pmlable)
        let pmselectimg = UIImageView(frame: CGRect(x: ScreenWidth-35, y: 8, width: 25, height: 25))
        pmselectimg.image = UIImage(named: "tablearrow.png")
        ParamView.addSubview(pmselectimg)
        ParamView.userInteractionEnabled = true
        let ParamViewsingleTap = UITapGestureRecognizer(target: self, action: "gotogoodsparam")
        ParamView.addGestureRecognizer(ParamViewsingleTap)
        
        let StoreView = UIView(frame: CGRect(x: 0, y: InfoH+80, width: ScreenWidth, height: 40))
        StoreView.backgroundColor = UIColor.whiteColor()
        StoreView.layer.borderWidth = 0.5
        StoreView.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).CGColor
        mainscrollview.addSubview(StoreView)
        StoreView.userInteractionEnabled = true
        let StoreViewsingleTap = UITapGestureRecognizer(target: self, action: "tostore")
        StoreView.addGestureRecognizer(StoreViewsingleTap)
        let sticonimg = UIImageView(frame: CGRect(x: 8, y: 8, width: 25, height: 25))
        sticonimg.image = UIImage(named: "storeicon.png")
        StoreView.addSubview(sticonimg)
        stlable = UILabel(frame: CGRect(x: 40, y: 10, width: ScreenWidth-85, height: 20))
        stlable.font = UIFont.systemFontOfSize(14)
        stlable.textColor = UIColor.blackColor()
        stlable.textAlignment = NSTextAlignment.Left
        StoreView.addSubview(stlable)
        stselectimg = UIImageView(frame: CGRect(x: ScreenWidth-35, y: 8, width: 25, height: 25))
        stselectimg.image = UIImage(named: "tablearrow.png")
        StoreView.addSubview(stselectimg)
        /**猜你喜欢商品展示**/
        let rgcellH = (ScreenWidth-40)/3*1.35
        let RGView = UIView(frame: CGRect(x: 0, y: InfoH+125, width: ScreenWidth, height: rgcellH*2+50))
        RGView.backgroundColor = UIColor.whiteColor()
        RGView.layer.borderWidth = 0.5
        RGView.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).CGColor
        mainscrollview.addSubview(RGView)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake((ScreenWidth-40)/3, rgcellH)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectview = UICollectionView(frame: CGRect(x: 5, y: 30, width: ScreenWidth-10, height: rgcellH*2+20), collectionViewLayout: layout)
        collectview.delegate = self
        collectview.dataSource = self
        collectview.backgroundColor = UIColor.clearColor()
        RGView.addSubview(collectview)
        let reclabel = UILabel(frame: CGRect(x: 10, y: 8, width: 100, height: 20))
        reclabel.text = "猜你喜欢"
        reclabel.textAlignment = NSTextAlignment.Left
        reclabel.font = UIFont.systemFontOfSize(14)
        RGView.addSubview(reclabel)
        /**设置状态栏背景色块**/
        var img = UIImage()
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        smallnavibar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
        smallnavibar.image = img
        self.view.addSubview(smallnavibar)
        /**添加返回按钮**/
        let backbtn = UIButton(frame: CGRect(x: 10, y: 30, width: 40, height: 40))
        let bbimg = UIImage(named: "backbtn.png")
        backbtn.setImage(bbimg, forState: UIControlState.Normal)
        backbtn.addTarget(self, action: "backToList:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backbtn)
        /**底部操作栏**/
        let BBView = UIView(frame: CGRect(x: 0, y: self.view.frame.height-50, width: ScreenWidth, height: 50))
        BBView.backgroundColor = UIColor(red: 229/255, green: 232/255, blue: 238/255, alpha: 1.0)
        self.view.addSubview(BBView)
        var btnx = CGFloat(80)
        var cartx = CGFloat(50)
        if ScreenWidth == 320 {
            btnx = CGFloat(60)
            cartx = CGFloat(45)
        }
        //立即购买按钮
        buynowbtn = UIButton(frame: CGRect(x: 10, y: 5, width: (ScreenWidth-70)/2, height: 40))
        buynowbtn.backgroundColor = UIColor(red: 162/255, green: 101/255, blue: 51/255, alpha: 1.0)
        buynowbtn.layer.cornerRadius = 3
        buynowbtn.addTarget(self, action: "gotobuynow", forControlEvents: UIControlEvents.TouchUpInside)
        buynowbtn.setTitle("立即购买", forState: UIControlState.Normal)
        buynowbtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        buynowbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        BBView.addSubview(buynowbtn)
        //加入购物车按钮
        addcartbtn = UIButton(frame: CGRect(x: 15+(ScreenWidth-70)/2, y: 5, width: (ScreenWidth-70)/2, height: 40))
        addcartbtn.backgroundColor = UIColor(red: 181/255, green: 0/255, blue: 7/255, alpha: 1.0)
        addcartbtn.layer.cornerRadius = 3
        addcartbtn.addTarget(self, action: "addcart", forControlEvents: UIControlEvents.TouchUpInside)
        addcartbtn.setTitle("添加购物车", forState: UIControlState.Normal)
        addcartbtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        addcartbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        BBView.addSubview(addcartbtn)
        //购物车图标
        cartshowbtn = UIImageView(frame: CGRect(x: ScreenWidth-cartx, y: 5, width: 40, height: 40))
        cartshowbtn.image = UIImage(named: "cartshow.png")
        BBView.addSubview(cartshowbtn)
        cartshowbtn.userInteractionEnabled = true
        let cartshowbtnsingleTap = UITapGestureRecognizer(target: self, action: "gotocart")
        cartshowbtn.addGestureRecognizer(cartshowbtnsingleTap)
        //购物车商品数量
        cartnumshow.frame = CGRect(x: 18, y: 5, width: 20, height: 15)
        cartnumshow.backgroundColor = UIColor(red: 181/255, green: 0/255, blue: 7/255, alpha: 1.0)
        cartnumshow.layer.cornerRadius = 5
        cartshowbtn.addSubview(cartnumshow)
        cartnumlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        cartnumlabel.font = UIFont.systemFontOfSize(10)
        cartnumlabel.textColor = UIColor.whiteColor()
        cartnumlabel.textAlignment = NSTextAlignment.Center
        cartnumshow.addSubview(cartnumlabel)
        cartnumshow.hidden = true
        /**加载网络数据**/
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        activity.startAnimating()
        NSThread.detachNewThreadSelector("loadData", toTarget: self, withObject: nil)
        /**添加通知监听**/
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "reloadData:", name: "reloadGoods", object: nil)
        center.addObserver(self, selector: "updatebuynum:", name: "updateNum", object: nil)
        /**添加黑色提示框**/
        tipshow.frame = CGRect(x: (ScreenWidth-150)/2, y: (self.view.frame.height-80)/2, width: 150, height: 80)
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
    }
    
    func backToList(sender: AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
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
    
    /**处理通知回调**/
    func reloadData(sender: NSNotification) {
        let info: AnyObject! = sender.userInfo
        goods_id = info.objectForKey("goods_id") as! String
        buynumshow.text = "x1"
        buynum = 1
        picList = [String]()
        picnum.text = "0/0"
        picallnum = 0
        picview.contentOffset.x = 0
        for sv in picview.subviews {
            if sv.isKindOfClass(NSClassFromString("UIImageView")!) {
                sv.removeFromSuperview()
            }
        }
        finish_load = false
        activity.startAnimating()
        NSThread.detachNewThreadSelector("loadData", toTarget: self, withObject: nil)
    }
    
    func updatebuynum(sender: NSNotification) {
        let info: AnyObject! = sender.userInfo
        let buynumstr = info.objectForKey("buy_num") as! String
        buynumshow.text = "x" + buynumstr
        buynum = Int(buynumstr)!
    }
    
    /**加载网络数据**/
    func loadData() {
        var url_address = API_URL + "index.php?act=goods&op=goods_detail&goods_id=" + goods_id
        if islogin() {
            let key = getkey()
            url_address += "&key=" + key
        }
        let url = NSURL(string: url_address)
        let data = NSData(contentsOfURL: url!)
        if data == nil {
            return
        }
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        if data_array.objectForKey("error") != nil {
            activity.stopAnimating()
            let alert = UIAlertView(title: "提示", message: "网络数据异常", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let goods_info = data_array.objectForKey("goods_info") as! NSDictionary
        //商品图片
        let picimagestr = data_array.objectForKey("goods_image") as! String
        picList = picimagestr.componentsSeparatedByString(",")
        let totalnum = picList.count //轮播图片总数
        picallnum = totalnum
        if picallnum > 0 {
            picnum.text = "1/" + String(picallnum)
        }
        let contentW = CGFloat(totalnum) * ScreenWidth
        picview.contentSize = CGSizeMake(contentW, 0)
        for var i=0;i<totalnum;i++ {
            let imgview = UIImageView()
            let imageX = CGFloat(i) * CGFloat(ScreenWidth)
            imgview.frame = CGRectMake(imageX, 0, ScreenWidth, ScreenWidth)
            imgview.image = UIImage(data: NSData(contentsOfURL: NSURL(string: picList[i])!)!)
            picview.addSubview(imgview)
        }
        goods_image_url = picList[0]
        //商品名称区块
        let name = goods_info.objectForKey("goods_name") as! String
        goodsname.text = name
        goods_name = name
        let jingle: AnyObject! = goods_info.objectForKey("goods_jingle")
        if String(jingle) != "<null>" {
            goodsjingle.text = String(jingle)
        }
        let price = goods_info.objectForKey("goods_price") as! String
        let pmprice = goods_info.objectForKey("goods_promotion_price") as! String
        if pmprice != "" {
            goodsprice.text = "￥" + pmprice
            goods_price = "￥" + pmprice
        } else {
            goodsprice.text = "￥" + price
            goods_price = "￥" + price
        }
        let xvni_flag = goods_info.objectForKey("is_virtual") as! String
        if xvni_flag == "1" {
            xvni.hidden = false
            ifxvni = true
            //隐藏“添加购物车”按钮图标
            addcartbtn.hidden = true
            cartshowbtn.hidden = true
            buynowbtn.frame = CGRect(x: 10, y: 5, width: ScreenWidth-20, height: 40)
        }
        let fma_flag = goods_info.objectForKey("is_fcode") as! String
        if fma_flag == "1" {
            fma.hidden = false
            fcode = true
            //隐藏“添加购物车”按钮图标
            addcartbtn.hidden = true
            cartshowbtn.hidden = true
            buynowbtn.frame = CGRect(x: 10, y: 5, width: ScreenWidth-20, height: 40)
        }
        let yvyue_flag = goods_info.objectForKey("is_appoint") as! String
        if yvyue_flag == "1" { yvyue.hidden = false }
        let yvshou_flag = goods_info.objectForKey("is_presell") as! String
        if yvshou_flag == "1" { yvshou.hidden = false }
        //点评信息区块
        let goods_storage = goods_info.objectForKey("goods_storage") as! String
        stgval.text = goods_storage
        let goods_salenum = goods_info.objectForKey("goods_salenum") as! String
        snumval.text = goods_salenum
        let goods_collect = goods_info.objectForKey("goods_collect") as! String
        colval.text = goods_collect
        let evalnumstr = goods_info.objectForKey("evaluation_count") as! String
        evalnum.text = "(" + evalnumstr + "人)"
        let evalstar_str = goods_info.objectForKey("evaluation_good_star") as! String
        let evalstar = Int(evalstar_str)
        if  evalstar > 0 {
            for var i=1;i<=evalstar;i++ {
                if i == 1 { star_1.image = UIImage(named: "star-full.png") }
                if i == 2 { star_2.image = UIImage(named: "star-full.png") }
                if i == 3 { star_3.image = UIImage(named: "star-full.png") }
                if i == 4 { star_4.image = UIImage(named: "star-full.png") }
                if i == 5 { star_5.image = UIImage(named: "star-full.png") }
            }
        }
        //规格信息
        buynumshow.text = "x" + String(buynum)
        var attrinfostr = " "
        let specname: AnyObject! = goods_info.objectForKey("spec_name")
        let goodsspec: AnyObject! = goods_info.objectForKey("goods_spec")
        var specname_arr = [AnyObject]()
        var goodsspec_arr = [AnyObject]()
        var spec_name = [String:String]()
        if let sn = specname as? NSDictionary {
            specname_arr = Array(sn.allValues)
            for (key,val) in sn {
                let sk = key as! String
                let sv = val as! String
                spec_name[sk] = sv
            }
        }
        choosespec.removeAll(keepCapacity: false)
        if let gs = goodsspec as? NSDictionary {
            goodsspec_arr = Array(gs.allValues)
            for (key,val) in gs {
                let gsk = key as! String
                let gsv = val as! String
                choosespec[gsk] = gsv
            }
        }
        if !specname_arr.isEmpty {
            for (key,val) in specname_arr.enumerate() {
                let name = val as! String
                let value = goodsspec_arr[key] as! String
                attrinfostr += name + ":" + value + " "
            }
        }
        attrinfo.text = attrinfostr
        let speclist: AnyObject! = data_array.objectForKey("spec_list")
        if let sl = speclist as? NSDictionary {
            for (key,val) in sl {
                let slkey = key as! String
                let slval = val as! String
                specgoods[slkey] = slval
            }
        }
        attrList.removeAll(keepCapacity: false)
        let specvalue: AnyObject! = goods_info.objectForKey("spec_value")
        if let sv = specvalue as? NSDictionary {
            for (key,val) in sv {
                let newattr = Attrmodel()
                let sk = key as! String
                newattr.name = spec_name[sk]!
                let nameuilable = UILabel()
                attrlables.append(nameuilable)
                let spec_arr_tmp = val as! NSDictionary
                var spec_arr = [String:String]()
                for (skey,sval) in spec_arr_tmp {
                    let skstr = skey as! String
                    let svstr = sval as! String
                    spec_arr[skstr] = svstr
                    let attrlable = UILabel()
                    attrlables.append(attrlable)
                    let attruiview = UIView()
                    attrview[skstr] = attruiview
                }
                newattr.info = spec_arr
                attrList.append(newattr)
            }
        }
        //促销信息
        let ms_array: AnyObject! = data_array.objectForKey("mansong_info")
        if let ma = ms_array as? NSDictionary {
            let starttime = ma.objectForKey("start_time") as! NSString
            let endtime = ma.objectForKey("end_time") as! NSString
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let starttime_str = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: starttime.doubleValue))
            let endtime_str = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: endtime.doubleValue))
            let msstr = ma.objectForKey("mansong_name") as! String
            mansong.text = msstr
            let rule_array = ma.objectForKey("rules") as! NSArray
            for ra in rule_array {
                let ruleinfo = ra as! NSDictionary
                let newms = Msmodel()
                let price = ruleinfo.objectForKey("price") as! String
                let discount = ruleinfo.objectForKey("discount") as! String
                newms.mansong = "单笔订单满" + price + "元 立减" + discount + "元"
                let imgurl: AnyObject! = ruleinfo.objectForKey("goods_image_url")
                if let iu = imgurl as? String {
                    newms.gift_img_url = iu
                }
                let goodsid: AnyObject! = ruleinfo.objectForKey("goods_id")
                if let gi = goodsid as? Int {
                    newms.gift_goods_id = String(gi)
                }
                newms.limitdata = "活动时间：" + starttime_str + "--" + endtime_str
                msList.append(newms)
            }
        } else {
            mansong.text = "该商品暂无满即送活动"
            mansong.textColor = UIColor.lightGrayColor()
            msselectimg.hidden = true
            msclick = false
        }
        let gift_array: AnyObject! = data_array.objectForKey("gift_array")
        if let ga = gift_array as? NSArray {
            if ga.count > 0 {
                zengpin.text = "查看赠品"
            } else {
                zengpin.text = "该商品暂无赠品"
                zengpin.textColor = UIColor.lightGrayColor()
                zpselectimg.hidden = true
                zpclick = false
            }
            for val in ga {
                let giftinfo = val as! NSDictionary
                let newgift = Giftmodel()
                newgift.goods_id = giftinfo.objectForKey("gift_goodsid") as! String
                newgift.gift_name = giftinfo.objectForKey("gift_goodsname") as! String
                newgift.gift_num = giftinfo.objectForKey("gift_amount") as! String
                giftList.append(newgift)
            }
        }
        //店铺名称
        let storename = data_array.objectForKey("store_info")!.objectForKey("store_name") as! String
        stlable.text = storename
        store_id = data_array.objectForKey("store_info")!.objectForKey("store_id") as! String
        if store_id == "1" {
            stselectimg.hidden = true
        }
        //其他信息
        let mobilebody: AnyObject! = goods_info.objectForKey("mobile_body")
        if let mb = mobilebody as? String {
            mobile_body = mb
        }
        let param_array: AnyObject! = goods_info.objectForKey("goods_attr")
        if let pa = param_array as? NSDictionary {
            for (_,val) in pa {
                let param_child = val as! NSDictionary
                let newgoodsparam = Goodsparammodel()
                for (pk,pv) in param_child {
                    let pkstr = pk as! String
                    if pkstr == "name" {
                        newgoodsparam.title = pv as! String
                    } else {
                        newgoodsparam.value = pv as! String
                    }
                }
                goodsparamList.append(newgoodsparam)
            }
        }
        //猜你喜欢
        recgoods.removeAll(keepCapacity: false)
        let recgoods_array: AnyObject! = data_array.objectForKey("goods_commend_list")
        if let rg = recgoods_array as? NSArray {
            for val in rg {
                let recgoodsinfo = val as! NSDictionary
                let newrecgoods = Goodsmodel()
                newrecgoods.goods_name = recgoodsinfo.objectForKey("goods_name") as! String
                newrecgoods.goods_price = recgoodsinfo.objectForKey("goods_price") as! String
                newrecgoods.goods_id = recgoodsinfo.objectForKey("goods_id") as! String
                newrecgoods.goods_image = recgoodsinfo.objectForKey("goods_image_url") as! String
                recgoods.append(newrecgoods)
            }
            collectview.reloadData()
        }
        //判断是否收藏过该商品
        if data_array.objectForKey("is_favorate") != nil {
            let iffav: AnyObject! = data_array.objectForKey("is_favorate")
            if let ifv = iffav as? Int {
                if ifv == 1 {
                    favimg.image = UIImage(named: "favfull.png")
                    favimg.tag = 1
                }
            }
        }
        //购物车数量
        if data_array.objectForKey("cart_count") != nil {
            let cartnumdata: AnyObject! = data_array.objectForKey("cart_count")
            if let cn = cartnumdata as? Int {
                if cn > 0 {
                    cartnumlabel.text = String(cn)
                    cartnumshow.hidden = false
                }
            }
        }
        //停止加载
        activity.stopAnimating()
        finish_load = true
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let btnlabel = alertView.buttonTitleAtIndex(buttonIndex)
        if alertView.tag != 99 && btnlabel == "确定" {
            self.navigationController?.popViewControllerAnimated(true)
        }
        if btnlabel == "免费下载微信" {
            let wxurl = NSURL(string: "itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8")
            UIApplication.sharedApplication().openURL(wxurl!)
        }
    }
    
    /**设置猜你喜欢商品展示**/
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recgoods.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var nibname = ""
        var cellid = ""
        if ScreenWidth == 320 {
            nibname = "GoodsRecCell"
            cellid = "GoodsRecCellID"
        }
        if ScreenWidth == 375 {
            nibname = "GoodsRecCell375"
            cellid = "GoodsRecCellID375"
        }
        if ScreenWidth == 414 {
            nibname = "GoodsRecCell414"
            cellid = "GoodsRecCellID414"
        }
        var nibregistered = false
        if !nibregistered {
            let nib = UINib(nibName: nibname, bundle: nil)
            collectionView.registerNib(nib, forCellWithReuseIdentifier: cellid)
            nibregistered = true
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellid, forIndexPath: indexPath) as! GoodsRecCell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).CGColor
        cell.price.text = "￥" + recgoods[indexPath.row].goods_price
        cell.goodsname.text = recgoods[indexPath.row].goods_name
        /**图片的延时加载**/
        let cellimgdata: NSArray = [cell, indexPath.row]
        NSThread.detachNewThreadSelector("uploadImageForCellAtIndexPath:", toTarget: self, withObject: cellimgdata)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let gdcontroller = sb.instantiateViewControllerWithIdentifier("GoodsDetailID") as! GoodsDetailViewController
        gdcontroller.goods_id = recgoods[indexPath.row].goods_id
        gdcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gdcontroller, animated: true)
    }
    
    func uploadImageForCellAtIndexPath(cellimgdata: NSArray) {
        let rownum = cellimgdata.objectAtIndex(1) as! Int
        let picurl = recgoods[rownum].goods_image
        if picurl != "" {
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
            let cell = cellimgdata.objectAtIndex(0) as! GoodsRecCell
            cell.picimg.image = img
        }
    }
    
    /**跳转到图文详情**/
    func gotogoodsinfo() {
        if !finish_load {
            return
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let gicontroller = sb.instantiateViewControllerWithIdentifier("GoodsInfoID") as! GoodsInfoViewController
        gicontroller.mobile_body = mobile_body
        gicontroller.goods_id = goods_id
        gicontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gicontroller, animated: true)
    }
    
    /**跳转到产品参数**/
    func gotogoodsparam() {
        if !finish_load {
            return
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let gpcontroller = sb.instantiateViewControllerWithIdentifier("GoodsParamID") as! GoodsParamViewController
        gpcontroller.goodsparamList = goodsparamList
        gpcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gpcontroller, animated: true)
    }
    
    /**跳转到赠品**/
    func gotogoodsgift() {
        if !finish_load {
            return
        }
        if zpclick {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let ggcontroller = sb.instantiateViewControllerWithIdentifier("GoodsGiftID") as! GoodsGiftViewController
            ggcontroller.giftList = giftList
            ggcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(ggcontroller, animated: true)
        }
    }
    
    /**跳转到满即送**/
    func gotogoodsms() {
        if !finish_load {
            return
        }
        if msclick {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let gmscontroller = sb.instantiateViewControllerWithIdentifier("GoodsMSID") as! GoodsMSViewController
            gmscontroller.msList = msList
            gmscontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(gmscontroller, animated: true)
        }
    }
    
    /**跳转到购物车**/
    func gotocart() {
        if !finish_load {
            return
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let cartcontroller = sb.instantiateViewControllerWithIdentifier("CartViewID") as! CartViewController
        cartcontroller.cartbar.frame = CGRect(x: 0, y: cartcontroller.view.frame.height-124, width: ScreenWidth, height: 60)
        self.navigationController?.pushViewController(cartcontroller, animated: true)
    }
    
    /**跳转到选择样式**/
    func gotoattrchoose() {
        if !finish_load {
            return
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let gattrcontroller = sb.instantiateViewControllerWithIdentifier("GoodsAttrID") as! GoodsAttrViewController
        gattrcontroller.goods_name = goods_name
        gattrcontroller.goods_image_url = goods_image_url
        gattrcontroller.price = goods_price
        gattrcontroller.attrList = attrList
        gattrcontroller.specgoods = specgoods
        gattrcontroller.navititle = "选择样式"
        gattrcontroller.mode = "attrchoose"
        gattrcontroller.attrlables = attrlables
        gattrcontroller.attrview = attrview
        gattrcontroller.stock.text = "库存：" + stgval.text! + "件"
        gattrcontroller.stocknum = Int(stgval.text!)!
        gattrcontroller.choosespec = choosespec
        gattrcontroller.goods_id = goods_id
        gattrcontroller.buynum = buynum
        gattrcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gattrcontroller, animated: true)
    }
    
    /**跳转到立即购买**/
    func gotobuynow() {
        if !finish_load {
            return
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let gattrcontroller = sb.instantiateViewControllerWithIdentifier("GoodsAttrID") as! GoodsAttrViewController
        gattrcontroller.goods_name = goods_name
        gattrcontroller.goods_image_url = goods_image_url
        gattrcontroller.price = goods_price
        gattrcontroller.attrList = attrList
        gattrcontroller.specgoods = specgoods
        gattrcontroller.navititle = "立即购买"
        gattrcontroller.mode = "buynow"
        gattrcontroller.attrlables = attrlables
        gattrcontroller.attrview = attrview
        gattrcontroller.stock.text = "库存：" + stgval.text! + "件"
        gattrcontroller.stocknum = Int(stgval.text!)!
        gattrcontroller.choosespec = choosespec
        gattrcontroller.goods_id = goods_id
        gattrcontroller.buynum = buynum
        gattrcontroller.fcode = fcode
        gattrcontroller.xvni = ifxvni
        gattrcontroller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(gattrcontroller, animated: true)
    }
    
    /**收藏商品**/
    func favgoods(recognizer: UITapGestureRecognizer) {
        if !finish_load {
            return
        }
        if !islogin() {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let logincontroller = sb.instantiateViewControllerWithIdentifier("LoginViewID") as! LoginViewController
            logincontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(logincontroller, animated: true)
        } else {
            let key = getkey()
            if recognizer.view!.tag == 0 {
                let paramstr = NSString(format: "goods_id=%@&key=%@", goods_id, key)
                let paramstrlen = paramstr.length
                let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                let request = NSMutableURLRequest()
                request.URL = NSURL(string: API_URL + "index.php?act=member_favorites&op=favorites_add")
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
                        favimg.image = UIImage(named: "favfull.png")
                        favimg.tag = 1
                        tipstr.text = "添加收藏成功"
                        tipimg.image = UIImage(named: "success.png")
                        tipshow.hidden = false
                    }
                } else {
                    tipstr.text = "添加收藏失败"
                    tipimg.image = UIImage(named: "error.png")
                    tipshow.hidden = false
                }
            } else {
                let paramstr = NSString(format: "fav_id=%@&key=%@", goods_id, key)
                let paramstrlen = paramstr.length
                let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                let request = NSMutableURLRequest()
                request.URL = NSURL(string: API_URL + "index.php?act=member_favorites&op=favorites_del")
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
                        favimg.image = UIImage(named: "fav.png")
                        favimg.tag = 0
                        fav_id = ""
                        tipstr.text = "删除收藏成功"
                        tipimg.image = UIImage(named: "success.png")
                        tipshow.hidden = false
                    }
                } else {
                    tipstr.text = "删除收藏失败"
                    tipimg.image = UIImage(named: "error.png")
                    tipshow.hidden = false
                }
            }
            //延时关闭提示框
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
        }
    }
    
    //隐藏黑色提示框
    func hidetip() {
        tipshow.hidden = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if finish_load && scrollView.tag == 99 {
            let page = picview.contentOffset.x / picview.frame.width
            picnum.text = String(Int(page)+1) + "/" + String(picallnum)
        }
    }
    

    
    /**添加购物车**/
    func addcart() {
        if !finish_load {
            return
        }
        if !islogin() {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let logincontroller = sb.instantiateViewControllerWithIdentifier("LoginViewID") as! LoginViewController
            logincontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(logincontroller, animated: true)
        } else {
            activity.startAnimating()
            let key = getkey()
            let paramstr = NSString(format: "goods_id=%@&quantity=%d&key=%@", goods_id, buynum, key)
            let paramstrlen = paramstr.length
            let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: API_URL + "index.php?act=member_cart&op=cart_add")
            request.HTTPMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postdata
            let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            
            let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! String
           
            if data_array == "1" {
                tipstr.text = "成功加入购物车"
                tipimg.image = UIImage(named: "success.png")
                tipshow.hidden = false
            } else {
                tipstr.text = "加入购物车失败"
                tipimg.image = UIImage(named: "error.png")
                tipshow.hidden = false
            }
            //获取购物车商品数量
            let cartnum = 1// liubwtest getcartgoodsnum()
            if cartnum > 0 {
                cartnumlabel.text = String(cartnum)
                cartnumshow.hidden = false
            }
            activity.stopAnimating()
            //延时关闭提示框
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "hidetip", userInfo: nil, repeats: false)
        }
    }
    
    /**获取最新购物车商品数**/
    func getcartgoodsnum() -> Int {
        var num = 0
        let key = getkey()
        let paramstr = NSString(format: "key=%@", key)
        let paramstrlen = paramstr.length
        let postdata = paramstr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let request = NSMutableURLRequest()
        
//        http://www.htyyao.com/mobile/index.php?act=member_cart&op=cart_list
        request.URL = NSURL(string: API_URL + "index.php?act=member_cart&op=cart_list")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramstrlen), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postdata
        let respdata = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
    
        //liubw
//        if respdata == nil {
//            activity.stopAnimating()
//            let alert = UIAlertView(title: "提示", message: "当前没有网络连接", delegate: self, cancelButtonTitle: "确定")
//            alert.show()
//            return num
//        }
        
        let data_array = (try! NSJSONSerialization.JSONObjectWithData(respdata!, options: NSJSONReadingOptions.AllowFragments)).objectForKey("datas") as! NSDictionary
        let cart_list: AnyObject! = data_array.objectForKey("cart_list")
        if let cl = cart_list as? NSArray {
            num = cl.count
        }
        return num
    }
    
    /**店铺主页**/
    func tostore() {
        if !finish_load {
            return
        }
        if store_id != "1" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let sdcontroller = sb.instantiateViewControllerWithIdentifier("StoreDetailViewID") as! StoreDetailViewController
            sdcontroller.store_id = store_id
            sdcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sdcontroller, animated: true)
        }
    }
    
    /**社交网络分享**/
    func showshare() {
        if !finish_load {
            return
        }
        let sharesheet = UIActionSheet(title: "分享到", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "新浪微博", "微信好友", "微信朋友圈", "微信收藏")
        sharesheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        //新浪微博
        if buttonIndex == 1 {
            sendwb()
        }
        //微信好友
        if buttonIndex == 2 {
            sendwx(0)
        }
        //微信朋友圈
        if buttonIndex == 3 {
            sendwx(1)
        }
        //微信收藏
        if buttonIndex == 4 {
            sendwx(2)
        }
    }
    
    //获取商品URL地址
    func getgoodsurl() -> String {
        return WAP_URL != "" ? WAP_URL + "tmpl/product_detail.html?goods_id=" + goods_id : SHOP_URL + "index.php?act=goods&op=index&goods_id=" + goods_id
    }
    
    //微信分享
    func sendwx(type: Int32) {
        if WXApi.isWXAppInstalled() && WXApi.isWXAppSupportApi() {
            let message = WXMediaMessage()
            message.title = goodsname.text
            message.description = goodsjingle.text
            message.setThumbImage(UIImage(data: NSData(contentsOfURL: NSURL(string: picList[0])!)!))
            let webpage = WXWebpageObject()
            webpage.webpageUrl = getgoodsurl()
            message.mediaObject = webpage
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = type
            WXApi.sendReq(req)
        } else {
            let alert = UIAlertView(title: "提示", message: "您的iPhone上还没有安装微信客户端", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "免费下载微信")
            alert.show()
        }
    }
    
    //新浪微博分享
    func sendwb() {
        let message = WBMessageObject()
        message.text = goodsname.text! + getgoodsurl()
        let image = WBImageObject()
        image.imageData = NSData(contentsOfURL: NSURL(string: picList[0])!)
        message.imageObject = image
        let req = WBSendMessageToWeiboRequest.requestWithMessage(message) as! WBSendMessageToWeiboRequest
        WeiboSDK.sendRequest(req)
    }
}