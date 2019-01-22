//
//  SecretLetterViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/5/11.
//  Copyright © 2017年 weipo. All rights reserved.
//  密信片

import UIKit
import MapKit
import SVProgressHUD

class SecretLetterViewController: UIViewController {

    /** 是否返回首页 */
    var needPodHoom: Bool!
    /** 密信数据模型 */
    var messageInfoModel: SWMessageInfoModel?
    /** 用户定位 */
    var userCenter: CLLocationCoordinate2D? 
    
    
    @IBOutlet weak var readSecretWhisperButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    /** 用户头像 */
    @IBOutlet var userImage: UIImageView!
    /** 用户名 */
    @IBOutlet weak var nickNameMark: UILabel!
    /** 可读次数 */
    @IBOutlet weak var readCountMark: UILabel!
    /** 创建时间 */
    @IBOutlet var createTimeLabel: UILabel!
    /** 撕开效果图 */
    @IBOutlet weak var tearPaperImageView: UIImageView!
    /** 可读时间 */
    @IBOutlet weak var whisperReadTimeLabel: UILabel!
    /** 地址 */
    @IBOutlet weak var whisperReadLocationLabel: UILabel!
    /** 标题 */
    @IBOutlet weak var whisperTitleLabel: UILabel!
   
    @IBOutlet weak var userQrView: UIView!
     /** 密信二维码 */
    @IBOutlet var userQrImage: UIImageView!
    @IBOutlet weak var readRecordingLabel: UILabel!
    @IBOutlet weak var readSecretMessageLabel: UILabel!
    /** 签名 */
    @IBOutlet weak var signatureBgImage: UIImageView!
    /** 最近阅读记录 */
    @IBOutlet var resentCollection: UICollectionView!
    /** 阅读次数 */
    @IBOutlet var readCountLab: UILabel!
    //附件数组
    var resentDatas:Array<Dictionary<String,Any>> = []
    //初始化viewController
    class func initViewController() -> SecretLetterViewController {
        return UIStoryboard.init(name: "ReadMessage", bundle: nil).instantiateViewController(withIdentifier: "SecretLetterViewController") as! SecretLetterViewController
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //读取私语
        readSecretMessageLabel.layer.borderColor = UIColor.white.cgColor
        readSecretMessageLabel.layer.borderWidth = 1.0
        readSecretMessageLabel.layer.cornerRadius = 2.5
  
        // 头像
        userImage.layer.cornerRadius = 51 * KScaleW / 2
        userImage.layer.borderWidth = 1.5
        userImage.layer.borderColor = UIColor.lightGray.cgColor
        userImage.clipsToBounds = true
        
        // 签名
        signatureBgImage.layer.cornerRadius = 46 * KScaleW / 2
        signatureBgImage.clipsToBounds = true
        let mainViewH = KScreenWidth*70/75
        let bgTitleFrame = CGRect(x: 0 , y: 0, width: mainViewH, height: mainViewH)
        let bgTitle = CoreTextArcView(frame: bgTitleFrame, font: UIFont.systemFont(ofSize: 14.0), text: "情景密信片", radius: Float(mainViewH - 60), arcSize: 15.0, color: UIColor.color(with: "#847c6d"))
    
        mainView.addSubview(bgTitle!)
        
        
        guard let currentCoordinate = HSLocationManager.sharedInstance.currentLocation?.coordinate else {
            return
        }
        
        let locationDegress = currentCoordinate.NorthOrSouth() + ":" + currentCoordinate.latitudeString() + "    " + currentCoordinate.EastOrWest() + ":" + currentCoordinate.longitudeString()
      
        let locationDegressView = CoreTextArcView(frame: bgTitleFrame, font: UIFont.systemFont(ofSize: 8.0), text: locationDegress.Reverse(), radius: Float(-mainViewH + 45), arcSize: 30.0, color: UIColor.color(with: "#847c6d"))
        locationDegressView?.backgroundColor = UIColor.clear
        mainView.addSubview(locationDegressView!)
        
