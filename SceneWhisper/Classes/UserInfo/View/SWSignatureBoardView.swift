//
//  SWSignatureBoardView.swift
//  SceneWhisper
//
//  Created by weipo 2017/10/10.
//  Copyright © 2017年 weipo. All rights reserved.
//  手写签名版View

import UIKit

@objc protocol SWSignatureBoardViewDelegate: NSObjectProtocol {
    
    @objc optional func signatureViewDidDismiss(_ view: SWSignatureBoardView, image: UIImage?)
    @objc optional func signatureView(_ view: SWSignatureBoardView, didSaveSignatureImage image: UIImage)
}


class SWSignatureBoardView: UIView {

    var cancelButton: UIButton?
    var okButton: UIButton?
    var board: WhiteBoardView?
    var contentView:UIView?
    
    weak var delegate: SWSignatureBoardViewDelegate?
    
    deinit {
        self.delegate = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubViews()
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, delegate: SWSignatureBoardViewDelegate) {
        self.init(frame: frame)
        self.delegate = delegate
        setupSubViews()
    }
    func setupSubViews() {
        
        self.backgroundColor = UIColor.clear
    
       
        //取消按钮
        let cancelBtn = UIButton(frame: self.frame)
        cancelBtn.backgroundColor = .clear
        self.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        
       
        //  contenview
        contentView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 260))
        contentView?.backgroundColor = UIColor.color(with: "#33334d", alpha: 1.0)
        self.addSubview(contentView!)

        //边框
        let backgroundView = UIView(frame: CGRect(x: 5.0, y: 5.0, width: self.frame.width - 10.0, height: 250))
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.layer.borderColor = UIColor.white.cgColor
        backgroundView.backgroundColor = .clear
        backgroundView.layer.borderWidth = 1.0
        contentView?.addSubview(backgroundView)
        
        // 手写
        let signatureBoard = WhiteBoardView(frame: CGRect(x: 5, y: 5, width: self.frame.width - 10, height: 250))
        signatureBoard.backgroundColor = .clear
        contentView?.addSubview(signatureBoard)
        board = signatureBoard
        
        let button1Frame = CGRect(x: 30.0, y:  215.0, width: 30.0, height: 30.0)
        let button1 = UIButton(frame: button1Frame)
        button1.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        button1.setBackgroundImage(UIImage(named: "w删除"), for: .normal)
        contentView?.addSubview(button1)
        cancelButton = button1
        
        let button2Frame = CGRect(x: self.frame.width - 60.0, y: 215.0, width: 30.0, height: 30.0)
        let button2 = UIButton(frame: button2Frame)
        button2.addTarget(self, action: #selector(okButtonAction(_:)), for: .touchUpInside)
        button2.setBackgroundImage(UIImage(named: "w保存"), for: .normal)
        contentView?.addSubview(button2)
        cancelButton = button2
    }

  
    
  func showFromView( _ view: UIView) {

        view.window?.addSubview(self)
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            guard let strongSelf = self else { return }
            if #available(iOS 11.0, *) {
                strongSelf.contentView?.frame.origin.y = strongSelf.frame.height - 260.0 - (view.window?.safeAreaInsets.bottom)!
            } else {
                strongSelf.contentView?.frame.origin.y = strongSelf.frame.height - 260.0
            }
        }) { (finished) in
            
        }
        
       
    }
    
    func okButtonAction(_ sender: UIButton) {
        let image = board?.captureImageFromView(board!)
//        saveSignatureImage(image!)
        board?.cleanAll()
        self.dismiss(image)
        
    }
    
    func cancelButtonAction(_ sender: UIButton) {
        board?.cleanAll()
        self.dismiss(nil)
    }
    
    
    func dismiss(_ currentImage: UIImage?) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView?.frame.origin.y = self.frame.height
        }) { [weak self] (finished) in
            guard let strongSelf = self else { return }
            if strongSelf.delegate != nil && strongSelf.delegate!.responds(to: #selector(SWSignatureBoardViewDelegate.signatureViewDidDismiss(_:image:))) {
                strongSelf.delegate!.signatureViewDidDismiss!(strongSelf, image: currentImage)
            }
            strongSelf.removeFromSuperview()
            
        }
        
    }
    
    // 保存签名图片在本地（暂不用）
    func saveSignatureImage(_ image: UIImage) {
        
        let signatureImagePath = NSHomeDirectory() + "/Documents/SignatureImage/signature.png"
        var success: Bool = false
        success = FileManager.default.fileExists(atPath: signatureImagePath)
        if success {
            do {
                try FileManager.default.removeItem(atPath: signatureImagePath)
            } catch {
                print("User signature image remove failure!")
            }
        } else {
            var directory: ObjCBool = ObjCBool(false)
            let avatarFloder = NSHomeDirectory() + "/Documents/SignatureImage"
            let exists = FileManager.default.fileExists(atPath: avatarFloder, isDirectory: &directory)
            
            if exists && directory.boolValue {
                
            } else {
                try! FileManager.default.createDirectory(atPath: avatarFloder, withIntermediateDirectories: true, attributes: nil)
            }
        }
        
        do {
            try UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: signatureImagePath))
        } catch {
            print("User signature image save failure! error:\(error)")
        }
        
    }
}




