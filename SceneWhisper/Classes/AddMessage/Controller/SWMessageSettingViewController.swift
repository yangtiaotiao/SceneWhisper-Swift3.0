//
//  SWMessageSettingViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/6/13.
//  Copyright © 2017年 weipo. All rights reserved.
//  发布密信，密信设置

import UIKit
import MapKit
import Alamofire
import SVProgressHUD
import IQKeyboardManagerSwift

class SWMessageSettingViewController: UIViewController {
    
    // 图片数据
    var photoDataArray: NSArray?
    // 视频数据
    var videoUrl: NSURL!
    //附件类型（图片/视频）
    var attachmentTypeId:Int!
    
    @IBOutlet weak var msMoreSetView: UIView! //更多设置的view
    @IBOutlet weak var msReadTimeView: UIView! //阅读时间设置的view
    @IBOutlet weak var msDistanceView: UIView! //范围设置的view
    @IBOutlet weak var msMessageView: UIView! //密信片的view
    @IBOutlet weak var msMapView: MKMapView! //地图view
    @IBOutlet weak var timeSettingButton: UIButton! //时间设置按钮
    @IBOutlet weak var textEditButton: UIButton! //文本信息编辑按钮
    @IBOutlet weak var doneLabel: UILabel! //完成按钮
    @IBOutlet weak var locationButton: UIButton! //定位按钮
    @IBOutlet weak var moreSettingButton: UIButton! //更多设置按钮
    @IBOutlet weak var bigBGView: UIImageView! //大背景按钮
    @IBOutlet weak var distanceLabel: UILabel! //范围Label
    @IBOutlet weak var wordCountLabel: UILabel! //字数Label
    @IBOutlet weak var messageTitle: UITextField! //消息标题textField
    @IBOutlet weak var messageTextView: UITextView! //消息内容textView
    @IBOutlet weak var secretKeyTipsLabel: UILabel! //密信片秘钥Label
    @IBOutlet weak var timePickButton: UIButton! //时间选择按钮
    @IBOutlet weak var timeResetButton: UIButton! //时间重置按钮
    @IBOutlet weak var monthRangeView: SWDateRangeView! //日期-月选择器
    @IBOutlet weak var dayRangeView: SWDateRangeView! //日期-日选择器
    @IBOutlet weak var hourRangeView: SWDateRangeView! //时间-时选择器
    @IBOutlet weak var timesPickerView: SWPickerView! //阅读次数选择器
    @IBOutlet weak var messageReadTimesLabel: UILabel!  //密信阅读次数Label
    @IBOutlet weak var datePickerView: SWCustomDatePickerView! //密信阅读日期的view
    @IBOutlet var secretFlagLabel: UILabel!
    
    var userCenter: CLLocationCoordinate2D? //用户定位
    var timeStyle: Int = 0 //时间的类型
    // 可读次数
    var readeablTimes:Int = -1
    // 可读次数
    var secretFlag:Int = -1
    // 开始月
    var startMonth:String = "01"
    // 结束月
    var endMonth:String = "12"
    // 开始日
    var startDay:String = "01"
    // 结束日
    var endDay:String = "31"
    // 开始时
    var startHour:String = "01"
    // 结束时
    var endHour:String = "24"
    
    private var province:String = "" //，省份 String
    private var city:String = ""  //,城市 String
    private var district:String = "" //,区，县 String
    private var town:String = "" //镇、街道 String
    private var placeName:String = "" //地点名称 String
    private var duration:Int?
    //密信片显示的范围
    lazy var regionSlider: SWCustomSliderView = {
       return self.createRegionSliderView()
    }()
    
    //初始化viewController
    class func initViewController() -> SWMessageSettingViewController {
        return UIStoryboard.init(name: "AddMessage", bundle: nil).instantiateViewController(withIdentifier: "SWMessageSettingViewController") as! SWMessageSettingViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置完成按钮
        doneLabel.layer.borderColor = UIColor.white.cgColor
        doneLabel.layer.borderWidth = 1.0
        doneLabel.layer.cornerRadius = 2.5
        
