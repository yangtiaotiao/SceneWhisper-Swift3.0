//
//  SWSecretKeySwitch.swift
//  SceneWhisper
//
//  Created by weipo 2017/9/8.
//  Copyright © 2017年 weipo. All rights reserved.
//  密信的秘钥开关

import UIKit

enum SWSwitchStyle {
    case NoBorder
    case Border
}

class SWSecretKeySwitch: UIControl {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var on: Bool = false
    
    var style: SWSwitchStyle = .NoBorder {
        
        willSet {}
        
        didSet {
            if style != oldValue {
                
                if style == .NoBorder {
                    onContentView?.backgroundColor = onTintColor
                    offContentView?.backgroundColor = offTintColor
                    borderView?.isHidden = true
                    borderView?.layer.borderColor = on ? onTintColor.cgColor : offTintColor.cgColor
                    if knobImageView?.image == nil {
                        knobView?.backgroundColor = thumbTintColor
                    } else {
                        knobView?.backgroundColor = .clear
                    }
                    onLabel?.textColor = onTextColor
                    offLabel?.textColor = offTextColor
                } else {
                    onContentView?.backgroundColor = .clear
                    offContentView?.backgroundColor = .clear
                    borderView?.isHidden = false
                    borderView?.layer.borderColor = on ? onTintColor.cgColor : offTintColor.cgColor
                    if knobImageView?.image == nil {
                        knobView?.backgroundColor = on ? onTintColor: offTintColor
                    } else {
                        knobView?.backgroundColor = .clear
                    }
                    onLabel?.textColor = onTintColor
                    offLabel?.textColor = offTintColor
                }
            }
        }
    }
    var onTintColor: UIColor = .green {
        
        willSet {}
        
        didSet {
            
            if style == .NoBorder {
                onContentView?.backgroundColor = onTintColor
            } else {
                if on == true {
                    borderView?.layer.borderColor = onTintColor.cgColor
                    if knobImageView?.image == nil {
                        knobView?.backgroundColor = onTintColor
                    } else {
                        knobView?.backgroundColor = .clear
                    }
                }
                onLabel?.textColor = onTintColor
            }
        }
    }
    var offTintColor: UIColor = .gray {
        
        willSet {}
        
        didSet {
            
            if style == .NoBorder {
                offContentView?.backgroundColor = offTintColor
            } else {
                if on == false {
                    borderView?.layer.borderColor = offTintColor.cgColor
                    
                    if knobImageView?.image == nil {
                        knobView?.backgroundColor = offTintColor
                    } else {
                        knobView?.backgroundColor = .clear
                    }
                }
                offLabel?.textColor = offTintColor
            }
        }
    }
    var thumbTintColor: UIColor = .white {
        
        willSet {}
        
        didSet {
            
            if style == .NoBorder {
                if knobImageView?.image == nil {
                    knobView?.backgroundColor = thumbTintColor
                } else {
                    knobView?.backgroundColor = .clear
                }

            }
        }
    }
    var onTextColor: UIColor = .white {
        
        willSet {}
        
        didSet {
            if style == .NoBorder {
                onLabel?.textColor = onTextColor
            }
        }
    }
    var offTextColor: UIColor = .black {
        
        willSet {}
        
        didSet {
            if style == .NoBorder {
                offLabel?.textColor = offTextColor
            }
        }
    }
    var textFont: UIFont?
    var onText: String = "" {
        
        willSet {}
        
        didSet {
            
            if self.onLabel != nil {
                self.onLabel?.text = onText
            }
            
        }
    }
    var offText: String = "" {
        
        willSet {}
        
        didSet {
            
            self.offLabel?.text = offText
        }
    }
    fileprivate var switchKnobSize: CGFloat = 17.0
    
    
    fileprivate var containerView: UIView?
    fileprivate var onContentView: UIView?
    fileprivate var offContentView: UIView?
    fileprivate var knobView: UIImageView?
    fileprivate var onLabel: UILabel?
    fileprivate var offLabel: UILabel?
    fileprivate var borderView: UIView?
    fileprivate var knobImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        switchKnobSize = frame.height - 1.0 * 2
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView?.frame = self.bounds
        let r = self.bounds.height / 2.0
        containerView?.layer.cornerRadius = r
        containerView?.layer.masksToBounds = true
        
