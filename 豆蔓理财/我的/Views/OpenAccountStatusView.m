//
//  OpenAccountStatusView.m
//  豆蔓理财
//
//  Created by mac on 2017/6/5.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "OpenAccountStatusView.h"
#define kDefaultKayboardHeight 216.0f
@interface OpenAccountStatusView ()

{
    CGFloat keyboardHeight;
}
@property (nonatomic, strong)ItemThreeView *CalculateView;
@property (nonatomic, strong)NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign)CGFloat keyboardOriginY;

@property (nonatomic, assign)NSInteger isOpenAccount; //是否开户成功

@end

@implementation OpenAccountStatusView

- (instancetype)initWithIsOpenAccount:(NSInteger)openAccount {
    self.isOpenAccount = openAccount;
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        keyboardHeight = kDefaultKayboardHeight;
        [self createviewOpenAccount:openAccount];
        [self AddNotification];
    }
    return self;
}
- (void)createviewOpenAccount:(NSInteger)openAccount {
    
    UIImage *iamge = [UIImage imageNamed:@"弹出框"];
    self.CalculateView  = [[ItemThreeView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth - 104, (DMDeviceWidth - 104) * iamge.size.height / iamge.size.width) isOpenAccount:openAccount];
    self.CalculateView.center = CGPointMake(DMDeviceWidth / 2, DMDeviceHeight / 2);
    [self addSubview:self.CalculateView];
    __weak OpenAccountStatusView *weakSelf = self;
    
    
    self.CalculateView.closeViewBlock = ^() {
        [weakSelf removeFromSuperview];
    };
    
    self.CalculateView.JumpToWeiShang = ^{
        !weakSelf.autoMicTransfer ? : weakSelf.autoMicTransfer();
    };
    
    self.CalculateView.agreement = ^{
        !weakSelf.jumpToAgreement ? : weakSelf.jumpToAgreement();
    };
}

- (void)AddNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardHeight = keyboardFrame.size.height;
    if (self.CalculateView.frame.origin.y != _keyboardOriginY) {
        [self resetAlertFrame];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    keyboardHeight = 0;
    [self resetAlertFrame];
}

- (void)resetAlertFrame {
    CGFloat bottom = [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.CalculateView.frame);
    if (bottom < keyboardHeight) {
        CGFloat moveY = keyboardHeight - bottom;
        CGRect alertFrame = self.CalculateView.frame;
        alertFrame.origin.y -= moveY;
        
        self.keyboardOriginY = alertFrame.origin.y;
        [UIView animateWithDuration:0.3f animations:^{
            self.CalculateView.frame = alertFrame;
        }];
    }else {
        CGRect alertFrame = self.CalculateView.frame;
        alertFrame.origin.y = ([UIScreen mainScreen].bounds.size.height - alertFrame.size.height) / 2;
        [UIView animateWithDuration:0.5 animations:^{
            self.CalculateView.frame = alertFrame;
        }];
    }
}


- (void)showView {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.CalculateView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.CalculateView.alpha = 1;
    __weak OpenAccountStatusView *weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakself.CalculateView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        weakself.alpha = 1.0;
    } completion:^(BOOL finished) {
        [weakself resetAlertFrame];
        
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [UIView animateWithDuration:0.5 animations:^{
    //        self.CalculateView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    //        self.CalculateView.alpha = 0;
    //    } completion:^(BOOL finished) {
    //        if (finished) {
    //            [self removeFromSuperview];
    //        }
    //    }];
}

- (void)dismissFromView {
    [UIView animateWithDuration:0.3 animations:^{
        self.CalculateView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.CalculateView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
}

- (void)dealloc {
    [self removeNotification];
}


@end

@interface ItemThreeView ()
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UILabel *messageLabel;

@property (nonatomic, strong)UIImageView *statusImageView;

@property (nonatomic, assign)NSInteger isOpenAccount;

@end

@implementation ItemThreeView

- (instancetype)initWithFrame:(CGRect)frame isOpenAccount:(NSInteger)openAccount{
    
    self.isOpenAccount = openAccount;
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        if (openAccount == 1 | openAccount == 3) {
            [self createButton];
        }else {
            [self createFaildBtn];
        }
        
        [self addSubview:self.messageLabel];
        [self addSubview:self.statusImageView];
        
        
        if (openAccount == 1) {
            //开户成功
            self.messageLabel.text = @"开户成功";
            [self.messageLabel setTextColor:UIColorFromRGB(0xfd9726)];
            [self.statusImageView setImage:[UIImage imageNamed:@"绑卡-确定"]];
        }else
            if (openAccount == 2) {
                self.messageLabel.text = @"开户失败";
                [self.messageLabel setTextColor:UIColorFromRGB(0x1bb182)];
                [self.statusImageView setImage:[UIImage imageNamed:@"失败"]];
            }else
                if (openAccount == 3) {
                    self.messageLabel.text = @"绑卡成功";
                    [self.messageLabel setTextColor:UIColorFromRGB(0xfd9726)];
                    [self.statusImageView setImage:[UIImage imageNamed:@"绑卡-确定"]];
                }else {
                    self.messageLabel.text = @"绑卡失败";
                    [self.messageLabel setTextColor:UIColorFromRGB(0x1bb182)];
                    [self.statusImageView setImage:[UIImage imageNamed:@"失败"]];
                }
 
    }
    return self;
}

- (void)setUp {
    
    UIImage *iamge = [UIImage imageNamed:@"弹出框"];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth - 104, (DMDeviceWidth - 104) * iamge.size.height / iamge.size.width)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.cornerRadius = 10;
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.userInteractionEnabled = YES;
    [self addSubview:self.bottomView];
}


- (UIImageView *)statusImageView {
    UIImage *image = [UIImage imageNamed:@"绑卡-确定"];
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DMDeviceWidth - 104 - image.size.width) / 2, 20, image.size.width, image.size.height)];
    }
    return _statusImageView;
}