        //添加范围设置控件
        self.view.addSubview(self.regionSlider)
        self.regionSlider.delegate = self
        
        //设置地图
        msMapView.layer.cornerRadius = 290.0 * KScaleW / 2.0
        msMapView.delegate = self
//        msMapView.showsUserLocation = true
        msMapView.userTrackingMode = .follow
        msMapView.isUserInteractionEnabled = false
        
        //设置默认范围1000
        resetDistance("1000 m")
        
        //设置密信需要设置的信息，0:标题和内容，1:时间 2:范围 3:更多
        resetSubViews(0)
        
        //设置密信的秘钥Label
        secretKeyTipsLabel.backgroundColor = UIColor.color(with: "#f7f1d8")
        secretKeyTipsLabel.layer.masksToBounds = true
        secretKeyTipsLabel.layer.cornerRadius = secretKeyTipsLabel.frame.height / 2.0
        secretKeyTipsLabel.layer.borderWidth = 0.5
        secretKeyTipsLabel.layer.borderColor = UIColor.color(with: "#dadeae").cgColor
        
        //密信的秘钥开关
        let skeySwitch = SWSecretKeySwitch(frame: CGRect(x: 290.0 * KScaleW / 2.0 - 2 * KScaleW , y: 290.0 * KScaleW / 2.0 + 75  * KScaleW, width: 50.0, height: 26.0))
        skeySwitch.style = .NoBorder
        skeySwitch.onTintColor = UIColor.color(with: "#cec5a3")
        skeySwitch.offTintColor = UIColor(white: 0.9, alpha: 0.8)
        skeySwitch.thumbTintColor = UIColor.color(with: "#e8e8e8")
        skeySwitch.addTarget(self, action: #selector(handleSecrectKeySwitchEvent(_:)), for: .valueChanged)
        skeySwitch.setKnobImage(UIImage(named: "3锁")!)
        msMoreSetView.addSubview(skeySwitch)
        
        //设置时间重置按钮
        timeResetButton.layer.borderColor = UIColor.color(with: "b4a86a").cgColor
        timeResetButton.layer.borderWidth = 1.0
        timeResetButton.layer.cornerRadius = 2.5
        
        //设置次数选择器
        timesPickerView.delegate = self
        timesPickerView.loadData(0)
        messageReadTimesLabel.text = "可读次数：无限次"
        
        //为日期选择器的delegate赋值
        datePickerView.delegate = self
        datePickerView.reloadData(0)
        datePickerView.loadData(0, upper: Int(startMonth)! - 1, floor: Int(endMonth)! - 1)
        
        setupTextViewPlaceholder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置日期时间选择器的范围
        monthRangeView.loadData("01", bottom: "12", unit: "月")
        dayRangeView.loadData("01", bottom: "31", unit: "日")
        hourRangeView.loadData("00", bottom: "24", unit: "时")
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    
    //页面返回事件处理
    @IBAction func getbackButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //地址编译
    func reverseGeocode(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
   
            self.province = placemark.addressDictionary!["State"] as! String //，省份 String
            self.city = placemark.addressDictionary!["City"] as! String//,城市 String
            self.district = placemark.addressDictionary?["SubLocality"] as! String //,区，县 String
            self.town = placemark.addressDictionary?["Thoroughfare"] as! String //镇、街道 String
            self.placeName = placemark.addressDictionary?["Name"] as! String//地点名称 String
        }
    }
 
    
    //MARK: 完成按钮事件处理
    @IBAction func doneButtonClicked(_ sender: Any) {
        view.endEditing(true)
        if messageTitle.text?.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入标题")
            return
        }
        if messageTextView.text?.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入文字内容")
            return
        }
    