        let margin = (self.bounds.height - switchKnobSize) / 2.0
        let containerWidth = containerView!.bounds.width
        let containerHeight = containerView!.bounds.height
        
        borderView?.frame = self.bounds
        borderView?.layer.borderWidth = 1.0
        borderView?.layer.cornerRadius = r
        borderView?.layer.masksToBounds = true
        
        if on == false {
            
            onContentView?.frame = CGRect(x: containerWidth * -1.0,
                                          y: 0.0,
                                          width: containerWidth,
                                          height: containerHeight)
            
            offContentView?.frame = CGRect(x: 0.0,
                                           y: 0.0,
                                           width: containerWidth,
                                           height: containerHeight)
            
            knobView?.frame = CGRect(x: margin,
                                     y: margin,
                                     width: switchKnobSize,
                                     height: switchKnobSize)
            
        } else {
            
            onContentView?.frame = CGRect(x: 0.0,
                                          y: 0.0,
                                          width: containerWidth,
                                          height: containerHeight)
            
            offContentView?.frame = CGRect(x: containerWidth,
                                           y: 0.0,
                                           width: containerWidth,
                                           height: containerHeight)
            
            knobView?.frame = CGRect(x: containerWidth - margin - switchKnobSize,
                                     y: margin,
                                     width: containerWidth,
                                     height: containerHeight)
            
        }
        
        let lHeight = self.bounds.height
        let lMargin = r - sqrt(pow(r, 2) - pow(lHeight / 2.0, 2)) + margin
        
