//
//  SWHomeViewController.swift
//  SceneWhisper
//
//  Created by weipo 2017/2/5.
//  Copyright © 2017年 weipo. All rights reserved.
//  首页

import UIKit
import MapKit
import SVProgressHUD



class SWHomeViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapBackgroundView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    //用户信息
    fileprivate var userInfoModel: SWUserInfoModel!
    //底部地址view
    lazy var bottomAddressView: HomeBottomLocationAddressView = {
        let addressView = HomeBottomLocationAddressView(frame: CGRect.zero)
        self.view.addSubview(addressView)
        return addressView
    }()
    //纬度指示控件
    lazy var latitudeView: HSCustomCompassView = {
        let latView = HSCustomCompassView.init(CGPoint(x: UIScreen.main.bounds.width / 2.0 - 88.0 - 0.5, y: UIScreen.main.bounds.height - 154.0), style: HSCustomCompassStyle.latitude)
        self.view.addSubview(latView)
        return latView
    }()
    //经度指示控件
    lazy var longitudeView: HSCustomCompassView = {
        let longView = HSCustomCompassView.init(CGPoint(x: UIScreen.main.bounds.width / 2.0 + 0.5, y: UIScreen.main.bounds.height - 154.0), style: HSCustomCompassStyle.longitude)
        self.view.addSubview(longView)
        return longView
    }()
    
    //地址编译器
    var geocoder = CLGeocoder()
    //密信片列表缓存
    var messagesList: NSMutableArray = NSMutableArray()
    //annotationImage数据
    var homeAannoImages:[UIImage] = []
    //上一次发现请求的位置信息
    fileprivate var userLastLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置地图
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = KScaleW * 340 * 0.5
        
        mapView.layer.borderColor = UIColor.color(with: "514953", alpha: 1.0).cgColor
        mapView.layer.borderWidth = 2
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        //设置地图背景图
        mapBackgroundView.layer.cornerRadius = KScaleW * 343 * 0.5
        
        //为经纬度控件添加红线
        self.addRedLine()
        
        //头像
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2.0
        // 注册密信增/删通知
        NotificationCenter.default.addObserver(self, selector: #selector(requestData), name: NSNotification.Name(rawValue:"ADDORDELETENEWMESSAGE"), object: nil)
        
    }
    
    class func initViewController() -> SWHomeViewController {
        return UIStoryboard.init(name: "HomePage", bundle: nil).instantiateViewController(withIdentifier: "SWHomeViewController") as! SWHomeViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //获取用户信息
        userInfoModel = SWDataManager.manager.currentUserInfo() as SWUserInfoModel
        //头像
        avatarImageView.sd_setImage(with: URL(string: (SWUrlHeader + userInfoModel.photo)), placeholderImage: UIImage(named: "im_user_head_default"))
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //防止页面切换时，正在网络请求，显示ProgressView
        
        SVProgressHUD.dismiss()
    }
    deinit {
        /// 移除通知
        NotificationCenter.default.removeObserver(self)
    }
   
    //MARK:加载annotationVIew的图片
    func loadAnnotationImage(with urlStr: String) -> UIImage {
        let imageURL = URL.init(string: SWUrlHeader + urlStr)
        
        guard let imagedata = NSData(contentsOf: imageURL!) else {
             return UIImage.init(named: "im_user_head_default")!
        }
        guard let cacheImage = UIImage(data: imagedata as Data, scale: 1.0) else {
            return UIImage.init(named: "im_user_head_default")!
        }
        return cacheImage
    }
    //MARK:二维码跳转
    @IBAction func qrcodeButtonClicked(_ sender: Any) {
        let QRVC = SWQRCodeViewController.initViewController()
        QRVC.userCenter = userLastLocation?.coordinate
        navigationController?.pushViewController(QRVC, animated: true)
        
    }

    //MARK:设置跳转
    @IBAction func settingBttonClicked(_ sender: Any) {
        let viewController = SWSettingViewController.initViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK:相机视频的跳转
    @IBAction func cemeraButtonClicked(_ sender: Any) {

        let viewController = CameraSelectViewController.initViewController()
        viewController.delegate = self as CameraSelectViewControllerDelegate
        self.modalPresentationStyle = UIModalPresentationStyle.currentContext
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(viewController, animated: true) {
    
        }
    }
    
    //为经纬度控件添加连起来的红线
    func addRedLine() {
        let latCenterPoint = latitudeView.convert((latitudeView.centerPoint?.center)!, to: self.view)
        let lonCenterPoint = longitudeView.convert((longitudeView.centerPoint?.center)!, to: self.view)
        let x = latCenterPoint.x
        let y = latCenterPoint.y
        let width = lonCenterPoint.x - x
        let height: CGFloat = 1.0
        let redLine = UIView(frame: CGRect(x: x, y: y - height / 2.0, width: width, height: height))
        redLine.backgroundColor = UIColor.color(with: "ff3210")
        self.view .addSubview(redLine)
    }
    
    //MARK:密信片列表页跳转
    @IBAction func messageButtonClicked(_ sender: Any) {
        
        let viewController = SWMessagesViewController.initViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    //MARK:用户定位聚焦
    @IBAction func locatingButtonClicked(_ sender: Any) {
        
        mapView.setCenter((mapView.userLocation.location?.coordinate)!, animated: true)
        
    }
    
    //MARK:用户个人信息页跳转
    @IBAction func avatarButtonClicked(_ sender: Any) {
        
        let viewController = SWMeViewController.initViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    //MARK:用户地址编译
    func reverseGeocode(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            let placemark = placemarks?.first
            if placemark == nil {
                return
            }

            var address: String = placemark?.addressDictionary!["City"] as! String + "-"
            address += placemark?.addressDictionary?["SubLocality"] as! String + "-"
            address += placemark?.addressDictionary?["Name"] as! String
            self.bottomAddressView.changeAddress(address)
        }
    }
    //MARK: 发现信息请求
    func requestData() {
        
        let parameters = ["lng": NSString(format: "%lf", (userLastLocation?.coordinate.longitude)!),
                          "lat": NSString(format: "%lf", (userLastLocation?.coordinate.latitude)!),
                          "scope": 1000] as [String : Any]
        SWRequestManager.discoveryMessage(parameters) {[weak self] (result, error) in
            guard let strongSelf = self else { return }
            strongSelf.discoveryMessageHandler(result, error: error)
        }
    }
    //发现信息请求结果处理
    func discoveryMessageHandler(_ result: HSSuccessResponse?, error: HSErrorResponse?) {
        
        if error != nil {
            SVProgressHUD.showError(withStatus: (String(describing: error?.errorMessage!)))
        } else {
            let data: Array<Dictionary<String, Any>> = result?.data as! Array<Dictionary<String, Any>>
            if data.count != 0 {
                for i in 0..<data.count {
                    let messageModel = SWMessageInfoModel().discoveryMessageData(data[i])
                    self.messagesList.add(messageModel)
                    let pinAnnotation = SWMapAnnotation()
                    pinAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(messageModel.placeLat)!, longitude: Double(messageModel.placeLng)!)
                    pinAnnotation.userGender = messageModel.userGender
                    pinAnnotation.tag = 100 + i
                    
                    // 用户头像
                    let image = self.loadAnnotationImage(with: messageModel.userPhoto)
                    homeAannoImages.append(image)
                    mapView.addAnnotation(pinAnnotation)
                }
                
            }
            
        }
    }
}

