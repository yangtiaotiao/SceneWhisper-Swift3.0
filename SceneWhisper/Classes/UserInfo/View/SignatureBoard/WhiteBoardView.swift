//
//  WhiteBoardView.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/18.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit

class WhiteBoardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    //画笔的颜色
    var lineColor: UIColor?
    
    //是否是橡皮擦
    var isErase: Bool?
    
    var bezierPath: HSBezierPath?
    var bezierPathM: NSMutableArray?
    
    var headView: UIView?
    var bottomView: UIView?
    
    var selectColorEasyView: SelectColorEasyView?
    var selectColorPickerView: SelectColorPickerView?
    
    var btnSelectColor1: UIButton?
    var btnSelectColor2: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
//        self.addHeadBar()
//        self.addBottomBar()
        
        selectColorPickerView = SelectColorPickerView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.width))
        selectColorPickerView?.delegate = self
        selectColorPickerView?.isHidden = true
        self.addSubview(selectColorPickerView!)
        
        selectColorEasyView = SelectColorEasyView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height), colors: [UIColor.black, UIColor.red, UIColor.green, UIColor.blue, UIColor.gray, UIColor.yellow])
        selectColorEasyView?.delegate = self
        selectColorEasyView?.isHidden = true
        self.addSubview(selectColorEasyView!)
        
        bezierPathM = NSMutableArray()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addHeadBar() {
        
        headView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: 44.0))
        headView?.backgroundColor = UIColor.white
        self.addSubview(headView!)
        
        btnSelectColor1 = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: headView!.frame.width / 2.0 - 1.0, height: 44.0))
        btnSelectColor1?.setTitle("选色方案1", for: UIControlState.normal)
        btnSelectColor1?.addTarget(self, action: #selector(selectColorButton1Action(_:)), for: UIControlEvents.touchUpInside)
        btnSelectColor1?.backgroundColor = UIColor.orange
        headView?.addSubview(btnSelectColor1!)
        
        btnSelectColor2 = UIButton(frame: CGRect(x: headView!.frame.width / 2.0, y: 0.0, width: headView!.frame.width / 2.0, height: 44.0))
        btnSelectColor2?.setTitle("选色方案2", for: UIControlState.normal)
        btnSelectColor2?.addTarget(self, action: #selector(selectColorButton2Action(_:)), for: UIControlEvents.touchUpInside)
        btnSelectColor2?.backgroundColor = UIColor.orange
        headView?.addSubview(btnSelectColor2!)
        
    }
    
    func selectColorButton1Action(_ sender: UIButton) {
        
        selectColorPickerView?.isHidden = false
        selectColorPickerView?.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: 0.0)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.selectColorPickerView?.frame = CGRect(x: 0.0, y: 0.0, width: strongSelf.frame.width, height: strongSelf.frame.width)
        }
    }
    
    func selectColorButton2Action(_ sender: UIButton) {
        
        selectColorEasyView?.isHidden = false
        selectColorEasyView?.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.selectColorEasyView?.frame = CGRect(x: 0.0, y: 0.0, width: strongSelf.frame.width, height: 44.0)
        }
    }
    
    func addBottomBar() {
        
        bottomView = UIView(frame: CGRect(x: 0.0, y: self.frame.height - 49.0, width: self.frame.width, height: 49.0))
        bottomView?.backgroundColor = UIColor.black
        self.addSubview(bottomView!)
        
        let btnWidth = self.frame.width / 4.0
        let btnHeight = bottomView!.frame.height
        let btnPreviewAction = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: btnWidth, height: btnHeight))
        btnPreviewAction.setTitle("撤销", for: UIControlState.normal)
        btnPreviewAction.addTarget(self, action: #selector(btnPreviewActionClicked(_:)), for: UIControlEvents.touchUpInside)
        bottomView?.addSubview(btnPreviewAction)
        
        let btnCleanAll = UIButton(frame: CGRect(x: btnWidth, y: 0.0, width: btnWidth, height: btnHeight))
        btnCleanAll.setTitle("清空", for: UIControlState.normal)
        btnCleanAll.addTarget(self, action: #selector(btnCleanAllClicked(_:)), for: UIControlEvents.touchUpInside)
        bottomView?.addSubview(btnCleanAll)
        
        let btnEraser = UIButton(frame: CGRect(x: btnWidth * 2.0, y: 0.0, width: btnWidth, height: btnHeight))
        btnEraser.setTitle("橡皮擦", for: UIControlState.normal)
        btnEraser.addTarget(self, action: #selector(btnEraserClicked(_:)), for: UIControlEvents.touchUpInside)
        bottomView?.addSubview(btnEraser)
        
        let btnSave = UIButton(frame: CGRect(x: btnWidth * 3.0, y: 0.0, width: btnWidth, height: btnHeight))
        btnSave.setTitle("保存", for: UIControlState.normal)
        btnSave.addTarget(self, action: #selector(btnSaveClicked(_:)), for: UIControlEvents.touchUpInside)
        bottomView?.addSubview(btnSave)
        
    }
    
    func btnPreviewActionClicked(_ sender: UIButton) {
        if bezierPathM!.count > 0 {
            bezierPathM?.removeLastObject()
            self.setNeedsDisplay()
        }
    }
    
    func btnCleanAllClicked(_ sender: UIButton) {
        cleanAll()
    }
    
    func btnEraserClicked(_ sender: UIButton) {
        isErase = true
    }
    
    func cleanAll() {
        bezierPathM?.removeAllObjects()
        self.setNeedsDisplay()
    }
    
    func btnSaveClicked(_ sender: UIButton) {
        
        if !selectColorPickerView!.isHidden {
            selectColorPickerView?.isHidden = true
        }
        
        self.showHeadAndBottom(false)
        
        let currentImage = self.captureImageFromView(self)
        UIImageWriteToSavedPhotosAlbum(currentImage, self, #selector(imageSavedToPhotosAlbum(_:didFinishSavingWithError:contextInfo:)), nil)
        
        self.showHeadAndBottom(true)
        
    }
    
    func showHeadAndBottom(_ isShow: Bool) {
        headView?.isHidden = !isShow
        bottomView?.isHidden = !isShow
    }
    
    func captureImageFromView(_ view: UIView) -> UIImage {
        
        let screenRect = view.bounds
        
        UIGraphicsBeginImageContext(screenRect.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        view.layer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func imageSavedToPhotosAlbum(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        var message: String? = "保存失败"
        if error != nil {
            message = error!.description
        } else {
            message = "成功保存到相册"
        }
        print("Image saved to photos album message is \(String(describing: message))")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.backgroundColor = .clear
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let currentPoint = touch.location(in: self)
        
        bezierPath = HSBezierPath()
        bezierPath?.lineColor = lineColor
        bezierPath?.isErase = isErase
        bezierPath?.move(to: currentPoint)
        
        bezierPathM?.add(bezierPath!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let currentPoint = touch.location(in: self)
        
        let previousPoint = touch.previousLocation(in: self)
        let midPoint = self.midPoint(previousPoint, p1: currentPoint)
        
        bezierPath?.addQuadCurve(to: currentPoint, controlPoint: midPoint)
        self.setNeedsDisplay()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.backgroundColor = .clear
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let currentPoint = touch.location(in: self)
        
        let previousPoint = touch.previousLocation(in: self)
        let midPoint = self.midPoint(previousPoint, p1: currentPoint)
        
        bezierPath?.addQuadCurve(to: currentPoint, controlPoint: midPoint)
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if bezierPathM!.count > 0 {
            for i in 0..<bezierPathM!.count {
                let path = bezierPathM![i] as! HSBezierPath
                if path.isErase == true {
                    self.backgroundColor?.setStroke()
                } else {
                    path.lineColor?.setStroke()
                }
                
                path.lineCapStyle = CGLineCap.round
                path.lineJoinStyle = CGLineJoin.round
                
                if path.isErase == true {
                    path.lineWidth = 10.0
                    path.stroke(with: CGBlendMode.destinationIn, alpha: 1.0)
                } else {
                    path.lineWidth = 3.0
                    path.stroke(with: CGBlendMode.normal, alpha: 1.0)
                }
                path.stroke()
            }
        }
    }
    
    func midPoint(_ p0: CGPoint, p1: CGPoint) -> CGPoint {
        return CGPoint(x: (p0.x + p1.x) / 2.0, y: (p0.y + p1.y) / 2.0)
    }
}


extension WhiteBoardView: SelectColorPickerViewDelegate {
    
    func pickerView(_ view: SelectColorPickerView, didPickColor color: UIColor) {
        isErase = false
        lineColor = color
    }
}

extension WhiteBoardView: SelectColorEasyViewDelegate {
    
    func easyView(_ view: SelectColorEasyView, didSelectColor color: UIColor) {
        isErase = false
        lineColor = color
    }
}