        onLabel?.frame = CGRect(x: lMargin,
                                y: r - lHeight / 2.0,
                                width: containerWidth - lMargin - switchKnobSize - 2.0 * margin,
                                height: lHeight)
        offLabel?.frame = CGRect(x: switchKnobSize + 2.0,
                                 y: r - lHeight / 2.0,
                                 width: containerWidth - lMargin - switchKnobSize - 2.0 * margin,
                                 height: lHeight)
        
    }

    func setKnobImage(_ image: UIImage) {
        self.knobImageView?.image = image
        self.knobView?.backgroundColor = .clear // bug wait fix
    }
    
    func setOnStatus(_ onStatus: Bool) {
        setOn(onStatus, animated: false)
    }
    
    func setOn(_ onStatus: Bool, animated: Bool) {
        
        if on == onStatus {
            return
        }
        
        on = onStatus
        
        let margin = (self.bounds.height - switchKnobSize) / 2.0
        let onFrame = onContentView?.frame
        let offFrame = offContentView?.frame
        let knobFrame = knobView?.frame
        let containerWidth = containerView!.bounds.width
        let containerHeight = containerView!.bounds.height
        
        if on == false {
            
            onContentView?.frame = CGRect(x: containerWidth * -1.0,
                                          y: 0.0,
                                          width: containerWidth,
                                          height: containerHeight)
            
            offContentView?.frame = CGRect(x: 0.0,
                                           y: 0.0,
                                           width: containerWidth,
                                           height: containerHeight)
            
            knobView?.frame = CGRect(x: margin,
                                     y: margin,
                                     width: switchKnobSize,
                                     height: switchKnobSize)
            
            if style == .Border {
                borderView?.layer.borderColor = offTintColor.cgColor
                knobView?.backgroundColor = offTintColor
            }
            
        } else {
            
            onContentView?.frame = CGRect(x: 0.0,
                                          y: 0.0,
                                          width: containerWidth,
                                          height: containerHeight)
            
            offContentView?.frame = CGRect(x: containerWidth,
                                           y: 0.0,
                                           width: containerWidth,
                                           height: containerHeight)
            
            knobView?.frame = CGRect(x: containerWidth - margin - switchKnobSize,
                                     y: margin,
                                     width: switchKnobSize,
                                     height: switchKnobSize)
            
            if style == .Border {
                borderView?.layer.borderColor = onTintColor.cgColor
                knobView?.backgroundColor = onTintColor
            }
            
        }
        
        if animated {
            
            //on
            let animation1 = CABasicAnimation(keyPath: "bounds")
            animation1.fromValue = NSValue.init(cgRect: CGRect(x: 0.0, y: 0.0, width: onFrame!.width, height: onFrame!.height))
            animation1.toValue = NSValue.init(cgRect: CGRect(x: 0.0, y: 0.0, width: onContentView!.frame.width, height: onContentView!.frame.height))
            animation1.duration = 0.3
            animation1.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            onContentView?.layer.add(animation1, forKey: "")
            
            let animation2 = CABasicAnimation(keyPath: "position")
            animation2.fromValue = NSValue.init(cgPoint: CGPoint(x: onFrame!.midX, y: onFrame!.midY))
            animation2.toValue = NSValue.init(cgPoint: CGPoint(x: onContentView!.frame.midX, y: onContentView!.frame.midY))
            animation2.duration = 0.3
            animation2.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            onContentView?.layer.add(animation2, forKey: "")
            
            //off
            let animation3 = CABasicAnimation(keyPath: "bounds")
            animation1.fromValue = NSValue.init(cgRect: CGRect(x: 0.0, y: 0.0, width: offFrame!.width, height: offFrame!.height))
            animation1.toValue = NSValue.init(cgRect: CGRect(x: 0.0, y: 0.0, width: offContentView!.frame.width, height: offContentView!.frame.height))
            animation1.duration = 0.3
            animation1.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            offContentView?.layer.add(animation3, forKey: "")
            
            let animation4 = CABasicAnimation(keyPath: "position")
            animation2.fromValue = NSValue.init(cgPoint: CGPoint(x: offFrame!.midX, y: offFrame!.midY))
            animation2.toValue = NSValue.init(cgPoint: CGPoint(x: offContentView!.frame.midX, y: offContentView!.frame.midY))
            animation2.duration = 0.3
            animation2.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            offContentView?.layer.add(animation4, forKey: "")
            
            //knob
            let animation5 = CABasicAnimation(keyPath: "bounds")
            animation1.fromValue = NSValue.init(cgRect: CGRect(x: 0.0, y: 0.0, width: knobFrame!.width, height: knobFrame!.height))
            animation1.toValue = NSValue.init(cgRect: CGRect(x: 0.0, y: 0.0, width: knobView!.frame.width, height: knobView!.frame.height))
            animation1.duration = 0.3
            animation1.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            knobView?.layer.add(animation5, forKey: "")
            
            let animation6 = CABasicAnimation(keyPath: "position")
            animation2.fromValue = NSValue.init(cgPoint: CGPoint(x: knobFrame!.midX, y: knobFrame!.midY))
            animation2.toValue = NSValue.init(cgPoint: CGPoint(x: knobView!.frame.midX, y: knobView!.frame.midY))
            animation2.duration = 0.3
            animation2.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            knobView?.layer.add(animation6, forKey: "")
            
        }
        
    }
    
    func commonInit() {
        
        self.backgroundColor = .clear
        
        style = .NoBorder
        textFont = UIFont.systemFont(ofSize: 10.0)
        
        let ctView = UIView(frame: self.bounds)
        ctView.backgroundColor = .clear
        self.addSubview(ctView)
        containerView = ctView
        
        let borView = UIView(frame: CGRect.zero)
        borView.isUserInteractionEnabled = false
        borView.backgroundColor = UIColor(white: 0.9, alpha: 0.2)
        borView.layer.borderColor = on ? onTintColor.cgColor : offTintColor.cgColor
        borView.isHidden = (style == .NoBorder) ? true : false
        containerView?.addSubview(borView)
        borderView = borView
        
        let ocView = UIView(frame: self.bounds)
        ocView.backgroundColor = (style == .NoBorder) ? onTintColor : .clear
        containerView?.addSubview(ocView)
        onContentView = ocView
        
        let ofView = UIView(frame: self.bounds)
        ofView.backgroundColor = (style == .NoBorder) ? offTintColor : .clear
        containerView?.addSubview(ofView)
        offContentView = ofView
        
        let oLabel = UILabel(frame: CGRect.zero)
        oLabel.backgroundColor = .clear
        oLabel.textAlignment = .center
        oLabel.textColor = onTextColor
        oLabel.font = textFont
        oLabel.text = onText
        onContentView?.addSubview(oLabel)
        onLabel = oLabel
        
        let ofLabel = UILabel(frame: CGRect.zero)
        ofLabel.backgroundColor = .clear
        ofLabel.textAlignment = .center
        ofLabel.textColor = offTextColor
        ofLabel.font = textFont
        ofLabel.text = offText
        offContentView?.addSubview(ofLabel)
        offLabel = ofLabel
        
        let knView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: switchKnobSize, height: switchKnobSize))
        knView.backgroundColor = (style == .NoBorder) ? thumbTintColor : offTintColor
        knView.layer.cornerRadius = switchKnobSize / 2.0
        containerView?.addSubview(knView)
        knobView = knView
        
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: knobView!.frame.size))
        imageView.center = knobView!.center
        knobView?.addSubview(imageView)
        knobImageView = imageView
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizerEvent(_:)))
        self.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizerEvent(_:)))
        self.addGestureRecognizer(panGesture)
        
    }
    
    func handleTapGestureRecognizerEvent(_ recognizer: UITapGestureRecognizer) {
        
        if recognizer.state == .ended {
            setOn(!on, animated: true)
            self.sendActions(for: UIControlEvents.valueChanged)
        }
    }
    
    func handlePanGestureRecognizerEvent(_ recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            scaleKnobViewFrame(true)
            break
        case .failed, .cancelled:
            scaleKnobViewFrame(false)
            break
        case .changed:
            break
        case .ended:
            setOn(!on, animated: true)
            self.sendActions(for: UIControlEvents.valueChanged)
            break
        case .possible:
            break
        }
    }
    
    func scaleKnobViewFrame(_ scale: Bool) {
        
        let margin: CGFloat = (self.bounds.height - switchKnobSize) / 2.0
        let offset: CGFloat = 6.0
        let preFrame = knobView?.frame
        
        if on {
            knobView?.frame = CGRect(x: containerView!.bounds.width - switchKnobSize - margin - (scale ? offset : 0.0),
                                     y: margin,
                                     width: switchKnobSize + (scale ? offset : 0.0),
                                     height: switchKnobSize)
        } else {
            knobView?.frame = CGRect(x: margin,
                                     y: margin,
                                     width: switchKnobSize + (scale ? offset : 0.0),
                                     height: switchKnobSize)
        }
        
        let animation1 = CABasicAnimation(keyPath: "bounds")
        animation1.fromValue = NSValue.init(cgRect: CGRect(x: 0.0, y: 0.0, width: preFrame!.width, height: preFrame!.height))
        animation1.toValue = NSValue.init(cgRect: CGRect(x: 0.0, y: 0.0, width: knobView!.frame.width, height: knobView!.frame.height))
        animation1.duration = 0.3
        animation1.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        knobView?.layer.add(animation1, forKey: "")
        
        let animation2 = CABasicAnimation(keyPath: "position")
        animation2.fromValue = NSValue.init(cgPoint: CGPoint(x: preFrame!.midX, y: preFrame!.midY))
        animation2.toValue = NSValue.init(cgPoint: CGPoint(x: knobView!.frame.midX, y: knobView!.frame.midY))
        animation2.duration = 0.3
        animation2.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        knobView?.layer.add(animation2, forKey: "")
        
    }
    
}