        let parameters = [
            "title":messageTitle.text!,//信息标题 String
            "content":messageTextView.text!,//,信息文字内容 String
            "keyId":secretFlag,//,密钥 -1--关闭 0-开启 Int
            "scope":Int(regionSlider.currentValue!*1000),//,模糊范围 Int (以米为单位)
            "readStartMonth":startMonth,//可阅读开始月份 String
            "readEndMonth":endMonth,//可阅读结束月份 String
            "readStartDay":startDay,//可阅读开始日期 String
            "readEndDay":endDay,//可阅读结束日期 String
            "readStartTime":startHour,//,可阅读开始时间 String
            "readEndTime" :endHour,//,可阅读结束时间 String
            "readTimes" :readeablTimes,//,阅读次数 Int -1-无数次
          
            ] as [String:Any]
        

        let model = SWMessageInfoModel().addMessage(parameters)
        
        let msgSetVC = SWMsgSettingResultViewController.initViewController()
        msgSetVC.model = model
        self.modalPresentationStyle = UIModalPresentationStyle.currentContext
        msgSetVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        msgSetVC.delegate = self

        self.present(msgSetVC, animated: true, completion: nil)

    }
   
    func addMessageRequest() {
        if self.videoUrl != nil {
            attachmentTypeId = 2
            let pathString = videoUrl.path
          
            let outpath = NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).mp4"
            //视频转码
            self.transformMoive(inputPath: pathString!, outputPath: outpath)
        } else {
            attachmentTypeId = 1
            self.uploadImage()
        }
       
    }
    
    /// 转换视频
    ///
    /// - Parameters:
    ///   - inputPath: 输入url
    ///   - outputPath:输出url
    func transformMoive(inputPath:String,outputPath:String){
        
        let avAsset:AVURLAsset = AVURLAsset(url: URL.init(fileURLWithPath: inputPath), options: nil)
        let assetTime = avAsset.duration
        
        duration = Int(CMTimeGetSeconds(assetTime))
        print("视频时长 \(String(describing: duration))");
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: avAsset)
        if compatiblePresets.contains(AVAssetExportPresetLowQuality) {
            let exportSession:AVAssetExportSession = AVAssetExportSession.init(asset: avAsset, presetName: AVAssetExportPresetMediumQuality)!
            let existBool = FileManager.default.fileExists(atPath: outputPath)
            if existBool {
            }
            exportSession.outputURL = URL.init(fileURLWithPath: outputPath)
        
            exportSession.outputFileType = AVFileTypeMPEG4
            exportSession.shouldOptimizeForNetworkUse = true;
            exportSession.exportAsynchronously(completionHandler: {
                
                switch exportSession.status{
                    
                case .failed:
                    break
                case .cancelled:
                    print("取消")
                    break;
                case .completed:
                    let mp4Path = URL.init(fileURLWithPath: outputPath)
                    DispatchQueue.main.async(execute: {
                         self.uploadVideo(mp4Path: mp4Path)
                    })
                   
                    break;
                default:
                    print("..")
                    break;
                }
            })
        }
    }
    
    //MARK:发布图片密信请求
    func uploadImage() {
        guard let userCoordinate = userCenter else {
//            SVProgressHUD.showError(withStatus: "获取位置信息失败")
            let alert = UIAlertController.init(title: "未获得位置信息，无法使用发布功能", message: "请在iPhone的“设置-隐私-定位服务”中打开", preferredStyle: .alert)
            let alertAction = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
            alert .addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let lng = NSString(format: "%lf", userCoordinate.longitude)
        let lat = NSString(format: "%lf", userCoordinate.latitude)
      
        let parameters = [
            "province":province, //，省份 String
            "city":city,//,城市 String
            "district":district,//,区，县 String
            "town":town,//镇、街道 String
            "placeName":placeName,//地点名称 String
            "lng":lng,
            "lat":lat,
            "userId":SWDataManager.currentUserId(),//,用户 Id Long
            "title":messageTitle.text!,//信息标题 String
            "content":messageTextView.text!,//,信息文字内容 String
            "keyId":secretFlag,//,密钥 -1--关闭 0-开启 Int
            "scope":Int(regionSlider.currentValue!*1000),//,模糊范围 Int (以米为单位)
            "readStartMonth":startMonth,//可阅读开始月份 String
            "readEndMonth":endMonth,//可阅读结束月份 String
            "readStartDay":startDay,//可阅读开始日期 String
            "readEndDay":endDay,//可阅读结束日期 String
            "readStartTime":startHour,//,可阅读开始时间 String
            "readEndTime" :endHour,//,可阅读结束时间 String
            "readTimes" :readeablTimes,//,阅读次数 Int -1-无数次
            "attachmentTypeId":attachmentTypeId!,//,附件类型 1-图片 2-视频 Int
            "attachmentLength":1,//长度，如果是视频，填写视频的长度，单 位为秒 Int
            ] as [String:Any]
        
        let urlString = SWUrlHeader + "m/m/addNewMessage"
        let headers = ["content-type":"multipart/form-data"]
        SVProgressHUD.show()
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in parameters {
                    let valueStr = "\(value)"
                    multipartFormData.append(valueStr.data(using: String.Encoding.utf8)!, withName: key)
                }
                //多张图片上传
                for i in 0..<self.photoDataArray!.count {
                    multipartFormData.append(self.photoDataArray![i] as! Data, withName: "\(i).png", fileName: "\(i).png", mimeType: "image/jpg/png/jpeg")
                }
        },
            to: urlString,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    //连接服务器成功后，对json的处理
                    upload.responseJSON { response in
                        SVProgressHUD.dismiss()
                        //解包
                        let handler = HSResponseHandler.handle(response: response)
                        if handler.error == nil {
                            self.addNewMessageHandler(handler.data)
                        } else {
                            SVProgressHUD.showError(withStatus: handler.error?.errorMessage)
                        }
                    }
//                    //获取上传进度
//                    upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                        print("图片上传进度: \(progress.fractionCompleted)")
//                    }
                case .failure(let encodingError):
                    //失败原因
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: encodingError as? String)
                }
        })
        
    }
    //MARK:发布视频密信请求
    func uploadVideo(mp4Path : URL) {
 
        guard let userCoordinate = userCenter else {
//            SVProgressHUD.showError(withStatus: "获取位置信息失败")
            let alert = UIAlertController.init(title: "未获得位置信息", message: "请在iPhone的“设置-隐私-定位服务”中打开", preferredStyle: .alert)
            let alertAction = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
            alert .addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let lng = NSString(format: "%lf", userCoordinate.longitude)
        let lat = NSString(format: "%lf", userCoordinate.latitude)
        
        let parameters = [
            "province":province, //，省份 String
            "city":city,//,城市 String
            "district":district,//,区，县 String
            "town":town,//镇、街道 String
            "placeName":placeName,//地点名称 String
            "lng":lng,
            "lat":lat,
            "userId":SWDataManager.currentUserId(),//,用户 Id Long
            "title":messageTitle.text!,//信息标题 String
            "content":messageTextView.text!,//,信息文字内容 String
            "keyId":secretFlag,//,密钥 -1--关闭 0-开启 Int
            "scope":Int(regionSlider.currentValue!*1000),//,模糊范围 Int (以米为单位)
            "readStartMonth":startMonth,//可阅读开始月份 String
            "readEndMonth":endMonth,//可阅读结束月份 String
            "readStartDay":startDay,//可阅读开始日期 String
            "readEndDay":endDay,//可阅读结束日期 String
            "readStartTime":startHour,//,可阅读开始时间 String
            "readEndTime" :endHour,//,可阅读结束时间 String
            "readTimes" :readeablTimes,//,阅读次数 Int -1-无数次
            "attachmentTypeId":attachmentTypeId!,//,附件类型 1-图片 2-视频 Int
            "attachmentLength":duration!,//长度，如果是视频，填写视频的长度，单 位为秒 Int
            ] as [String:Any]
        // 视频数据
        let mp4Data = NSData(contentsOf: mp4Path)
        
        let urlString = SWUrlHeader + "m/m/addNewMessage"
        let headers = ["content-type":"multipart/form-data"]
        
        SVProgressHUD.show()
        Alamofire.upload(
            multipartFormData: { multipartFormData in

                for (key, value) in parameters {
                    let valueStr = "\(value)"
                    multipartFormData.append(valueStr.data(using: String.Encoding.utf8)!, withName: key)
                }
                
                multipartFormData.append(mp4Data! as Data, withName: "attachmentFile", fileName: "123456.mp4", mimeType: "video/mp4")
        },
            to: urlString,
            headers: headers,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    //连接服务器成功后，对json的处理
                    upload.responseJSON { response in
                        SVProgressHUD.dismiss()
                        //解包
                        let handler = HSResponseHandler.handle(response: response)
                        if handler.error == nil {
                            self.addNewMessageHandler(handler.data)
                        } else {
                            SVProgressHUD.showError(withStatus: handler.error?.errorMessage)
                        }
                       
                    }
//                    //获取上传进度
//                    upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
//                        print("图片上传进度: \(progress.fractionCompleted)")
//                    }
                case .failure(let encodingError):
                    //失败原因
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: encodingError as? String)
                }
        })
        
    }
    //发布信息请求结果处理
    func addNewMessageHandler(_ result: HSSuccessResponse?) {
        
        let str = String.init(format: "%@", result?.data as! CVarArg)
        
        let messageInfoModel = SWMessageInfoModel.init()
        messageInfoModel.messageId = NSInteger(str)!
        
        let letterVC = SecretLetterViewController.initViewController()
        letterVC.messageInfoModel = messageInfoModel
        letterVC.userCenter = userCenter
        letterVC.needPodHoom = true
        self.navigationController?.pushViewController(letterVC, animated: true)
    }
    
    //密信的内容编辑按钮事件处理
    @IBAction func textEditButtonClicked(_ sender: Any) {
        resetSubViews(0)
    }
    
    //密信的日期时间设置按钮事件处理
    @IBAction func timeSettingButtonClicked(_ sender: Any) {
        resetSubViews(1)
    }
    
    //定位按钮事件处理
    @IBAction func locationButtonClicked(_ sender: Any) {
        resetSubViews(2)
    }
    
    //密信的更多按钮事件处理
    @IBAction func moreSettingButtonClicked(_ sender: Any) {
        resetSubViews(3)
    }
    
    //日期时间设置的事件处理
    @IBAction func timePickButtonClicked(_ sender: Any) {
        if timeStyle == 0 {
            timePickButton.setImage(UIImage(named: "3日"), for: .normal)
            timeStyle = 1
            datePickerView.reloadData(1)
            datePickerView.loadData(1, upper: Int(startDay)! - 1, floor: Int(endDay)! - 1)
        } else if timeStyle == 1 {
            timePickButton.setImage(UIImage(named: "3时"), for: .normal)
            timeStyle = 2
            datePickerView.reloadData(2)
            datePickerView.loadData(2, upper: Int(startHour)! - 1, floor: Int(endHour)! - 1)
        } else if timeStyle == 2 {
            timePickButton.setImage(UIImage(named: "3月"), for: .normal)
            timeStyle = 0
            datePickerView.reloadData(0)
            datePickerView.loadData(0, upper: Int(startMonth)! - 1, floor: Int(endMonth)! - 1)
        }
    }
    
    //MARK:重置时间的按钮事件处理
    @IBAction func timeResetButtonClicked(_ sender: Any) {
        if timeStyle == 1 {
            datePickerView.loadData(1, upper: 0, floor: 30)
        } else if timeStyle == 2 {
            datePickerView.loadData(2, upper: 0, floor: 23)
        } else if timeStyle == 0 {
            datePickerView.loadData(0, upper: 0, floor: 11)
        }
    }
    //MARK:次数无限大按钮事件处理
    @IBAction func readCountResetButtonClick(_ sender: UIButton) {
        timesPickerView.loadData(0)
        messageReadTimesLabel.text = "可读次数：无限次"
        readeablTimes = -1
    }
    
    //重置密信的设置页面
    func resetSubViews(_ index: Int) {
        view.endEditing(true)
        textEditButton.setBackgroundImage(UIImage(named:"ms文字内容默认"), for: .normal)
        timeSettingButton.setBackgroundImage(UIImage(named:"ms可读时间默认"), for: .normal)
        locationButton.setBackgroundImage(UIImage(named:"ms可读范围默认"), for: .normal)
        moreSettingButton.setBackgroundImage(UIImage(named:"ms更多条件默认"), for: .normal)
        msMessageView.isHidden = true
        msReadTimeView.isHidden = true
        msDistanceView.isHidden = true
        msMoreSetView.isHidden = true
        regionSlider.isHidden = true
        
        if index == 0 {
           textEditButton.setBackgroundImage(UIImage(named:"ms文字内容"), for: .normal)
            bigBGView.image = UIImage(named: "ms文字内容BG")
            msMessageView.isHidden = false
        } else if index == 1 {
            timeSettingButton.setBackgroundImage(UIImage(named:"ms可读时间"), for: .normal)
            bigBGView.image = UIImage(named: "ms可读时间BG")
            msReadTimeView.isHidden = false
        } else if index == 2 {
            locationButton.setBackgroundImage(UIImage(named:"ms可读范围"), for: .normal)
            bigBGView.image = UIImage(named: "ms可读范围BG1")
            msDistanceView.isHidden = false
            regionSlider.isHidden = false
        } else if index == 3 {
            moreSettingButton.setBackgroundImage(UIImage(named:"ms更多条件"), for: .normal)
            bigBGView.image = UIImage(named: "ms更多条件BG1")
            msMoreSetView.isHidden = false
        }

    }
    
    //创建密信的范围设置滑动控件
    func createRegionSliderView() -> SWCustomSliderView {
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let frame = CGRect(x: (width - 325.0) / 2.0, y: height - 90.0, width: 325.0, height: 80)
        let view = SWCustomSliderView(frame: frame, isShowUpdateButton: true, current: 1000.0 / 1000.0, minMum: 10, maxMum: 1000, unit: " m")
        return view
        
    }
    
    //重置密信范围
    func resetDistance(_ distanceString: String) {
        
        let attributedText = NSMutableAttributedString(string: distanceString)
        attributedText.setAttributes([NSForegroundColorAttributeName: UIColor.white], range: NSRange.init(location: 0, length: distanceString.count - 1))
        distanceLabel.attributedText = attributedText
        
    }
    
    //密信的秘钥开关事件
    func handleSecrectKeySwitchEvent(_ sender: SWSecretKeySwitch) {
     
        if sender.on {
            secretFlag = 0
            secretFlagLabel.text = "添加密匙"
        } else {
            secretFlag = -1
            secretFlagLabel.text = "不添加密匙"
        }
    }
    
    //MARK: 给textview添加placeholder
    func setupTextViewPlaceholder () {
        // _placeholderLabel
        let placeHolderLabel = UILabel.init()
        
        let  attrStr = NSAttributedString(string: "   添加文字...", attributes: [NSForegroundColorAttributeName : UIColor.gray])
        let attch = NSTextAttachment.init()
        
        attch.image = UIImage.init(named: "ms_text_icon")
        attch.bounds = CGRect(x: 0, y: 0, width: 18, height: 18)
        
        let attrImageStr = NSAttributedString(attachment: attch)
        let attrText = NSMutableAttributedString.init()
        attrText.append(attrImageStr)
        attrText.append(attrStr)
        placeHolderLabel.attributedText = attrText
       
        messageTextView.addSubview(placeHolderLabel)
        // same font
        placeHolderLabel.font = UIFont.systemFont(ofSize: 14)
        messageTextView.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        
        
        let textFPlaceHolder = UILabel.init()
        
        let  attrStr1 = NSAttributedString(string: " 情景标题", attributes: [NSForegroundColorAttributeName : UIColor.gray])
        let attch1 = NSTextAttachment.init()
        
        attch1.image = UIImage.init(named: "ms_text_title_icon")
        attch1.bounds = CGRect(x: 0, y: -2, width: 18, height: 18)
        
        let attrImageStr1 = NSAttributedString(attachment: attch1)
        let attrText1 = NSMutableAttributedString.init()
        attrText1.append(attrImageStr1)
        attrText1.append(attrStr1)
        textFPlaceHolder.attributedText = attrText1
      

        // same font
        textFPlaceHolder.font = UIFont.systemFont(ofSize: 14)
        messageTitle.setValue(textFPlaceHolder, forKey: "_placeholderLabel")
        
    }
    
}

