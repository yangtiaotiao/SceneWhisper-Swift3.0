//
//  SLBrowseBigImgControlle.m
//  tpllDemo
//
//  Created by Yang on 2018/5/17.
//  Copyright © 2018年 Yang. All rights reserved.
//

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#import "SWBrowseBigImgControlle.h"
#import "SWShowView.h"


@interface SWBrowseBigImgControlle ()

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *deleteLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;


@end

@implementation SWBrowseBigImgControlle

- (IBAction)goBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)deleteAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"要删除这张照片吗?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self.delegate respondsToSelector:@selector(SWBrowseBigImgDeleteImageIndex:)]) {
            [self.delegate SWBrowseBigImgDeleteImageIndex:self.from];
        }
        
        [self.navigationController popViewControllerAnimated:true]; 
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置删除按钮
    _deleteLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _deleteLabel.layer.borderWidth = 1.0;
    _deleteLabel.layer.cornerRadius = 2.5;
    
    // 添加SWShowView
    SWShowView *showView = [[SWShowView alloc] init];
    showView.img = self.showImage;
    showView.frame = self.view.bounds;
    [self.contentView addSubview:showView];

}

@end
