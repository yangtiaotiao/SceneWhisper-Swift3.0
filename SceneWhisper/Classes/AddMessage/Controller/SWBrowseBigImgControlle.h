//
//  SLBrowseBigImgControlle.h
//  tpllDemo
//
//  Created by Yang on 2018/5/17.
//  Copyright © 2018年 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SWBrowseBigImgDelegate <NSObject>

/**
 代理方法
 */
- (void)SWBrowseBigImgDeleteImageIndex:(NSInteger)index;

@end

@interface SWBrowseBigImgControlle : UIViewController

/** 图片的数据源 */
@property (nonatomic, weak) UIImage *showImage;

/** 开始的下标 */
@property (nonatomic, assign) NSInteger from;


@property (nonatomic, weak) id<SWBrowseBigImgDelegate>delegate;
@end
