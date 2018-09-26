//
//  YSShowView.m
//  SceneWhisper
//
//  Created by Yang on 2018/5/17.
//  Copyright © 2018年 weipo. All rights reserved.
//

#import "SWShowView.h"

@interface SWShowView () <UIScrollViewDelegate>

{
    CATransition *_animation;  //缩放动画效果
    CGFloat      _scaleNum;  //图片放大倍数
}

/** 显示的图片 */
@property (nonatomic, strong) UIImageView * imgView;

/** 用于捏合放大与缩小的scrollView */
@property(nonatomic,strong)UIScrollView *scrollview;

@end

@implementation SWShowView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _scaleNum = 1;
        [self createUI];
        [self addNotification];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.scrollview];
    [self.scrollview addSubview:self.imgView];
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    self.scrollview.contentSize = self.imgView.frame.size;
}

- (void)addNotification {
    // 双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imgWidth = _img.size.width;
    CGFloat imgHeight = _img.size.height;
    CGFloat showWidth = self.frame.size.width;
    CGFloat showHigth = self.frame.size.height;
    self.imgView.frame = CGRectMake(0, 0, showWidth, showWidth * imgHeight/imgWidth);
    self.imgView.center = CGPointMake(showWidth*0.5, showHigth*0.5);
    // 设置scrollView的frame
    self.scrollview.frame = CGRectMake(0, 0, showWidth, showHigth);
}

#pragma mark - 处理双击手势
- (void)handleDoubleTap:(UIGestureRecognizer *)sender {
    if (_scaleNum >= 1 && _scaleNum <= 2) {
        _scaleNum++;
    }else {
        _scaleNum = 1;
    }
    [self.scrollview setZoomScale:_scaleNum animated:YES];
}

#pragma mark - UIScrollViewDelegate,告诉scrollview要缩放的是哪个子控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}

#pragma mark - 等比例放大，让放大的图片保持在scrollView的中央
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"bounds:%@ -- contentSize:%@",NSStringFromCGRect(scrollView.bounds),NSStringFromCGSize(scrollView.contentSize));
    CGFloat offsetX = (self.scrollview.bounds.size.width > self.scrollview.contentSize.width)?(self.scrollview.bounds.size.width - self.scrollview.contentSize.width) *0.5 : 0.0;
    CGFloat offsetY = (self.scrollview.bounds.size.height > self.scrollview.contentSize.height)?
    (self.scrollview.bounds.size.height - self.scrollview.contentSize.height) *0.5 : 0.0;
    self.imgView.center = CGPointMake(self.scrollview.contentSize.width *0.5 + offsetX,self.scrollview.contentSize.height *0.5 + offsetY);
}


- (void)setImg:(UIImage *)img {
    _img = img;
    self.imgView.image = img;
    
    // 更新布局
    [self layoutSubviews];
}

#pragma mark - Lazy load
- (UIScrollView *)scrollview {
    if (!_scrollview) {
        //添加捏合手势，放大与缩小图片
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        //设置实现缩放
        //设置代理scrollview的代理对象
        _scrollview.delegate = self;
        //设置最大伸缩比例
        _scrollview.maximumZoomScale = 3;
        //设置最小伸缩比例
        _scrollview.minimumZoomScale = 1;
        [_scrollview setZoomScale:1 animated:NO];
        _scrollview.scrollsToTop = NO;
        _scrollview.scrollEnabled = YES;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.showsVerticalScrollIndicator = NO;
    }
    return _scrollview;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.userInteractionEnabled = true;
    }
    return _imgView;
}


@end
