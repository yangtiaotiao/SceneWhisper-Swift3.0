//
//  SWMeViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/6/13.
//  Copyright © 2017年 weipo. All rights reserved.
//  用户信息（头像）

import UIKit
import SDWebImage
import Alamofire
import IQKeyboardManagerSwift
import SVProgressHUD



class SWMeViewController: UIViewController {
    
    fileprivate var circleCenter: CGPoint! // 椭圆中心
    
 
    @IBOutlet var doneButton: UIButton!
    var infoEditType: Int = 0 //0:头像，1:签名，2:性别 3:名字
    var avatarImage: UIImage? //临时头像
    var infoMenuViewOriginalY: CGFloat = 0.0 //信息菜单的原始位置Y
    var signatureImage: UIImage? //临时的签名图片
    fileprivate var userName: String? // 用户名
    fileprivate var genders:Int = -1 // 性别
    // 用户信息模型
    var userInfoModel:SWUserInfoModel?
    
    @IBOutlet weak var sexButton: UIButton! //性别按钮
    @IBOutlet weak var avatrarButton: UIButton! //头像按钮
    @IBOutlet weak var signatureButton: UIButton! //签名按钮
    
    @IBOutlet var userNameButton: UIButton! // 用户名
    @IBOutlet weak var infoTitleLabel: UILabel! //信息标题
    
    @IBOutlet weak var infoFunctionButton: UIButton! //信息功能按钮
    @IBOutlet var userNameText: UITextField!
    @IBOutlet weak var infoTipsButton: UIButton! //信息提示按钮
    @IBOutlet weak var infoMenuView: UIView! //用户信息选择器
    
    //初始化viewController
    class func initViewController() -> SWMeViewController {
        return UIStoryboard.init(name: "UserInfo", bundle: nil).instantiateViewController(withIdentifier: "SWMeViewController") as! SWMeViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置完成按钮
        doneButton.layer.cornerRadius = 2
        doneButton.layer.borderWidth = 1
        doneButton.layer.borderColor = UIColor.white.cgColor
        doneButton.isEnabled = false
        
        // 椭圆中心
        circleCenter = CGPoint(x: 150*KScaleW, y: 45*KScaleW)
        
        //获取用户信息
        userInfoModel = SWDataManager.manager.currentUserInfo()
        
        //设置信息功能按钮
        infoFunctionButton.layer.masksToBounds = true
        infoFunctionButton.layer.cornerRadius = 158.0 * KScaleW / 2.0
  
        // 获取签名
        let signatureImageURL = URL.init(string: SWUrlHeader + (userInfoModel?.signatureUrl)!)
        guard let signatureImagedata = NSData(contentsOf: signatureImageURL!) else { return }
        signatureImage = UIImage(data: signatureImagedata as Data, scale: 1.0)
        
        // 用户名
        userName = userInfoModel?.nickName
        if userName != nil {
            userNameText.text = userName
        }
        userNameText.isHidden = true
        // 用户性别
        genders = (userInfoModel?.genders)!
        
        // 获取用户头像
        guard  let photoImageURL = URL.init(string: SWUrlHeader + (userInfoModel?.photo)!) else {return ;}
        let photoImagedata = NSData(contentsOf: photoImageURL)!
        avatarImage = UIImage(data: photoImagedata as Data, scale: 1.0)
        
