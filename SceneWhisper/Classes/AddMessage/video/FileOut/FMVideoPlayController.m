//
//  FMVideoPlayController.m
//  fmvideo
//
//  Created by qianjn on 2016/12/30.
//  Copyright © 2016年 SF. All rights reserved.
//  视频编辑页

#import "FMVideoPlayController.h"

#import <AVFoundation/AVFoundation.h>

#import "SceneWhisper-Swift.h"
#import "SVProgressHUD.h"

@interface FMVideoPlayController ()

@property (nonatomic, weak) AVPlayer *player;

@end

@implementation FMVideoPlayController

- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self createUI];
    [self buildNavUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.player) {
        [self.player play];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [self.player pause];
}
- (void)dealloc
{
    NSLog(@"FMVideoPlayController-dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)backAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"视频将不会被保存，是否确认退出？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)buildNavUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"video_play_nav_bg"];
    
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets inset = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
         imageView.frame = CGRectMake(0, inset.top, kScreenWidth, 44);
    } else {
         imageView.frame = CGRectMake(0, 0, kScreenWidth, 44);
    }
    imageView.userInteractionEnabled = YES;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(5, 0, 44, 44);
    [imageView addSubview:cancelBtn];
    
    UIButton *Done = [UIButton buttonWithType:UIButtonTypeCustom];
    [Done addTarget:self action:@selector(composeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    Done.titleLabel.font = [UIFont systemFontOfSize:9.0];
    [Done setTitle:@"下一步" forState:UIControlStateNormal];
    Done.frame = CGRectMake(kScreenWidth - 60, 15, 44, 20);
    Done.layer.borderColor = [UIColor whiteColor].CGColor;
    Done.layer.borderWidth = 1.0;
    Done.layer.cornerRadius = 2.5;
    [imageView addSubview:Done];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:imageView];
}
#pragma mark - 滤镜
- (void)createUI {
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:_videoUrl];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, (kScreenHeight-kScreenWidth)*0.5, kScreenWidth, kScreenWidth);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.view.layer addSublayer:playerLayer];
    
    [player play];
    self.player = player;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}
-(void)playbackFinished:(NSNotification *)notification{
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

#pragma mark - 下一步
- (void)composeBtnClick:(UIButton *)btn{
    SWMessageSettingViewController *msVC = [SWMessageSettingViewController initViewController];
    msVC.videoUrl = self.videoUrl;
    [self.navigationController pushViewController:msVC animated:YES];
}

@end