//密信范围滑动控件的delegate
extension SWMessageSettingViewController: SWCustomSliderViewDelegate {
    
    // 改变地图范围
    func sliderView(_ view: SWCustomSliderView, didEndedSlideTo percent: Double) {
        print("didEndedSlideTo percent: %f", percent)
        let distance = (view.calibration?.text)!
        self.resetDistance(distance)
        if userCenter != nil {
            
            let region = MKCoordinateRegion(center: userCenter!, span: MKCoordinateSpan(latitudeDelta: percent * 0.02, longitudeDelta: percent * 0.02))
            let regionThatFits = self.msMapView.regionThatFits(region)
            self.msMapView.setRegion(regionThatFits, animated: true)
            
        }

    }

}

extension SWMessageSettingViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
       
        self.reverseGeocode(userLocation.location!)
        
        msMapView.showsUserLocation = false
        userCenter = userLocation.coordinate
        let percent = 500.0 / 1000.0
        let region = MKCoordinateRegion(center: userCenter!, span: MKCoordinateSpan(latitudeDelta: percent * 0.05, longitudeDelta: percent * 0.05))
        let regionThatFits = self.msMapView.regionThatFits(region)
        self.msMapView.setRegion(regionThatFits, animated: true)
    }
}

extension SWMessageSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location >= 8 {
            return false
        }
        return true
        
    }
}

