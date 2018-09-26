//
//  KJCustomCameraController.m
//  Join
//
//  Created by JOIN iOS on 2017/9/1.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "KJCustomCameraController.h"
#import "FSKGPUImageBeautyFilter.h"
#import "KJPHAsset.h"
#import "KJAlbumModel.h"
#import "SWBrowseBigImgControlle.h"
#import "SVProgressHUD.h"
#import "SceneWhisper-Swift.h"


@interface imageButton : UIButton

@property (nonatomic, assign) BOOL hasImage;

@end

@implementation imageButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = kScreenWidth / 5 / 2;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        self.clipsToBounds = YES;
    }
    return self;
}


@end

typedef void(^PropertyChangeBlock)(AVCaptureDevice *kj_captureDevice);
@interface KJCustomCameraController ()<SWBrowseBigImgDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//图片显示

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

//拍摄完成图片
@property (strong, nonatomic) NSMutableArray *imgArray;
@property (strong, nonatomic) IBOutlet UIButton *nextStepBtn;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
//bottomView
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *btnLens;
@property (strong, nonatomic) IBOutlet UIButton *btnFlashlight;
@property (strong, nonatomic) UIButton *btnTake;
@property (strong, nonatomic) UIButton *btnReset;
@property (strong, nonatomic) IBOutlet UIButton *btnComplete;
@property (strong, nonatomic) IBOutlet UIButton *btnBeauty;

@property (assign, nonatomic) CGFloat focalLength;
@property (nonatomic) CGPoint startPoint;

@property (nonatomic, strong) GPUImageStillCamera *kj_imageCamera;

@property (nonatomic, strong) GPUImageView *kj_filterView;
//BeautifyFace美颜滤镜（默认开启美颜）
@property (nonatomic, strong) FSKGPUImageBeautyFilter *kj_beautifyFilter;
//裁剪1:1
@property (strong, nonatomic) GPUImageCropFilter *kj_cropFilter;
//滤镜组
@property (strong, nonatomic) GPUImageFilterGroup *kj_filterGroup;

@property (strong, nonatomic) imageButton *selectImgBtn;

@property (nonatomic, assign) NSInteger totalImgCount;
@end

@implementation KJCustomCameraController

- (void)dealloc {
    [self.kj_imageCamera stopCameraCapture];
    [self.kj_imageCamera removeInputsAndOutputs];
    [self.kj_imageCamera removeAllTargets];
    [self.kj_beautifyFilter removeAllTargets];
    [self.kj_cropFilter removeAllTargets];
    [self.kj_filterGroup removeAllTargets];
    self.kj_imageCamera = nil;
    self.kj_filterView = nil;
    self.kj_beautifyFilter = nil;
    self.kj_cropFilter = nil;
    self.kj_filterGroup = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //授权
    [KJUtility kj_cameraAuthorizationStatus:self completeBlock:^(BOOL allowAccess) {
    }];
    if (self.maxCount == 0) {
        self.maxCount = 1;
    }
    self.focalLength = 1;
 
    self.nextStepBtn.layer.cornerRadius = 2;
    self.nextStepBtn.layer.borderWidth = 1;
    self.nextStepBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self customSystemSession];
    
    //关闭闪光灯（默认）
    [self setFlashMode:AVCaptureFlashModeOff];
    
    self.imgView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pinch = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAction:)];
    [self.imgView addGestureRecognizer:pinch];
    
}


- (IBAction)goBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextStepAction:(UIButton *)sender {
    
    if(self.totalImgCount == 0) {
        [SVProgressHUD showErrorWithStatus:@"至少添加1张图片"];
        return;
    }
    
    NSMutableArray *imgDataArr = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) {
        NSInteger tagNum = 2000 + i;
        imageButton *button = [self.view viewWithTag:tagNum];
        if (button.hasImage == YES) {
            NSData *imageData = UIImagePNGRepresentation(button.imageView.image);
            [imgDataArr addObject:imageData];
        }
    }
   
    SWMessageSettingViewController *msVC = [SWMessageSettingViewController initViewController];
    msVC.photoDataArray = imgDataArr;
    [self.navigationController pushViewController:msVC animated:YES];
}