        requstData()
    }


    //MARK:请求数据
    func requstData() {
        /**
         messageId://,信息 Id Long
         lng 用户所在位置经度 String
         lat 用户所在位置纬度 String
         **/
        guard let userCoordinate = userCenter else {
            let alert = UIAlertController.init(title: "未获得位置信息", message: "请在iPhone的“设置-隐私-定位服务”中打开", preferredStyle: .alert)
            let alertAction = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
            alert .addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let lng = NSString(format: "%lf", userCoordinate.longitude)
        let lat = NSString(format: "%lf", userCoordinate.latitude)
        
        let parameters = ["messageId":messageInfoModel?.messageId as Any,
                          "lng":lng,
                          "lat":lat,
                          ] as [String:Any]
        
        SWRequestManager.queryMessageCard(parameters) {[weak self] (result, error) in
            guard let strongSelf = self else { return }
            strongSelf.queryMessageCardHandler(result, error: error)
        }
        
    }
    //查询密信片信息请求结果处理
    func queryMessageCardHandler(_ result: HSSuccessResponse?, error: HSErrorResponse?) {
        
        if error != nil {
            print("discovery Message error: \(String(describing: error?.errorMessage))")
        } else {
            let data: Dictionary<String, Any> = result?.data as! Dictionary<String, Any>
            messageCardeModel = SWMessageInfoModel().queryMessageCard(data)
        }
    }
    private var messageCardeModel: SWMessageInfoModel! {
        didSet {
            /** 用户头像 */
            userImage.sd_setImage(with: URL(string: (SWUrlHeader + messageCardeModel.userPhoto)), placeholderImage: UIImage(named: "秘信列表红头像"))
            /** 用户名 */
            nickNameMark.text = messageCardeModel?.userNickName
            /** 可读次数 */
            if messageCardeModel.messageReadTimes == -1 {
                readCountMark.text = "可读:无限次"
            } else {
                readCountMark.text = "可读:" + "\(messageCardeModel.messageReadTimes)" + "次"
            }
            /** 创建时间 */
            createTimeLabel.text = "\(messageCardeModel.messageAddTime)"
            
            /** 可读时间 */
            whisperReadTimeLabel.text = "可读时间:" + messageCardeModel.messageReadStartMonth + "月" + "-" + messageCardeModel.messageReadEndMonth + "月" + "->" + messageCardeModel.messageReadStartDay + "日" + "-" + messageCardeModel.messageReadEndDay + "日" + "->" + messageCardeModel.messageReadStartTime + "时" + "-" + messageCardeModel.messageReadEndTime + "时"
            
            /** 地址 */
            whisperReadLocationLabel.text = "可读空间:" + messageCardeModel.areaName + "-" + messageCardeModel.placeName
            
            /** 标题 */
            whisperTitleLabel.text = messageCardeModel.messageTitle
            /** 密信二维码 */
            userQrImage.sd_setImage(with: URL(string: (SWUrlHeader + messageCardeModel.messageQrCodeUrl)), placeholderImage: UIImage(named: ""))
            
            /** 签名 */
            signatureBgImage.sd_setImage(with: URL(string: (SWUrlHeader + messageCardeModel.userSignatureUrl)), placeholderImage: UIImage(named: ""))
            
            if messageCardeModel.messageReadTimes == -1 {
                readCountLab.text = "剩余:" + "\(messageCardeModel.messageReadedTimes)" + "/" + "∞"
            } else {
                readCountLab.text = "剩余:" + "\(messageCardeModel.messageReadedTimes)" + "/" + "\(messageCardeModel.messageReadTimes)"
            }
            // 最近
            resentDatas = (messageCardeModel.messageReadUsers as NSArray) as! Array<Dictionary<String, Any>>
            self.resentCollection.reloadData()
        }
    }
    //页面返回事件处理
    @IBAction func getbackButtonClicked(_ sender: Any) {
        if needPodHoom {
            navigationController?.popToRootViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //阅读密信片按钮事件处理
    @IBAction func readSecretWhisperButtonClicked(_ sender: Any) {
        
        let viewController = ReadMessageViewController.initViewController()
        viewController.messageID = messageInfoModel?.messageId
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    //下载按钮事件处理
    @IBAction func downloadButtonClicked(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(mainView.frame.size, false, UIScreen.main.scale)
        mainView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let shareimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(shareimage!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    //保存相册完成相关的方法
    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil {
            let alert = UIAlertController.init(title: "为获得照片授权", message: "请在iPhone的“设置-隐私-照片”中打开", preferredStyle: .alert)
            let alertAction = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
            alert .addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            SVProgressHUD.showSuccess(withStatus: "密信片保存成功")
        }
        
    }
    //分享按钮事件处理
    @IBAction func shareButtonClicked(_ sender: Any) {
        
        UIGraphicsBeginImageContextWithOptions(mainView.frame.size, false, UIScreen.main.scale)
        mainView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let shareimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UMSocialUIManager.setPreDefinePlatforms([NSNumber(integerLiteral:UMSocialPlatformType.wechatSession.rawValue), NSNumber(integerLiteral:UMSocialPlatformType.wechatTimeLine.rawValue), NSNumber(integerLiteral:UMSocialPlatformType.QQ.rawValue), NSNumber(integerLiteral:UMSocialPlatformType.sina.rawValue)])
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, userInfo) in
            
            //            print("platformType: \(platformType.rawValue), userInfo: \(userInfo)")
            // 判断是否安装第三软件
            
            if UMSocialManager.default().isInstall(platformType) {
                self.shareImageToPlatformType(platformType, title: "", descr: "", thumbImage:UIImage.init(named: "gywmLOGO")! , shareImage: shareimage!)
            } else {
                SVProgressHUD.showError(withStatus: "请先安装相关App")
            }
            
        }
        
    }
    
    //更多读者按钮事件处理
    @IBAction func moreReaderButtonClicked(_ sender: Any) {
        
        
    }
    
    
    //分享文本
    func shareTextToPlatformType(_ platformType: UMSocialPlatformType, text: String) {
        
        let messageObject = UMSocialMessageObject()
        messageObject.text = text
        
        UMSocialSwiftInterface.share(plattype: platformType, messageObject: messageObject, viewController: self) { (data, error) in
            
        }
        
    }
    
    //分享图片
    func shareImageToPlatformType(_ platformType: UMSocialPlatformType, title: String, descr: String, thumbImage: UIImage, shareImage: UIImage) {
        
        let messageObject = UMSocialMessageObject()
        
        let shareObject = UMShareImageObject()
        shareObject.thumbImage = thumbImage
        shareObject.shareImage = shareImage
        messageObject.shareObject = shareObject
        
        UMSocialSwiftInterface.share(plattype: platformType, messageObject: messageObject, viewController: self) { (data, error) in
            
        }

        
    }
    
    //分享图片和文字
    func shareImageAndTextToPlatformType(_ platformType: UMSocialPlatformType, title: String, descr: String, thumbImage: UIImage, shareImage: UIImage) {
        
        let messageObject = UMSocialMessageObject()
        
        let shareObject = UMShareImageObject.shareObject(withTitle: title, descr: descr, thumImage: thumbImage)
        shareObject?.shareImage = shareImage
        messageObject.shareObject = shareObject
        
        UMSocialSwiftInterface.share(plattype: platformType, messageObject: messageObject, viewController: self) { (data, error) in
            
        }
    }
    
}
//MARK: UICollectionView-数据源
extension SecretLetterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resentDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resentReadCell", for: indexPath as IndexPath) as! SWResentReadCell
        cell.readerInfo = resentDatas[indexPath.row]
        return cell;
    }
}
