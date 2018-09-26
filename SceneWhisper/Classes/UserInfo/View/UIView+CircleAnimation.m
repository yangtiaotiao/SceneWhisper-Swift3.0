//
//  UIView+CircleAnimation.m
//  CircleAnimateDemo
//
//  Created by Yang on 2018/9/20.
//  Copyright © 2018年 qiuyu wang. All rights reserved.
//

#import "UIView+CircleAnimation.h"

@implementation UIView (CircleAnimation)



//创建环绕动画, 传入三个属性分别是 : 运动开始的角度(右侧90度为0), 运动结束的角度, 以及传入的是第几个物体
- (void)createCircleAnimationWithCircleCenter:(CGPoint)circleCenter offset:(CGFloat)offset{
    
    CGFloat origin_x = circleCenter.x;
    CGFloat origin_y = circleCenter.y;
    CGFloat radiusX = circleCenter.x;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    CGPoint point0 = CGPointMake(2 * origin_x, origin_y);
    NSValue *value0 = [NSValue valueWithCGPoint:point0];
    [array addObject:value0];
    
    CGPoint point1 = CGPointMake(origin_x, 2 * origin_y);
    NSValue *value1 = [NSValue valueWithCGPoint:point1];
    [array addObject:value1];
    
    CGPoint point2 = CGPointMake(0, origin_y);
    NSValue *value2 = [NSValue valueWithCGPoint:point2];
    [array addObject:value2];
    
    CGPoint point3 = CGPointMake(origin_x, 0);
    NSValue *value3 = [NSValue valueWithCGPoint:point3];
    [array addObject:value3];

    
    float startAngle;
    float endAngle;
    
    if (self.center.x > origin_x + 10) {
        startAngle = 0;
    } else if (self.center.y > origin_y + 10) {
        startAngle = 1;
    } else if (self.center.x < origin_x - 30) {
        startAngle = 2;
    } else {
        startAngle = 3;
    }
    endAngle = startAngle + offset;
    
    
    NSInteger index = endAngle >= 4 ? endAngle - 4 : endAngle;
    
    NSValue *tmpValue = array[index];
    CGPoint tmpPoint = [tmpValue CGPointValue];
    

    self.center = tmpPoint;
    
    //创建运动的轨迹动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 0.8 * (4 - offset);
    pathAnimation.repeatCount = 1;
    
    float radiuscale = 0.3;
    
    CGMutablePathRef ovalfromarc = CGPathCreateMutable();
    CGAffineTransform t2 = CGAffineTransformConcat(CGAffineTransformConcat(
                                                                           CGAffineTransformMakeTranslation(-origin_x, -origin_y),
                                                                           CGAffineTransformMakeScale(1, radiuscale)),
                                                   CGAffineTransformMakeTranslation(origin_x, origin_y));
    CGPathAddArc(ovalfromarc, &t2, origin_x, origin_y, radiusX,startAngle * 0.5 * M_PI,endAngle * 0.5 * M_PI, 1);
    pathAnimation.path = ovalfromarc;
    CGPathRelease(ovalfromarc);
    
    //设置运转的动画
    [self.layer addAnimation:pathAnimation forKey:@"moveTheCircleOne"];
    
   
}

@end