//相机设置
- (void)customSystemSession {

    self.imgView.layer.cornerRadius = (kScreenWidth-20)/2;
    self.imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imgView.layer.borderWidth = 2.0;
    self.imgView.clipsToBounds = YES;
 
    //美颜相机
    self.kj_imageCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    self.kj_imageCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.kj_imageCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.kj_filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenWidth-20)];
    self.kj_filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;

    [self.imgView addSubview:self.kj_filterView];

    //剪裁滤镜（1:1）
    self.kj_cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0, 0, 1, SCREEN_WIDTH/SCREEN_HEIGHT)];
    //美颜（默认开启美颜）
    self.kj_beautifyFilter = [[FSKGPUImageBeautyFilter alloc] init];
    self.kj_beautifyFilter.beautyLevel = 0.9f;//美颜程度
    self.kj_beautifyFilter.brightLevel = 0.7f;//美白程度
    self.kj_beautifyFilter.toneLevel = 0.9f;//色调强度
    //滤镜组
    self.kj_filterGroup = [[GPUImageFilterGroup alloc] init];
    [self.kj_filterGroup addFilter:self.kj_cropFilter];
    [self.kj_filterGroup addFilter:self.kj_beautifyFilter];

    [self openBeautify];
    [self.kj_imageCamera startCameraCapture];

}

#pragma mark - 按钮点击事件
//取消
- (void)onCancelAction:(UIButton *)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//前后镜头切换
- (IBAction)onSwitchingLens:(UIButton *)sender {
    AVCaptureDevice *captureDevice = self.kj_imageCamera.inputCamera;
    if ([captureDevice position] == AVCaptureDevicePositionBack) {//只有后置摄像头才有闪光灯
        [self setFlashMode:AVCaptureFlashModeOff];
        [self.btnFlashlight setImage:[UIImage imageNamed:@"zz闪光灯关"] forState:UIControlStateNormal];
    }
    [self.kj_imageCamera rotateCamera];
    if ([captureDevice position] == AVCaptureDevicePositionFront) {//从后置摄像头转换到前置
        [self setFlashMode:AVCaptureFlashModeOff];
        [self.btnFlashlight setImage:[UIImage imageNamed:@"zz闪光灯关"] forState:UIControlStateNormal];
    }
}

//闪光灯切换
- (IBAction)onFlashlightAction:(UIButton *)sender {
    AVCaptureDevice *captureDevice = self.kj_imageCamera.inputCamera;
    if ([captureDevice position] == AVCaptureDevicePositionBack) {//只有后置摄像头才有闪光灯
        AVCaptureFlashMode flashMode=captureDevice.flashMode;
        switch (flashMode) {
            case AVCaptureFlashModeOn:
                [self setFlashMode:AVCaptureFlashModeOff];
                [self.btnFlashlight setImage:[UIImage imageNamed:@"zz闪光灯关"] forState:UIControlStateNormal];
                break;
            case AVCaptureFlashModeOff:
                [self setFlashMode:AVCaptureFlashModeOn];
                [self.btnFlashlight setImage:[UIImage imageNamed:@"zz闪光灯"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}

//美颜
- (IBAction)onBeautyButtonAction:(UIButton *)sender {
    if (self.btnBeauty.selected) {
        //取消美颜
        [self closeBeautify];
    } else {
        //开启美颜
        [self openBeautify];
    }
    self.btnBeauty.selected = !self.btnBeauty.selected;
}

#pragma mark - 拍摄
- (IBAction)onTakeButtonAction:(UIButton *)sender {
    sender.enabled = NO;
    if (self.totalImgCount >= 4) {
        [SVProgressHUD showErrorWithStatus:@"最多添加4张照片"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        return;
    }
    //根据连接取得设备输出的数据
    WS(weakSelf)
    [self.kj_imageCamera capturePhotoAsJPEGProcessedUpToFilter:self.kj_imageCamera.targets.firstObject withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:processedJPEG];
            [weakSelf setImageButtonWithImage:image];
            weakSelf.totalImgCount +=1;
            weakSelf.pageControl.numberOfPages = weakSelf.totalImgCount;

        } else {
            [KJUtility showAllTextDialog:weakSelf.view Text:@"拍摄失败"];
        }
    }];
    sender.enabled = YES;
}
#pragma mark - 拍照完显示
- (void)setImageButtonWithImage:(UIImage *)image {
    
    for (int i = 0; i < 4; i++) {
        NSInteger tagNum = 2000 + i;
        imageButton *button = [self.view viewWithTag:tagNum];
        if (button.hasImage == NO) {
            [button setImage:image forState:UIControlStateNormal];
            button.hasImage = YES;
            break;
        }
    }
}
#pragma mark - 照片按钮点击
- (IBAction)imageButtonClickAction:(imageButton *)sender {
    if (sender.hasImage == YES) {
        SWBrowseBigImgControlle *browseBigImgVC = [[UIStoryboard storyboardWithName:@"AddMessage" bundle:nil] instantiateViewControllerWithIdentifier:@"SWBrowseBigImgControlle"];
        NSInteger index = sender.tag - 2000;
        browseBigImgVC.showImage = sender.imageView.image;
        browseBigImgVC.from = index;
        browseBigImgVC.delegate = self;
        [self.navigationController pushViewController:browseBigImgVC animated:YES];
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;//是否可以编辑
            //打开相册选择照片
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];

        } else {
            [SVProgressHUD showErrorWithStatus:@"请允许访问相册"];
        }
    }
    self.selectImgBtn = sender;
}
#pragma mark - 相册代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    _selectImgBtn.hasImage = YES;
    [_selectImgBtn setImage:image forState:UIControlStateNormal];
    _totalImgCount += 1;
    _pageControl.numberOfPages = _totalImgCount;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//焦距