        // 监听通知
        self.registerNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //设置用户头像
        if avatarImage != nil {
            infoFunctionButton.setBackgroundImage(avatarImage!, for: .normal)
        }
    }
    //MARK:监听键盘通知
    func registerNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow(_ :)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillHide(_ :)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    //MARK:键盘通知相关操作
    @objc func keyBoardWillShow(_ notification:Notification){
        
        DispatchQueue.main.async {
            self.view.center.y = KScreenHeight/2
            let user_info = notification.userInfo
            let keyboardRect = (user_info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let y = keyboardRect.origin.y
            let y2 = self.infoMenuView.frame.maxY
            let offset_y = y2 - y + 10
            
//            UIView.animate(withDuration: 0.25, animations: {
                self.view.center.y = self.view.center.y - offset_y
//            })
        }
    }
    
    @objc func keyBoardWillHide(_ notification:Notification){
        DispatchQueue.main.async {
            DispatchQueue.main.async {
//                UIView.animate(withDuration: 0.25, animations: {
                    self.view.center.y = KScreenHeight/2
//                })
            }
        }
    }
  
    //页面返回
    @IBAction func getbackButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    // 功能选择
    @IBAction func functionButtonDidClicked(_ sender: UIButton) {
        view.endEditing(true)
        var scale:CGFloat
        if (sender.center.x > circleCenter.x + 10.0) {
            scale = 3.0
        } else if (sender.center.y > circleCenter.y + 10.0) {
            scale = 2.0
        } else if (sender.center.x < circleCenter.x - 20.0) {
            scale = 1.0
        } else {
            scale = 0.0
        }
        
        sexButton.createCircleAnimation(withCircleCenter: circleCenter, offset: scale)//性别按钮1303
        avatrarButton.createCircleAnimation(withCircleCenter: circleCenter, offset: scale)//头像按钮1302
        signatureButton.createCircleAnimation(withCircleCenter: circleCenter, offset: scale)//签名按钮1301
        userNameButton.createCircleAnimation(withCircleCenter: circleCenter, offset: scale)// 用户名1304
        switch sender.tag {
        case 1301:
            self.signatButtonDidClicked(sender)
        case 1302:
            self.avatarButtonDidClicked(sender)
        case 1303:
            self.sexButtonDidClicked(sender)
        case 1304:
            self.userNameButtonDidClicked(sender)
        default:
            return
        }
        
    }
    //签名设置
    func signatButtonDidClicked(_ sender: UIButton) {
                if signatureImage == nil {
                    infoFunctionButton.setBackgroundImage(UIImage(named:"w个性签名"), for: .normal)
                } else {
                    infoFunctionButton.setBackgroundImage(signatureImage!, for: .normal)
                }
                infoTipsButton.setTitle("点击设置签名", for: .normal)
                infoTitleLabel.text = "签名"
                infoEditType = 1
        
                infoFunctionButton.isHidden = false
                userNameText.isHidden = true
    }
    //头像设置
    func avatarButtonDidClicked(_ sender: Any) {
        
        if avatarImage == nil {
            infoFunctionButton.setBackgroundImage(UIImage(named:"W头像圆"), for: .normal)
        } else {
            infoFunctionButton.setBackgroundImage(avatarImage!, for: .normal)
        }
        
        infoTipsButton.setTitle("点击变换头像", for: .normal)
        infoTitleLabel.text = "头像"
        infoEditType = 0
        
        infoFunctionButton.isHidden = false
        userNameText.isHidden = true
    }
    
    //性别设置
    func sexButtonDidClicked(_ sender: Any) {
        
        if genders == 0 {
            infoFunctionButton.setBackgroundImage(UIImage(named:"w男"), for: .normal)
        } else if genders == 1 {
            infoFunctionButton.setBackgroundImage(UIImage(named:"w女"), for: .normal)
        } else {
            infoFunctionButton.setBackgroundImage(UIImage(named:""), for: .normal)
        }
        
        infoTipsButton.setTitle("点击变换性别", for: .normal)
        infoTitleLabel.text = "性别"
        infoEditType = 2
        
        infoFunctionButton.isHidden = false
        userNameText.isHidden = true
    }
    //用户名设置
    func userNameButtonDidClicked(_ sender: UIButton) {
        infoTipsButton.setTitle("点击更换名字", for: .normal)
        infoTitleLabel.text = "名字"
        infoEditType = 3
        infoFunctionButton.isHidden = true
        userNameText.isHidden = false
    }
    //信息功能按钮事件处理
    @IBAction func infoFunctionButtonDidClicked(_ sender: Any) {
        
        if infoEditType == 0 { // 头像
            showInfoPickerView(0)
        } else if infoEditType == 1 { // 签名
            let sigBoard = SWSignatureBoardView(frame: self.view.frame, delegate: self)
            sigBoard.showFromView(self.view)
            infoMenuViewOriginalY = infoMenuView.frame.origin.y
            
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let strongSelf = self else { return }
                if #available(iOS 11.0, *) {
                    strongSelf.infoMenuView.frame.origin.y = UIScreen.main.bounds.height - 270.0 - strongSelf.infoMenuView.frame.height - (strongSelf.view.window?.safeAreaInsets.bottom)!
                } else {
                    strongSelf.infoMenuView.frame.origin.y = UIScreen.main.bounds.height - 270.0 - strongSelf.infoMenuView.frame.height
                }
            })
        } else if infoEditType == 2 { // 性别
            showInfoPickerView(1)
        }
    }
    
    //显示头像的采集选择器
    func showInfoPickerView(_ type: Int) {
        let pickView = SWUserInfoPickerView(frame: self.view.frame, infoType: type, delegate: self)
        pickView.showAtView(self.view)
    }
    
    //从照相机获取头像
    func pickAvatarToCamera() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true) {
            
        }
    }
    
    //从相册获取头像
    func pickAvatarToPhotoLibrary() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true) {
            
        }
    }
    
    //保存头像图
    func saveAvatarImage(_ image: UIImage) {
        
        let avatarImagePath = NSHomeDirectory() + "/Documents/AvatarImage/avatar.png"
        var success: Bool = false
        success = FileManager.default.fileExists(atPath: avatarImagePath)
        if success {
            do {
                try FileManager.default.removeItem(atPath: avatarImagePath)
            } catch {
                print("User avatar image remove failure!")
            }
        } else {
            var directory: ObjCBool = ObjCBool(false)
            let avatarFloder = NSHomeDirectory() + "/Documents/AvatarImage"
            let exists = FileManager.default.fileExists(atPath: avatarFloder, isDirectory: &directory)
            
            if exists && directory.boolValue {
                
            } else {
                try! FileManager.default.createDirectory(atPath: avatarFloder, withIntermediateDirectories: true, attributes: nil)
            }
        }
        
        do {
            try UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: avatarImagePath))
        } catch {
            print("User avatar image save failure! error:\(error)")
        }
        
        infoFunctionButton.setBackgroundImage(image, for: .normal)
        
    }
    
    //生成缩略图
    func thumbnailWithImage(_ image: UIImage, toSize: CGSize) -> UIImage? {
        
        let oldSize = image.size
        var rect : CGRect = CGRect(origin: .zero, size: oldSize)
        if toSize.width / toSize.height > oldSize.width / oldSize.height {
            rect.size.width = toSize.height * oldSize.width / oldSize.height
            rect.size.height = toSize.height
            rect.origin.x = (toSize.width - rect.size.width) / 2.0
            rect.origin.y = 0.0
        } else {
            rect.size.width = toSize.width
            rect.size.height = toSize.width * oldSize.height / oldSize.width
            rect.origin.x = 0.0
            rect.origin.y = (toSize.height - rect.size.height) / 2.0
        }
        UIGraphicsBeginImageContext(toSize)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        UIRectFill(CGRect(origin: .zero, size: toSize))
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
    //MARK:更新用户信息请求 - 完成
    @IBAction func doneButtonDidClick(_ sender: UIButton) {
        self.doneButton.isEnabled = false
        self.view.endEditing(true)
        /*
         userId 用户 Id Long
         nickName 昵称 Id String-没有修改时不传参数
         genders 性别 Int -1-无性别 0-男 1-女-没有修改时不传参 数
         signature 签名图片 file-没有修改时不传参数
         photo 头像图片 file-没有修改时不传参数
         */
        let parameters = ["userId":SWDataManager.currentUserId(),
                          "nickName":userName ?? "",
                          "genders":genders,
                          ] as [String:Any]
        
        let url = SWUrlHeader + "m/u/updateUserInfo"
        let headers = ["content-type":"multipart/form-data"]
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in parameters {
                    let valueStr = "\(value)"
                    multipartFormData.append(valueStr.data(using: String.Encoding.utf8)!, withName: key)
                }
                //头像
                if self.avatarImage != nil {
                    let avatarImageData = UIImageJPEGRepresentation(self.avatarImage!, 0.5)
                    multipartFormData.append(avatarImageData!, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpg/png/jpeg")
                }
                //签名
                if self.signatureImage != nil {
                    let signatureImageData = UIImageJPEGRepresentation(self.signatureImage!, 0.5)
                    multipartFormData.append(signatureImageData!, withName: "signature", fileName: "signature.jpg", mimeType: "image/jpg/png/jpeg")
                }
                
        },
            to: url,
            headers: headers,
            encodingCompletion: { encodingResult in
                SVProgressHUD.dismiss()
                switch encodingResult {
                case .success(let upload, _, _):
                    // 请求成功更新用户信息
                    upload.responseJSON { response in
                        let result: Dictionary<String, Any> = (response.value as! Dictionary<String, Any>)
                        let data = result["content"] as! Dictionary<String, Any>
                        let newUserInfoModel = SWUserInfoModel.init(userInfo: data)
                        SWDataManager().saveUserInfo(newUserInfoModel)
                    }
                    // 获取上传进度
                    upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                        print("图片上传进度: \(progress.fractionCompleted)")
                    }
                    SVProgressHUD.showSuccess(withStatus: "修改成功")
                case .failure(let encodingError):
                    // 失败原因
                    SVProgressHUD.showError(withStatus: (encodingError as! String))
                }
        })
        
    }
}


