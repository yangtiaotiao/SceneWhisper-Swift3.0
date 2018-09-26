//
//  CoreTextArcView.h
//  SceneWhisper
//
//  Created by weipo 2017/7/12.
//  Copyright © 2017年 weipo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CoreTextArcView : UIView {
    
@private
    UIFont *            _font;
    NSString *          _string;
    CGFloat             _radius;
    UIColor *           _color;
    CGFloat             _arcSize;
    CGFloat             _shiftH, _shiftV; // horiz & vertical shift
    
    struct {
        unsigned int    showsGlyphBounds:1;
        unsigned int    showsLineMetrics:1;
        unsigned int    dimsSubstitutedGlyphs:1;
        unsigned int    reserved:29;
    }                   _flags;
    
}

@property(retain, nonatomic) UIFont *font;
@property(retain, nonatomic) NSString *text;
@property(readonly, nonatomic) NSAttributedString *attributedString;
@property(assign, nonatomic) CGFloat radius;
@property(nonatomic) BOOL showsGlyphBounds;
@property(nonatomic) BOOL showsLineMetrics;
@property(nonatomic) BOOL dimsSubstitutedGlyphs;
@property(retain, nonatomic) UIColor *color;
@property(nonatomic) CGFloat arcSize;
@property(nonatomic) CGFloat shiftH, shiftV;

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text radius:(float)radius arcSize:(float)arcSize color:(UIColor *)color;


@end
