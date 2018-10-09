//
//  SWMessageViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/6/13.
//  Copyright © 2017年 weipo. All rights reserved.
//  查看私语信息库

import UIKit
import MapKit
import SDWebImage
import IQKeyboardManagerSwift
import SVProgressHUD

//密信的可读状态
enum MessageCanReadStatus: Int {
    case readable = 1
    case unreadable = 0
    case all = -1
}

//密信已读状态
enum MessageAlreadyReadStatus: Int {
    case read = 1
    case unRead = 0
    case all = -1
}

//密信的秘钥状态
enum MessageSecretKeyStatus: Int {
    case all = -1
    case secretKey = 1
    case unSecretKey = 0
    
}
//密信类型
enum MessageType: Int {
    case identified = 1
    case generated = 0
}


class SWMessagesViewController: UIViewController {
    
    @IBOutlet weak var mListMainView: UIView! 
    @IBOutlet weak var mTableVIew: UITableView!
    @IBOutlet weak var listBgImage: UIImageView!
    @IBOutlet weak var mMapMainView: UIView!
    @IBOutlet weak var mapBgImage: UIImageView!
    @IBOutlet weak var mMapView: MKMapView!
    
    @IBOutlet weak var searchBar: HSCustomSearchBar!
    @IBOutlet weak var canReadImageView: UIImageView!
    @IBOutlet weak var readedImageView: UIImageView!
    @IBOutlet weak var secretKeyImageVIew: UIImageView!
    @IBOutlet weak var canReadView: UIView!
    @IBOutlet weak var readedView: UIView!
    @IBOutlet weak var secretKeyView: UIView!
    
    var canReadStatus: MessageCanReadStatus = .all
    var alreadyreadStatus: MessageAlreadyReadStatus = .all
    var secretKeyStatus: MessageSecretKeyStatus = .all
    var messgeCurrentType: MessageType = .generated
    
    var searchKey: String = ""
    
    var isCreated: Bool? = false
    var isMap: Bool? = true
    //用户私语库数据
    var userMessagesList: NSMutableArray = NSMutableArray()
    
    //annotationImage数据
    var annoImages:[UIImage] = []
    /** 用户定位 */
    var userCenter: CLLocationCoordinate2D? 
    
    class func initViewController() -> SWMessagesViewController {
        return UIStoryboard.init(name: "ReadMessage", bundle: nil).instantiateViewController(withIdentifier: "SWMessagesViewController") as! SWMessagesViewController
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        mMapView.layer.cornerRadius = KScreenWidth / 375.0 * 340 * 0.5
        mMapView.layer.masksToBounds = true
        mMapView.layer.borderWidth = 2.5
        mMapView.layer.borderColor = UIColor.color(with: "514953", alpha: 1.0).cgColor
        mMapView.delegate = self
        mMapView.showsUserLocation = true
        mMapView.userTrackingMode = .follow
        
        self.conditionButtonAnimation(true)
        // 请求数据
        self.requstData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        self.zoomMapViewToFitAnnotations(mapView: mMapView)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
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
    