- (void)onPanAction:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.startPoint = [sender locationInView:self.view];
    } else {
        CGPoint stopLocation = [sender locationInView:self.view];
        CGFloat dy = stopLocation.y - self.startPoint.y;
        if (sender.state == UIGestureRecognizerStateEnded) {
            self.focalLength -= (dy/100.0);
            if (self.focalLength > 3) {
                self.focalLength = 3;
            }
            if (self.focalLength < 1) {
                self.focalLength = 1;
            }
        } else {
            CGFloat focal = self.focalLength-dy/100.0;
            if (focal > 3) {
                focal = 3;
            }
            if (focal < 1) {
                focal = 1;
            }
            [CATransaction begin];
            [CATransaction setAnimationDuration:.025];
            NSError *error;
            if([self.kj_imageCamera.inputCamera lockForConfiguration:&error]){
                [self.kj_imageCamera.inputCamera setVideoZoomFactor:focal];
                [self.kj_imageCamera.inputCamera unlockForConfiguration];
            }
            else {
                NSLog(@"ERROR = %@", error);
            }
            
            [CATransaction commit];
        }
        NSLog(@"Distance: %f", dy);
    }
}

#pragma 相机相关设置
/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *kj_captureDevice) {
        if ([kj_captureDevice isFlashModeSupported:flashMode]) {
            [kj_captureDevice setFlashMode:flashMode];
            switch (flashMode) {
                case AVCaptureFlashModeAuto:
                    [kj_captureDevice setTorchMode:AVCaptureTorchModeAuto];
                    break;
                case AVCaptureFlashModeOn:
                    [kj_captureDevice setTorchMode:AVCaptureTorchModeOn];
                    break;
                case AVCaptureFlashModeOff:
                    [kj_captureDevice setTorchMode:AVCaptureTorchModeOff];
                    break;
                default:
                    break;
            }
        }
    }];
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice = self.kj_imageCamera.inputCamera;
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        //自动对焦
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        //自动曝光
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [captureDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
        //自动白平衡
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    } else {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

//开启美颜
- (void)openBeautify {
    [self.kj_filterGroup removeAllTargets];
    [self.kj_imageCamera removeAllTargets];
    [self.kj_beautifyFilter removeAllTargets];
    [self.kj_cropFilter removeAllTargets];
    
    //加上美颜滤镜
    [self.kj_cropFilter addTarget:self.kj_beautifyFilter];
    
    self.kj_filterGroup.initialFilters = @[self.kj_cropFilter];
    self.kj_filterGroup.terminalFilter = self.kj_beautifyFilter;
    
    [self.kj_imageCamera addTarget:self.kj_filterGroup];
    [self.kj_filterGroup addTarget:self.kj_filterView];
}

//关闭美颜
- (void)closeBeautify {
    [self.kj_filterGroup removeAllTargets];
    [self.kj_imageCamera removeAllTargets];
    [self.kj_beautifyFilter removeAllTargets];
    [self.kj_cropFilter removeAllTargets];
    
    self.kj_filterGroup.initialFilters = @[self.kj_cropFilter];
    self.kj_filterGroup.terminalFilter = self.kj_cropFilter;
    
    [self.kj_imageCamera addTarget:self.kj_filterGroup];
    [self.kj_filterGroup addTarget:self.kj_filterView];
}

//停止捕捉
- (void)kj_stopCameraCapture {
    if (self.kj_imageCamera) {
        [self.kj_imageCamera stopCameraCapture];
    }
    
}

//开启捕捉
- (void)kj_startCameraCapture {
    if (self.kj_imageCamera) {
        [self.kj_imageCamera startCameraCapture];
    }
}

#pragma mark - SWBrowseBigImgDelegate
- (void)SWBrowseBigImgDeleteImageIndex:(NSInteger)index {
    imageButton *button = [self.view viewWithTag:(index + 2000)];
    button.hasImage = NO;
    [button setImage:[UIImage imageNamed:@"zz增加"] forState:UIControlStateNormal];
    self.totalImgCount -= 1;
    self.pageControl.numberOfPages -= self.totalImgCount;
    self.btnComplete.enabled = YES;
}
#pragma mark - lazyLoad
- (NSMutableArray *)imgArray {
    if(!_imgArray) {
        _imgArray = [[NSMutableArray alloc] init];
    }
    return _imgArray;
}
@end
