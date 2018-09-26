//
//  CoreTextArcView.swift
//  SceneWhisper
//
//  Created by weipo 2017/7/11.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit
import CoreText
import QuartzCore


struct SwiftArcFlags {
    var showsGlyphBounds: Bool
    var showsLineMetrics: Bool
    var dimsSubstitutedGlyphs: Bool
    var reserved: Int? = 29
}

struct SwiftGlyphArcInfo {
    var width: CGFloat
    var angle: CGFloat  // in radians
}

let ARCVIEW_DEBUG_MODE: Bool = false
let ARCVIEW_DEFAULT_FONT_NAME: String = "Helvetica"
let ARCVIEW_DEFAULT_FONT_SIZE: CGFloat = 24.0
let ARCVIEW_DEFAULT_RADIUS: CGFloat = -100.0
let ARCVIEW_DEFAULT_ARC_SIZE: CGFloat = -80.0

class SwiftCoreTextArcView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var font: UIFont?
    var string: String?
    var radius: CGFloat?
    var color: UIColor?
    var arcSize: CGFloat?
    var flags: SwiftArcFlags?
    var showsGlyphBounds: Bool?
    var showsLineMetrics: Bool?
    var dimsSubstitutedGlyphs: Bool?
    var text: String?
    var attributedString: NSAttributedString?
    var shiftH: CGFloat?
    var shiftV: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont(name: ARCVIEW_DEFAULT_FONT_NAME, size: ARCVIEW_DEFAULT_FONT_SIZE)
        self.text = "Curva Style Label"
        self.radius = ARCVIEW_DEFAULT_RADIUS
        self.showsGlyphBounds = false
        self.showsLineMetrics = false
        self.dimsSubstitutedGlyphs = false
        self.color = .gray
        self.arcSize = ARCVIEW_DEFAULT_ARC_SIZE
        self.shiftH = 0.0
        self.shiftV = 0.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, font: UIFont, text: String, radius: CGFloat, arcSize: CGFloat, color: UIColor) {
        
        self.init(frame: frame)
        
        self.font = font
        self.text = text
        self.radius = radius
        self.arcSize = arcSize
        self.color = color
        
    }
    
    func PrepareGlyphArcInfo(_ line: CTLine, glyphCount: CFIndex, glyphArcInfos: inout Array<SwiftGlyphArcInfo>, arcSizeRad: CGFloat) {
        
        let runArray = CTLineGetGlyphRuns(line) as! Array<Any>
        
        var glyphOffset: CFIndex = 0
        
        for run in runArray {
            
            let runGlyphCount = CTRunGetGlyphCount(run as! CTRun)
            
            for runGlyphIndex in 0..<runGlyphCount {
                glyphArcInfos[runGlyphIndex + glyphOffset].width = CGFloat(CTRunGetTypographicBounds(run as! CTRun, CFRangeMake(runGlyphIndex, 1), nil, nil, nil))
                glyphOffset += runGlyphCount
            }
        }
        
        let lineLength = CTLineGetTypographicBounds(line, nil, nil, nil)
        
        var prevHalfWidth = glyphArcInfos[0].width / 2.0
        
        glyphArcInfos[0].angle = (prevHalfWidth / CGFloat(lineLength)) * arcSizeRad
        
        for lineGlyphIndex in 1..<glyphCount {
            
            let halfWidth = glyphArcInfos[lineGlyphIndex].width / 2.0
            let prevCenterToCenter = prevHalfWidth + halfWidth
            
            glyphArcInfos[lineGlyphIndex].angle = (prevCenterToCenter / CGFloat(lineLength)) * arcSizeRad
            
            prevHalfWidth = halfWidth
        }
        
    }
    
    func getArcSize() -> CGFloat {
        return self.arcSize! * 180.0 / CGFloat.pi
    }
    
    func setArcSize(_ degress: CGFloat) {
        self.arcSize = degress * CGFloat.pi / 180.0
    }
    
    override func draw(_ rect: CGRect) {
        
        guard self.font != nil else {
            return
        }
        
        guard self.text != nil else {
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        
        var t0 = context?.ctm
        
        let xScaleFactor = (t0?.a)! > CGFloat(0) ? t0?.a : -(t0?.a)!
        
        let yScaleFactor = (t0?.d)! > CGFloat(0) ? t0?.d : -(t0?.d)!
        
        t0 = t0?.inverted()
        
        if xScaleFactor != 1.0 || yScaleFactor != 1.0 {
            t0 = t0?.scaledBy(x: xScaleFactor!, y: yScaleFactor!)
        }
        
        context?.concatenate(t0!)
        
        context?.textMatrix = CGAffineTransform.identity
        
        if ARCVIEW_DEBUG_MODE {
            context?.setFillColor(UIColor.black.cgColor)
            context?.fill(self.layer.bounds)
        }
        
        let attStr = self.attributedString
        
        let asr: CFAttributedString = attStr!
        
        let line = CTLineCreateWithAttributedString(asr)
        
        let glyphCount = CTLineGetGlyphCount(line)
        
        if glyphCount == 0 {
            return
        }
        
//        let glyphArcInfo: Array<GlyphArcInfo> = Array(repeating: GlyphArcInfo, count: glyphCount)
//        
//        
//        PrepareGlyphArcInfo(line, glyphCount: glyphCount, glyphArcInfos: glyphArcInfo, arcSizeRad: self.arcSize)
        
        
        
        
        
    }
    
}