    //MARK:请求数据
    func requstData() {
        /**
         userId://,用户 Id Long
         messageType://,信息类型 0-已生成 1-已识别 Int
         canReadStatus://可读状态 -1-全部 0-可读 1-不可读 Int
         alreadyReadStatus://已读状态 -1-全部 0-未读 1-已读 Int
         hasKeyStatus://密钥状态 -1-全部 0-没有密钥 1-有密钥 Int
         keywords://搜索关键字 String
         **/
        let parameters = ["userId":SWDataManager.currentUserId(),
                          "messageType":messgeCurrentType.rawValue,
                          "canReadStatus":canReadStatus.rawValue,
                          "alreadyReadStatus":alreadyreadStatus.rawValue,
                          "hasKeyStatus":secretKeyStatus.rawValue,
                          "keywords":searchKey,
                          ] as [String:Any]
        
        SWRequestManager.queryUserMessage(parameters) {[weak self] (result, error) in
            guard let strongSelf = self else { return }
            strongSelf.queryUserMessageHandler(result, error: error)
        }
        
    }
    //密语库请求结果处理
    func queryUserMessageHandler(_ result: HSSuccessResponse?, error: HSErrorResponse?) {
        userMessagesList.removeAllObjects()
        annoImages.removeAll()
        mMapView.removeAnnotations(mMapView.annotations)
        if error != nil {
            print("discovery Message error: \(String(describing: error?.errorMessage))")
            
        } else {
            let data: Array<Dictionary<String, Any>> = result?.data as! Array<Dictionary<String, Any>>
            if data.count != 0 {
                for i in 0..<data.count {
                    let model = SWMessageInfoModel().queryUserMessage(data[i])
                    userMessagesList.add(model)
                    
                    let pinAnnotation = SWMapAnnotation()
                    pinAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(model.placeLat)!, longitude: Double(model.placeLng)!)
                    pinAnnotation.userGender = model.userGender
                    pinAnnotation.title = "uerPinAnnotation"
                    pinAnnotation.tag = 100 + i
                    // 用户头像
                    let image = self.loadAnnotationImage(with: model.userPhoto)
                    
                    annoImages.append(image)
                    mMapView.addAnnotation(pinAnnotation)
                }
                
            }
            mTableVIew.reloadData()
            
            
            // MKMapView缩放显示全部annotation
            self.zoomMapViewToFitAnnotations(mapView: mMapView)
            
        }
    }
    // 返回按钮
    @IBAction func getbackButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //导航栏右边按钮
    @IBAction func moreButtonClicked(_ sender: Any) {
        view.endEditing(true)
        
        if isMap! {
            
            mListMainView.isHidden = false
            mMapView.isHidden = true
            mapBgImage.isHidden = true
            self.view.bringSubview(toFront: mListMainView)
            isMap = false
            self.conditionButtonAnimation(false)
            
        } else {

            mListMainView.isHidden = true
            mMapView.isHidden = false
            mapBgImage.isHidden = false
            self.view.bringSubview(toFront: mMapView)
            isMap = true
            self.conditionButtonAnimation(true)
            
        }
        
    }

    @IBAction func listIdentifiedButtonClicked(_ sender: Any) {
        view.endEditing(true)
        
        self.listBgImage.image = UIImage(named: "列表_已识别")
        messgeCurrentType = .identified
        self.requstData()
    }
    
    @IBAction func listCreatedButtonClicked(_ sender: Any) {
        view.endEditing(true)
        
        self.listBgImage.image = UIImage(named: "列表_已生成")
        messgeCurrentType = .generated
        self.requstData()
    }
    
    @IBAction func identifiedButtonClicked(_ sender: Any) {
        view.endEditing(true)
        
        if canReadStatus == .readable {
            canReadImageView.image = UIImage(named: "秘信列表未读状态2")
            canReadStatus = .unreadable
        } else if canReadStatus == .unreadable {
            canReadImageView.image = UIImage(named: "秘信列表未读状态3")
            canReadStatus = .all
        } else if canReadStatus == .all {
            canReadImageView.image = UIImage(named: "秘信列表未读状态1")
            canReadStatus = .readable
        }
        self.requstData()
    }
    
    @IBAction func readButtonClicked(_ sender: Any) {
        view.endEditing(true)
        
        if alreadyreadStatus == .read {
            readedImageView.image = UIImage(named: "秘信列表已读状态2")
            alreadyreadStatus = .unRead
        } else if alreadyreadStatus == .unRead {
            readedImageView.image = UIImage(named: "秘信列表已读状态3")
            alreadyreadStatus = .all
        } else if alreadyreadStatus == .all {
            readedImageView.image = UIImage(named: "秘信列表已读状态1")
            alreadyreadStatus = .read
        }
        self.requstData()
    }
    
    @IBAction func secretKeyButtonClicked(_ sender: Any) {
        view.endEditing(true)
        
        if secretKeyStatus == .secretKey {
            secretKeyImageVIew.image = UIImage(named: "秘信列表密钥2")
            secretKeyStatus = .unSecretKey
        } else if secretKeyStatus == .unSecretKey {
            secretKeyImageVIew.image = UIImage(named: "秘信列表密钥3")
            secretKeyStatus = .all
        } else if secretKeyStatus == .all {
            secretKeyImageVIew.image = UIImage(named: "秘信列表密钥1")
            secretKeyStatus = .secretKey
        }
        self.requstData()
    }
    
    @IBAction func mapCreatedButtonClicked(_ sender: Any) {
        view.endEditing(true)
        mapBgImage.image = UIImage(named: "熊_已生成")
        messgeCurrentType = .generated
        self.requstData()
    }
    
    @IBAction func mapIdentifiedButtonClicked(_ sender: Any) {
        view.endEditing(true)
        mapBgImage.image = UIImage(named: "熊_已识别")
        messgeCurrentType = .identified
        self.requstData()
    }
    