- (UILabel *)messageLabel {
     UIImage *image = [UIImage imageNamed:@"绑卡-确定"];
    if (!_messageLabel) {
        _messageLabel = [UILabel createLabelFrame:CGRectMake(0, 34 + image.size.height, DMDeviceWidth - 104, 20) labelColor:UIColorFromRGB(0xfd9726) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
    }
    return _messageLabel;
}

- (void)createButton {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, LJQ_VIEW_Height(self) - 49, LJQ_VIEW_Width(self), 1)];
    line.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self addSubview:line];
    
    UIButton *leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftButton.backgroundColor = UIColorFromRGB(0xffffff);
    [leftButton setFrame:CGRectMake(0, LJQ_VIEW_Height(self) - 48, LJQ_VIEW_Width(self) / 2, 48)];
    [leftButton setTitle:@"取消" forState:(UIControlStateNormal)];
    leftButton.layer.cornerRadius = 8;
    [leftButton setTitleColor:UIColorFromRGB(0x929397) forState:(UIControlStateNormal)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [leftButton addTarget:self action:@selector(confirmAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightButton.backgroundColor = UIColorFromRGB(0xffffff);
    [rightButton setFrame:CGRectMake(LJQ_VIEW_Width(self) / 2, LJQ_VIEW_Height(self) - 48, LJQ_VIEW_Width(self) / 2, 48)];
    [rightButton setTitle:@"设置交易密码" forState:(UIControlStateNormal)];
    rightButton.layer.cornerRadius = 8;
    [rightButton setTitleColor:UIColorFromRGB(0xfd9726) forState:(UIControlStateNormal)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [rightButton addTarget:self action:@selector(setTradelAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:rightButton];
    
}

- (void)createFaildBtn {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, LJQ_VIEW_Height(self) - 49, LJQ_VIEW_Width(self), 1)];
    line.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self addSubview:line];
    
    UIButton *leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftButton.backgroundColor = UIColorFromRGB(0xffffff);
    [leftButton setFrame:CGRectMake(0, LJQ_VIEW_Height(self) - 48, LJQ_VIEW_Width(self), 48)];
    [leftButton setTitle:@"确定" forState:(UIControlStateNormal)];
    leftButton.layer.cornerRadius = 8;
    [leftButton setTitleColor:UIColorFromRGB(0x929397) forState:(UIControlStateNormal)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [leftButton addTarget:self action:@selector(confirmAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:leftButton];
}

- (void)setIsOpenAccount:(NSInteger)isOpenAccount {
    _isOpenAccount = isOpenAccount;
    if (_isOpenAccount == 1) {
        //开户成功
        self.messageLabel.text = @"开户成功";
        [self.messageLabel setTextColor:UIColorFromRGB(0xfd9726)];
        [self.statusImageView setImage:[UIImage imageNamed:@"绑卡-确定"]];
    }else
        if (_isOpenAccount == 2) {
            self.messageLabel.text = @"开户失败";
            [self.messageLabel setTextColor:UIColorFromRGB(0x1bb182)];
            [self.statusImageView setImage:[UIImage imageNamed:@"失败"]];
        }else
            if (_isOpenAccount == 3) {
            self.messageLabel.text = @"绑卡成功";
            [self.messageLabel setTextColor:UIColorFromRGB(0xfd9726)];
            [self.statusImageView setImage:[UIImage imageNamed:@"绑卡-确定"]];
        }else {
            self.messageLabel.text = @"绑卡失败";
            [self.messageLabel setTextColor:UIColorFromRGB(0x1bb182)];
            [self.statusImageView setImage:[UIImage imageNamed:@"失败"]];
        }
}

//取消
- (void)confirmAction:(UIButton *)sender {
     [self.superview removeFromSuperview];
    !self.agreement ? :self.agreement();
}

//设置交易密码
- (void)setTradelAction:(UIButton *)sender {
     !self.JumpToWeiShang ? : self.JumpToWeiShang();
}
@end