extension SWMeViewController: SWUserInfoPickerViewDelegate {
    
    func pickerView(_ view: SWUserInfoPickerView, didSelectedSexAtIndex index: Int) {
        
        if index == 1 {
            genders = 0
            infoFunctionButton.setBackgroundImage(UIImage(named:"w男"), for: .normal)
        } else {
            genders = 1
            infoFunctionButton.setBackgroundImage(UIImage(named:"w女"), for: .normal)
        }
        self.doneButton.isEnabled = true
    }
    
    func pickerView(_ view: SWUserInfoPickerView, didSelectedAvatarAtIndex index: Int) {
        
        if index == 1 {
            pickAvatarToCamera()
        } else {
            pickAvatarToPhotoLibrary()
        }
    }
}
//MARK: 照片选择 UIImagePickerControllerDelegate
extension SWMeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage]
        avatarImage = thumbnailWithImage(image as! UIImage, toSize: CGSize(width: 500.0, height: 500.0))
        //        avatarImage = image as? UIImage
        self.perform(#selector(saveAvatarImage(_:)), with: image, afterDelay: 0.5)
        picker.dismiss(animated: true, completion: nil)
        self.doneButton.isEnabled = true
    }
}

extension SWMeViewController: UINavigationControllerDelegate {
    
    
}
//MARK: 手写签名 SWSignatureBoardViewDelegate
extension SWMeViewController: SWSignatureBoardViewDelegate {
    
    func signatureViewDidDismiss(_ view: SWSignatureBoardView, image: UIImage?) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.infoMenuView.frame.origin.y = strongSelf.infoMenuViewOriginalY
        }
        if image != nil {
            signatureImage = image
            infoFunctionButton.setBackgroundImage(image, for: .normal)
            self.doneButton.isEnabled = true
        }
    }
    
}
//MARK: textFieldDelegate

extension SWMeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != userName {
            userName = textField.text
            self.doneButton.isEnabled = true
        }
    }
}