    func conditionButtonAnimation(_ isMap: Bool) {
        
        if isMap {
            
            UIView.animate(withDuration: 2.0, animations: { [weak self] in
                guard let strongSelf = self else { return }
                
                var frame = strongSelf.canReadView.frame
                frame.origin.y -= 20.0
                strongSelf.canReadView.frame = frame
                frame = strongSelf.readedView.frame
                frame.origin.y += 10.0
                strongSelf.readedView.frame = frame
                frame = strongSelf.secretKeyView.frame
                frame.origin.y -= 20.0
                strongSelf.secretKeyView.frame = frame
            })
            
        } else {
            
            UIView.animate(withDuration: 2.0, animations: { [weak self] in
                guard let strongSelf = self else { return }
                
                var frame = strongSelf.canReadView.frame
                frame.origin.y += 20.0
                strongSelf.canReadView.frame = frame
                frame = strongSelf.readedView.frame
                frame.origin.y -= 10.0
                strongSelf.readedView.frame = frame
                frame = strongSelf.secretKeyView.frame
                frame.origin.y += 20.0
                strongSelf.secretKeyView.frame = frame
                
            })
            
        }
    }
    
    private let  MINIMUM_ZOOM_ARC = 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
    private let ANNOTATION_REGION_PAD_FACTOR = 1.5
    private let MAX_DEGREES_ARC = 360.0
    //MARK: MKMapView缩放显示全部annotation
    func zoomMapViewToFitAnnotations(mapView:MKMapView) {
        let annotations = mapView.annotations
        let count = annotations.count
        if count == 0 {
            return
        }
        
        var points:Array<MKMapPoint> = []
   
        for i in 0..<count {
            let coordinate = annotations[i].coordinate
            points.append(MKMapPointForCoordinate(coordinate))
        }
        
        let mapRectF:MKPolygon = MKPolygon.init(points: points, count: count)
        let mapRect = mapRectF.boundingMapRect
        var region = MKCoordinateRegionForMapRect(mapRect)
        
        region.span.latitudeDelta *= ANNOTATION_REGION_PAD_FACTOR
        region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
        if region.span.latitudeDelta > MAX_DEGREES_ARC {
            region.span.latitudeDelta  = MAX_DEGREES_ARC
        }
        if region.span.longitudeDelta > MAX_DEGREES_ARC {
            region.span.longitudeDelta = MAX_DEGREES_ARC
        }
        
        //and don't zoom in stupid-close on small samples
        if region.span.latitudeDelta  < MINIMUM_ZOOM_ARC {
            region.span.latitudeDelta  = MINIMUM_ZOOM_ARC
        }
        if region.span.longitudeDelta < MINIMUM_ZOOM_ARC {
            region.span.longitudeDelta = MINIMUM_ZOOM_ARC
        }
        //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
        if count == 1 {
            region.span.latitudeDelta = MINIMUM_ZOOM_ARC
            region.span.longitudeDelta = MINIMUM_ZOOM_ARC
        }
       
        mapView.setRegion(region, animated: true)
    }
    