//MARK: MKMapView Delegate 扩展
extension SWHomeViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // 更新详细位置
        self.reverseGeocode(userLocation.location!)
        self.longitudeView.loadData(userLocation.coordinate)
        self.latitudeView.loadData(userLocation.coordinate)
        
        guard userLastLocation != nil else {
            userLastLocation = userLocation.location!
            //发现信息请求
            let parameters = ["lng": NSString(format: "%f", userLocation.coordinate.longitude),
                              "lat": NSString(format: "%f", userLocation.coordinate.latitude),
                              "scope": 1000] as [String : Any]
            SWRequestManager.discoveryMessage(parameters) {[weak self] (result, error) in
                guard let strongSelf = self else { return }
                strongSelf.discoveryMessageHandler(result, error: error)
            }
            return
        }
        
        // 位置改变范围大于100米，重新请求数据
        if (userLocation.location?.distance(from: userLastLocation!))! > 100.00 {
            userLastLocation = userLocation.location!
            // 定位完成,发现信息请求
            self.requestData()
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
     
        let alert = UIAlertController.init(title: "未获得位置信息", message: "请在iPhone的“设置-隐私-定位服务”中打开", preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "知道了", style: .cancel, handler: nil)
        alert .addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // annotationView点击事件（需设置annotation的title后才有效）
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let pinAnnotation = view.annotation as? SWMapAnnotation else { return }
        let index = pinAnnotation.tag - 100
        let model = messagesList[index] as! SWMessageInfoModel
        let letterVC = SecretLetterViewController.initViewController()
        letterVC.userCenter = userLastLocation?.coordinate
        letterVC.needPodHoom = false
        letterVC.messageInfoModel = model
        self.navigationController?.pushViewController(letterVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let swMapAnnotation:SWMapAnnotation = annotation as? SWMapAnnotation else { return nil }
        let index = swMapAnnotation.tag - 100
        let userPhoto = homeAannoImages[index]
        let userGender = swMapAnnotation.userGender
        
        let identifier = "SWMessagesPinAnnotationView"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        pinView?.annotation = annotation
        
        pinView?.image = userPhoto.annotationImage(userGender: userGender!)
        // 点击是否显示title
        //        pinView?.canShowCallout = true
        
        //        pinView?.isSelected = true
        //        let calloutImage = UIImage(named: "pin_callout_bg")
        //        let calloutImageView = UIImageView(image: calloutImage)
        //        calloutImageView.frame = CGRect(origin: .zero, size: calloutImage!.size)
        //        pinView?.rightCalloutAccessoryView = calloutImageView
        
        return pinView
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
    }
    
}

//MARK: CameraSelectViewController Delegate 扩展
extension SWHomeViewController: CameraSelectViewControllerDelegate {

    func selectView(_ view: CameraSelectViewController, didDismissHandler handleType: Int) {
        print("handle type: \(handleType)")
        if handleType == 0 {   //相机actionSheet
            let kjCamera = UIStoryboard.init(name: "KJCamera", bundle: nil) .instantiateViewController(withIdentifier: "KJCustomCameraController") as! KJCustomCameraController
            
            navigationController?.pushViewController(kjCamera, animated: true)
        } else {   //视频actionSheet
            let fileVC = FMFileVideoController()

            self.navigationController?.pushViewController(fileVC, animated: true)
        }
    }
}
