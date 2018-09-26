//
//  YSShowView.h
//  SceneWhisper
//
//  Created by Yang on 2018/5/17.
//  Copyright © 2018年 weipo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SingleTapBlock)(void);

@interface SWShowView : UIView

/** 显示的图片 */
@property (nonatomic, strong) UIImage * img;

/** 点击事件 */
@property (nonatomic, copy) SingleTapBlock tapBlock;

@end
