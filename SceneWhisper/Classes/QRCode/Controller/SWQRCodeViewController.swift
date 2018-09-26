//
//  SWQRCodeScanningViewController.swift
//  SceneWhisper
//
//  Created by weipo 2017/6/14.
//  Copyright © 2017年 weipo. All rights reserved.
//  二维码扫描页

import UIKit
import Photos
import AVKit
import AVFoundation
import SVProgressHUD

class SWQRCodeViewController: UIViewController,
                                      AVCaptureMetadataOutputObjectsDelegate,
                                      UINavigationControllerDelegate,
                                      UIImagePickerControllerDelegate {
    private var timer: Timer?
    private var session: AVCaptureSession?
    private var preViewLayer: AVCaptureVideoPreviewLayer?
 
    private let SWQRCodeInformationFromAlbum: String = "SWQRCodeInformationFromAlbum"
    
    @IBOutlet var lineY: NSLayoutConstraint!
    
    @IBOutlet var QRbgTop: NSLayoutConstraint!
    @IBOutlet var QRbgBottom: NSLayoutConstraint!
    
    private var originY:CGFloat?

    var userCenter: CLLocationCoordinate2D? //用户定位
    
    class func initViewController() -> SWQRCodeViewController {
        return UIStoryboard.init(name: "QRCode", bundle: nil).instantiateViewController(withIdentifier: "SWQRCodeViewController") as! SWQRCodeViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            if (UIApplication.shared.keyWindow?.safeAreaInsets.top)! > 0 {
                QRbgTop.constant = (UIApplication.shared.keyWindow?.safeAreaInsets.top)! + 50
            }
            
            QRbgBottom.constant = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!
        }
        
        originY = lineY.constant
        self.view.backgroundColor = UIColor.clear
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.setupQRCodeScanning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTimer()
    }
    
    deinit {
        self.removeTimer()
    }
    
    //MARK: 添加定时器
    func addTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    //MARK: 移除定时器
    func removeTimer() {
        if (self.timer != nil) && self.timer!.isValid {
            self.timer!.invalidate()
            self.timer = nil
        }
    }
    //MARK:定时器活动
    func timeAction() {
        UIView.animate(withDuration: 2, animations: {
            self.lineY.constant -= KScreenWidth * 0.6
            self.view.layoutIfNeeded()
        }) { _ in
            self.lineY.constant += KScreenWidth * 0.6
        }
    }

    @IBAction func photoButtonAction(_ sender: UIButton) {
        self.readImageFromAlbum()
    }
    
    func readImageFromAlbum() {
        
        // 1、 获取摄像设备
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        if (device != nil) {
            
            // 判断授权状态
            let status = PHPhotoLibrary.authorizationStatus()
            
            if status == PHAuthorizationStatus.notDetermined {
                // 弹框请求用户授权
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized {
                        DispatchQueue.main.async { [weak self] in
                            guard let strongSelf = self else { return }
                            let imagePicker = UIImagePickerController()
                            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                            imagePicker.delegate = strongSelf
                            strongSelf.present(imagePicker, animated: true, completion: {
                                
                            })
                        }
                    } else {
                        // 用户第一次拒绝了访问相机权限
                    }
                })
            } else if status == PHAuthorizationStatus.authorized {
                // 用户允许当前应用访问相册
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
                
            } else if status == PHAuthorizationStatus.denied {
                // 用户拒绝当前应用访问相册
                let alertController = UIAlertController(title: "未获得照片授权", message: "请在iPhone的“设置-隐私-照片”中打开", preferredStyle: UIAlertControllerStyle.alert)
                let alertAction = UIAlertAction(title: "知道了", style: UIAlertActionStyle.default, handler: { (action) in
                    
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else if status == PHAuthorizationStatus.restricted {
                
                let alertController = UIAlertController(title: "温馨提示", message: "由于系统原因, 无法访问相册", preferredStyle: UIAlertControllerStyle.alert)
                let alertAction = UIAlertAction(title: "知道了", style: UIAlertActionStyle.default, handler: { (action) in
                    
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.scanQRcodeFromPhotosInAlbum(info["UIImagePickerControllerOriginalImage"] as! UIImage)
        }
    }
    
    //从相册中识别二维码, 并进行界面跳转
    func scanQRcodeFromPhotosInAlbum(_ image: UIImage) {
        
        // 对选取照片的处理，如果选取的图片尺寸过大，则压缩选取图片，否则不作处理
        let handledImage = UIImage.imageSize(with: image)
        
        // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
        // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        // 取得识别结果
        let features = detector?.features(in: CIImage(cgImage: handledImage.cgImage!))
        for i in 0..<features!.count {
            let feature: CIQRCodeFeature = features![i] as! CIQRCodeFeature
            let scannedResult: String = feature.messageString!
            // 扫描结果
            goQRCodeResultVC(urlstr: scannedResult)
        }
    }
    
    
    func goQRCodeResultVC(urlstr:String) {
        if urlstr.hasPrefix("http://www.scenechat.cn/") {
            let index = urlstr.index(urlstr.endIndex, offsetBy: -2)
            let suffix = urlstr.substring(from: index)
            let messageInfoModel = SWMessageInfoModel.init()
            messageInfoModel.messageId = NSInteger(suffix)!
            
            let letterVC = SecretLetterViewController.initViewController()
            letterVC.messageInfoModel = messageInfoModel
            letterVC.userCenter = userCenter
            letterVC.needPodHoom = true
            self.navigationController?.pushViewController(letterVC, animated: true)
        } else {
            SVProgressHUD.showError(withStatus: "不能识别的二维码！")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupQRCodeScanning() {
        
        // 1、获取摄像设备
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // 2、创建输入流
        var input: AVCaptureDeviceInput? = nil
        do {
            try input = AVCaptureDeviceInput.init(device: device)
        } catch  {
            let alert = UIAlertController.init(title: "未获得相机授权", message: "请在iPhone的“设置-隐私-相机”中打开", preferredStyle: .alert)
            let alertAction = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
            alert .addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // 3、创建输出流
        let output = AVCaptureMetadataOutput()
        
        // 4、设置代理 在主线程里刷新
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
        // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）
        output.rectOfInterest = CGRect(x: 0.05, y: 0.2, width: 0.7, height: 0.6)
        
        // 5、初始化链接对象（会话对象）
        self.session = AVCaptureSession()
        
        // 高质量采集率
        session?.canSetSessionPreset(AVCaptureSessionPresetHigh)
        
        // 5.1 添加会话输入
        session?.addInput(input)
        
        // 5.2 添加会话输出
        session?.addOutput(output)
        
        // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
        // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,
                                      AVMetadataObjectTypeEAN13Code,
                                      AVMetadataObjectTypeEAN8Code,
                                      AVMetadataObjectTypeCode128Code]
        
        // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
        self.preViewLayer = AVCaptureVideoPreviewLayer.init(session: session)
        preViewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        preViewLayer?.frame = self.view.layer.bounds
        
        // 8、将图层插入当前视图
        self.view.layer.insertSublayer(preViewLayer!, at: 0)
        
        // 9、启动会话
        session?.startRunning()
        
    }
    
    //MARK: AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // 0、扫描成功之后的提示音
        self.playSoundEffect("QRCode.bundle/sound.caf")
        
        // 1、如果扫描完成，停止会话
        self.session?.stopRunning()
        
        // 2、删除预览图层
        self.preViewLayer?.removeFromSuperlayer()
        
        // 3、设置界面显示扫描结果
        if metadataObjects.count > 0 {
            let obj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            let result = obj.stringValue!
            // 扫描结果
            goQRCodeResultVC(urlstr: result)
        }
    }
    
    /** 播放音效文件 */
    func playSoundEffect(_ name: String) {
        
        // 获取音效
        let audioFile = Bundle.main.path(forResource: name, ofType: nil)
        let fileUrl = NSURL(fileURLWithPath: audioFile!)
        
        // 1、获得系统声音ID
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(fileUrl, &soundID)
        AudioServicesAddSystemSoundCompletion(soundID, nil, nil, { (soundID, clientData) -> Void in AudioServicesDisposeSystemSoundID(soundID)}, nil)
        
        // 2、播放音频
        AudioServicesPlaySystemSound(soundID)
        
    }
    
  
    @IBAction func goBackAction(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
    }
 
    
}