    //MARK:删除密信回调
    func deleteMessageHandler(_ result: HSSuccessResponse?, error: HSErrorResponse?) {
      
        if error != nil {
            SVProgressHUD.showError(withStatus: "\(String(describing: error?.errorMessage))")
        } else {
            // 成功重新请求数据
            SVProgressHUD.showSuccess(withStatus: "删除成功")
            // 发送密信增/删通知
            NotificationCenter.default.post(name: NSNotification.Name("ADDORDELETENEWMESSAGE"), object: self)
            self.requstData()
        }
      
    }
    //跳转到第三方地图 APP
    func toMapApps(vc: UIViewController, latitude: Double?, longitude: Double?, destName: String?) {
        guard let lati = latitude, let longi = longitude else {
            SVProgressHUD.showInfo(withStatus: "未获取到目的地经纬度")
            return
        }
        let destinationName = destName ?? ""
        let actionSheet = UIAlertController(title: "请选择地图", message: nil, preferredStyle: .actionSheet)
        //苹果自带高德地图
        let appleAction = UIAlertAction(title: "苹果地图", style: .default) { (action) in
            let loc = CLLocationCoordinate2DMake(latitude!, longitude!)
            let currentLocation = MKMapItem.forCurrentLocation()
            let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: loc, addressDictionary: nil))
            //传入终点名称
            toLocation.name = destinationName
            MKMapItem.openMaps(with: [currentLocation, toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: NSNumber.init(booleanLiteral: true)])
        }
        actionSheet.addAction(appleAction)
        //utf-8编码
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "#")
        //腾讯地图
        if UIApplication.shared.canOpenURL(URL(string: "qqmap://")!) {
            let tencentAction = UIAlertAction(title: "腾讯地图", style: .default) { (action) in
                let tecentStr = String(format: "qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=&policy=0", lati, longi, destinationName)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: tecentStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: tecentStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!)
                }
                
            }
            actionSheet.addAction(tencentAction)
        }
        //高德地图
        if UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) {
            let gaodeAction = UIAlertAction(title: "高德地图", style: .default) { (action) in
                let urlStr = String(format: "iosamap://path?sourceApplication= &sid=&dlat=%f&dlon=%f&dname=%@", lati, longi, destinationName)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!)
                }
            }
            actionSheet.addAction(gaodeAction)
        }
        //百度地图
        if UIApplication.shared.canOpenURL(URL(string: "baidumap://")!) {
            let baiduAction = UIAlertAction(title: "百度地图", style: .default) { (action) in
                let urlStr = String(format: "baidumap://map/direction?origin={{我的位置}}&destination=name:%@|latlng:%f,%f&mode=driving&coord_type=gcj02", destinationName, lati, longi)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!, options: [:], completionHandler: nil)
                    
                } else {
                    UIApplication.shared.openURL(URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: charSet)!)!)
                    
                }
            }
            actionSheet.addAction(baiduAction)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        vc.present(actionSheet, animated: true, completion: nil)
    }
}
// MARK: tableview 数据源
extension SWMessagesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userMessagesList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return SWMessageTableViewCell.cellForTable(tableView, messaeInfo: self.userMessagesList[indexPath.row] as! SWMessageInfoModel, delegate: self)
    }

}
extension SWMessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dialogView = SWMessageDialogView.newInstance()
        dialogView?.messageInfoModel = self.userMessagesList[indexPath.row] as? SWMessageInfoModel
        dialogView?.delegate = self as SWMessageDialogViewDelegate
        self.view.addSubview(dialogView!)
    }
}


//MARK:SWMessageDialogViewDelegate
extension SWMessagesViewController: SWMessageDialogViewDelegate {
    func selectFunction(_ view: SWMessageDialogView, messageHandler handleType: Int) {
        switch handleType {
        case 0: // 查看详情
            view.removeFromSuperview()
            let letterVC = SecretLetterViewController.initViewController()
            letterVC.messageInfoModel = view.messageInfoModel
            letterVC.userCenter = userCenter
            letterVC.needPodHoom = false
            self.navigationController?.pushViewController(letterVC, animated: true)
           
        case 1: // 追踪
            view.removeFromSuperview()
            self.toMapApps(vc: self, latitude: Double(view.messageInfoModel?.placeLat ?? ""), longitude: Double(view.messageInfoModel?.placeLng ?? ""), destName: "")
            
        case 2: // 删除
            
            let alertController = UIAlertController(title: "温馨提示", message: "是否确定删除此条密语？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .destructive) { (action) in
                
                let parameters = ["messageId":view.messageInfoModel?.messageId,
                                  ] as! [String:Int]
                
                SWRequestManager.deleteMessage(parameters) {[weak self] (result, error) in
                    guard let strongSelf = self else { return }
                    strongSelf.deleteMessageHandler(result, error: error)
                }
                
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true) {
                
            }
            view.removeFromSuperview()
            
        case 3: // 取消
            view.removeFromSuperview()
            
        default:
            break
        }
    }
}

//MARK:HSCustomSearchBarDelegate
extension SWMessagesViewController: HSCustomSearchBarDelegate {
    
    func searchBarShouldReturn(_ searchBar: HSCustomSearchBar) {
        view.endEditing(true)
        searchKey = (searchBar.textField?.text)!
        self.requstData()
    }

}
//MARK:MKMapViewDelegate Delegate
extension SWMessagesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        userCenter = userLocation.coordinate
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        print("Fail to locate user. error: \(error)")
    }
    
    // annotationView点击事件（需设置annotation的title后才有效）
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let pinAnnotation = view.annotation as? SWMapAnnotation else { return }
        let index = pinAnnotation.tag - 100
        let model = userMessagesList[index] as! SWMessageInfoModel
        let letterVC = SecretLetterViewController.initViewController()
        letterVC.messageInfoModel = model
        letterVC.userCenter = userCenter
        letterVC.needPodHoom = false
        self.navigationController?.pushViewController(letterVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      
        guard let swMapAnnotation:SWMapAnnotation = annotation as? SWMapAnnotation else { return nil }
        let index = swMapAnnotation.tag - 100
        let userPhoto = annoImages[index]
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
    }

    
}

