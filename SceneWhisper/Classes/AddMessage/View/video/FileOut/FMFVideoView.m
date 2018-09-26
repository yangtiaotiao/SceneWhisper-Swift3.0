//
//  FMFVideoView.m
//  FMRecordVideo
//
//  Created by qianjn on 2017/3/12.
//  Copyright © 2017年 SF. All rights reserved.
//
//  Github:https://github.com/suifengqjn
//  blog:http://gcblog.github.io/
//  简书:http://www.jianshu.com/u/527ecf8c8753
#import "FMFVideoView.h"
#import "FMRecordProgressView.h"

@interface FMFVideoView ()<FMFModelDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *timelabel;
@property (nonatomic, strong) UIButton *turnCamera;
@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, strong) FMRecordProgressView *progressView;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, assign) CGFloat recordTime;

@property (nonatomic, strong, readwrite) FMFModel *fmodel;

@end

@implementation FMFVideoView

-(instancetype)initWithFMVideoViewType:(FMVideoViewType)type
{

    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self BuildUIWithType:type];
    }
    return self;
}

#pragma mark - view
- (void)BuildUIWithType:(FMVideoViewType)type
{
    
    self.fmodel = [[FMFModel alloc] initWithFMVideoViewType:type superView:self];
    self.fmodel.delegate = self;
    
    self.topView = [[UIView alloc] init];
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, 44);
    [self addSubview:self.topView];
    // 返回按钮
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(5, 14, 44, 44);
    [self.cancelBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.cancelBtn];
    // 标题
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"生成私语";
    titleLab.frame = CGRectMake((kScreenWidth - 132.0) * 0.5, 14, 132, 44);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    [self.topView addSubview:titleLab];
    
    // 显示时间
    self.timeView = [[UIView alloc] init];
    self.timeView.hidden = YES;
    self.timeView.frame = CGRectMake((kScreenWidth - 100)/2, (kScreenWidth-40)*1.5+10, 100, 34);
    self.timeView.backgroundColor = [UIColor colorWithRGB:0x242424 alpha:0.7];
    self.timeView.layer.cornerRadius = 4;
    self.timeView.layer.masksToBounds = YES;
    [self addSubview:self.timeView];
    
    UIView *redPoint = [[UIView alloc] init];
    redPoint.frame = CGRectMake(0, 0, 6, 6);
    redPoint.layer.cornerRadius = 3;
    redPoint.layer.masksToBounds = YES;
    redPoint.center = CGPointMake(25, 17);
    redPoint.backgroundColor = [UIColor redColor];
    [self.timeView addSubview:redPoint];
    
    self.timelabel =[[UILabel alloc] init];
    self.timelabel.font = [UIFont systemFontOfSize:13];
    self.timelabel.textColor = [UIColor whiteColor];
    self.timelabel.frame = CGRectMake(40, 8, 40, 28);
    [self.timeView addSubview:self.timelabel];
    
    // 闪光灯
    self.flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashBtn.frame = CGRectMake(30, kScreenHeight - 32 - 44, 36, 36);
    [self.flashBtn setImage:[UIImage imageNamed:@"zz闪光灯关"] forState:UIControlStateNormal];
    [self.flashBtn addTarget:self action:@selector(flashAction) forControlEvents:UIControlEventTouchUpInside];
    [self.flashBtn sizeToFit];
    [self addSubview:self.flashBtn];
    
    // 切换镜头
    self.turnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    self.turnCamera.frame = CGRectMake(kScreenWidth - 36 - 28, kScreenHeight - 32 - 44, 36, 36);
    [self.turnCamera setImage:[UIImage imageNamed:@"zz旋转"] forState:UIControlStateNormal];
    [self.turnCamera addTarget:self action:@selector(turnCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.turnCamera sizeToFit];
    [self addSubview:self.turnCamera];
    
    self.progressView = [[FMRecordProgressView alloc] initWithFrame:CGRectMake((kScreenWidth - 62)/2, kScreenHeight - 32 - 62, 62, 62)];
    self.progressView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.progressView];
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    self.recordBtn.frame = CGRectMake(5, 5, 52, 52);
    self.recordBtn.backgroundColor = [UIColor redColor];
    self.recordBtn.layer.cornerRadius = 26;
    self.recordBtn.layer.masksToBounds = YES;
    [self.progressView addSubview:self.recordBtn];
    [self.progressView resetProgress];
}

- (void)updateViewWithRecording
{
    self.timeView.hidden = NO;
//    self.topView.hidden = YES;
    // 拍摄过程中隐藏闪光和镜头切换按钮
    self.flashBtn.hidden = YES;
    self.turnCamera.hidden = YES;

    [self changeToRecordStyle];
}

- (void)updateViewWithStop
{
    self.timeView.hidden = YES;
//    self.topView.hidden = NO;
    self.flashBtn.hidden = NO;
    self.turnCamera.hidden = NO;
    [self changeToStopStyle];
}

- (void)changeToRecordStyle
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
        rect.size = CGSizeMake(28, 28);
        self.recordBtn.frame = rect;
        self.recordBtn.layer.cornerRadius = 4;
        self.recordBtn.center = center;
    }];
}

- (void)changeToStopStyle
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
        rect.size = CGSizeMake(52, 52);
        self.recordBtn.frame = rect;
        self.recordBtn.layer.cornerRadius = 26;
        self.recordBtn.center = center;
    }];
}
#pragma mark - action

- (void)dismissVC
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissVC)]) {
        [self.delegate dismissVC];
    }
}

- (void)turnCameraAction
{
     [self.fmodel turnCameraAction];
}

- (void)flashAction
{
    [self.fmodel switchflash];
}

- (void)startRecord
{
    if (self.fmodel.recordState == FMRecordStateInit) {
        [self.fmodel startRecord];
    } else if (self.fmodel.recordState == FMRecordStateRecording) {
        [self.fmodel stopRecord];
    } else if (self.fmodel.recordState == FMRecordStatePause) {
        
    }
    
}

- (void)reset
{
    [self.fmodel reset];
}

#pragma mark - FMFModelDelegate

- (void)updateFlashState:(FMFlashState)state
{
    if (state == FMFlashOpen) {
        [self.flashBtn setImage:[UIImage imageNamed:@"zz闪光灯"] forState:UIControlStateNormal];
    }
    if (state == FMFlashClose) {
        [self.flashBtn setImage:[UIImage imageNamed:@"zz闪光灯关"] forState:UIControlStateNormal];
    }
    
}


- (void)updateRecordState:(FMRecordState)recordState
{
    if (recordState == FMRecordStateInit) {
        [self updateViewWithStop];
        [self.progressView resetProgress];
    } else if (recordState == FMRecordStateRecording) {
        [self updateViewWithRecording];
    } else if (recordState == FMRecordStatePause) {
         [self updateViewWithStop];
    } else  if (recordState == FMRecordStateFinish) {
        [self updateViewWithStop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordFinishWithvideoUrl:)]) {
            [self.delegate recordFinishWithvideoUrl:self.fmodel.videoUrl];
        }
    }
}

- (void)updateRecordingProgress:(CGFloat)progress
{
    [self.progressView updateProgressWithValue:progress];
    self.timelabel.text = [self changeToVideotime:progress * RECORD_MAX_TIME];
    [self.timelabel sizeToFit];
}

- (NSString *)changeToVideotime:(CGFloat)videocurrent {
    
    return [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
    
}
@end