extension SWMessageSettingViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let textStr = textView.text!
        if textStr.count > 200 {
            
            let index = textStr.index(textStr.startIndex, offsetBy: 200)
            self.messageTextView.text = textView.text.substring(to: index)
        }
        
        self.wordCountLabel.text = String.init(format: "%@/%@字", textStr.count.description, 200.description)
        
    }
    
}


extension SWMessageSettingViewController: SWPickerViewDelegate {
    
    func pickerView(_ pickerView: SWPickerView, didSelectedData dataString: String) {
        if Int(dataString) == 0 {
            messageReadTimesLabel.text = "可读次数：无限次"
            readeablTimes = -1
        } else {
            messageReadTimesLabel.text = String(format: "可读次数：%@次", (Int(dataString)?.description)!)
            readeablTimes = Int(dataString)!
        }
    }
}

extension SWMessageSettingViewController: SWCustomDatePickerViewDelegate {
    
    func pickerView(_ pickerView: SWCustomDatePickerView, didSelectedDateData data: Dictionary<String, String>) {
        
        let type = data["type"]
        if type == "0" {
            monthRangeView.topLabel?.text = data["upper"]! + "月"
            monthRangeView.bottomLabel?.text = data["floor"]! + "月"
            startMonth = data["upper"]!
            endMonth = data["floor"]!
        } else if type == "1" {
            dayRangeView.topLabel?.text = data["upper"]! + "日"
            dayRangeView.bottomLabel?.text = data["floor"]! + " 日"
            startDay = data["upper"]!
            endDay = data["floor"]!
        } else if type == "2" {
            hourRangeView.topLabel?.text = data["upper"]! + "时"
            hourRangeView.bottomLabel?.text = data["floor"]! + "时"
            startHour = data["upper"]!
            endHour = data["floor"]!
        }
    }
}
extension SWMessageSettingViewController: SWMsgSetResultVCDelegate {
    func messageSetResultComfir() {
        self.addMessageRequest()
    }
}

