//
//  DMAmountInfoView.m
//  豆蔓理财
//
//  Created by edz on 2017/6/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMAmountInfoView.h"

#define kDefaultKayboardHeight 216.0f
@interface DMAmountInfoView ()

{
    CGFloat keyboardHeight;
}
@property (nonatomic, strong)ItemFourView *CalculateView;
@property (nonatomic, strong)NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign)CGFloat keyboardOriginY;

@property (nonatomic, copy)NSString *isOpenAccount; //是否开户成功

@end

@implementation DMAmountInfoView

- (instancetype)initWithIsOpenAccount:(NSString *)openAccount flag:(NSInteger)flag {
    self.isOpenAccount = openAccount;
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        keyboardHeight = kDefaultKayboardHeight;
        [self createviewOpenAccount:openAccount flag:flag];
        [self AddNotification];
    }
    return self;
}
- (void)createviewOpenAccount:(NSString *)openAccount flag:(NSInteger)flag{
    
    UIImage *iamge = [UIImage imageNamed:@"弹出框"];
    self.CalculateView  = [[ItemFourView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth - 104, (DMDeviceWidth - 104) * iamge.size.height / iamge.size.width + (iPhone5 ? 40 : 20)) isOpenAccount:openAccount flag:flag];
    self.CalculateView.center = CGPointMake(DMDeviceWidth / 2, DMDeviceHeight / 2);
    [self addSubview:self.CalculateView];
    __weak DMAmountInfoView *weakSelf = self;

    self.CalculateView.agreement = ^(NSInteger flagNumber){
        !weakSelf.jumpToAgreement ? : weakSelf.jumpToAgreement(flagNumber);
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
        [UIView animateWithDuration:0.2 animations:^{
            self.CalculateView.frame = alertFrame;
        }];
    }else {
        CGRect alertFrame = self.CalculateView.frame;
        alertFrame.origin.y = ([UIScreen mainScreen].bounds.size.height - alertFrame.size.height) / 2;
        [UIView animateWithDuration:0.2 animations:^{
            self.CalculateView.frame = alertFrame;
        }];
    }
}


- (void)showView {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.CalculateView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.CalculateView.alpha = 1;
    __weak DMAmountInfoView *weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
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

@interface ItemFourView ()

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UILabel *messageLabel;

@property (nonatomic, strong)UIImageView *statusImageView;

@property (nonatomic, copy)NSString *isOpenAccount;
@property (nonatomic, assign)NSInteger flagInfo;
@end

@implementation ItemFourView

- (instancetype)initWithFrame:(CGRect)frame isOpenAccount:(NSString *)openAccount flag:(NSInteger)flag{
    self.isOpenAccount = openAccount;
    self.flagInfo = flag;
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        [self textView:openAccount];
        if (flag == 0 || flag == 1) {
            //普通
            [self createFaildBtnWithFlag:flag];
        }else
            if (flag == 2) {
                //充值
                [self createTopUpBtnWithFlag:2];
            }else if (flag == 3) {
                [self buyToSuccess];
            }
        [self createCloseBtnWithFlag:flag];
    }
    return self;
}

- (void)setUp {
    
    UIImage *iamge = [UIImage imageNamed:@"弹出框"];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth - 104, (DMDeviceWidth - 104) * iamge.size.height / iamge.size.width + (iPhone5 ? 40 : 20))];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.cornerRadius = 10;
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.userInteractionEnabled = YES;
    [self addSubview:self.bottomView];
}

- (void)textView:(NSString *)string {
    
     CGFloat height = [self returenLabelHeight:string size:CGSizeMake(DMDeviceWidth - 144, 200) fontsize:14.f isWidth:NO];

    self.messageLabel = [UILabel createLabelFrame:CGRectMake(0, 0, DMDeviceWidth - 144, height) labelColor:UIColorFromRGB(0x929397) textAlignment:( height <= 20 ? NSTextAlignmentCenter :NSTextAlignmentLeft) textFont:14.f];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.center = CGPointMake(self.center.x, self.center.y - 20);
    self.messageLabel.text = string;
    [self.bottomView addSubview:self.messageLabel];
}

- (void)createCloseBtnWithFlag:(NSInteger)flag {
    UIImage *image = [UIImage imageNamed:@"关闭"];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundImage:image forState:(UIControlStateNormal)];
    [button setFrame:CGRectMake(LJQ_VIEW_Width(self.bottomView) - image.size.width - 10, 10, image.size.width, image.size.height)];
    [button addTarget:self action:@selector(closeViewAction:) forControlEvents:(UIControlEventTouchUpInside)];
    if (flag != 0) {
        [self.bottomView addSubview:button];
    }
}

- (void)createFaildBtnWithFlag:(NSInteger)flag {
    
    UIImage *image = [UIImage imageNamed:@"tanchuang_button_two"];
    UIButton *leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftButton.backgroundColor = UIColorFromRGB(0xffffff);
    [leftButton setFrame:CGRectMake((LJQ_VIEW_Width(self) - (LJQ_VIEW_Width(self) - 30) / 2) / 2, LJQ_VIEW_Height(self) - ((LJQ_VIEW_Width(self) - 30) / 2 * image.size.height / image.size.width) - 15, (LJQ_VIEW_Width(self) - 30) / 2, (LJQ_VIEW_Width(self) - 30) / 2 * image.size.height / image.size.width)];
    [leftButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [leftButton setBackgroundImage:image forState:(UIControlStateNormal)];
    leftButton.layer.cornerRadius = 8;
    [leftButton setTitleColor:UIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [leftButton addTarget:self action:@selector(confirmEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:leftButton];
}

- (void)createTopUpBtnWithFlag:(NSInteger)flag {
    
    UIImage *image = [UIImage imageNamed:@"tanchuang_button_two"];
    UIButton *leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftButton.backgroundColor = UIColorFromRGB(0xffffff);
    [leftButton setFrame:CGRectMake((LJQ_VIEW_Width(self) - (LJQ_VIEW_Width(self) - 30) / 2) / 2, LJQ_VIEW_Height(self) - ((LJQ_VIEW_Width(self) - 30) / 2 * image.size.height / image.size.width) - 15, (LJQ_VIEW_Width(self) - 30) / 2, (LJQ_VIEW_Width(self) - 30) / 2 * image.size.height / image.size.width)];
    [leftButton setTitle:@"充值" forState:(UIControlStateNormal)];
    [leftButton setBackgroundImage:image forState:(UIControlStateNormal)];
    leftButton.layer.cornerRadius = 8;
    [leftButton setTitleColor:UIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [leftButton addTarget:self action:@selector(confirmEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:leftButton];
}

- (void)buyToSuccess {
    
    UIImage *success = [UIImage imageNamed:@"buysuccessIconone"];
    UIImageView *pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, success.size.width, success.size.height)];
    pitcureView.center = CGPointMake(self.center.x, success.size.height / 2 - 20);
    pitcureView.image = success;
    [self addSubview:pitcureView];
    
    
    self.messageLabel.center = CGPointMake(self.center.x, success.size.height + 20);
    
    UIImage *image = [UIImage imageNamed:@"tanchuang_button_two"];
    UIButton *leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftButton.backgroundColor = UIColorFromRGB(0xffffff);
    [leftButton setFrame:CGRectMake((LJQ_VIEW_Width(self) - (LJQ_VIEW_Width(self) - 30) / 2) / 2, LJQ_VIEW_Height(self) - ((LJQ_VIEW_Width(self) - 30) / 2 * image.size.height / image.size.width) - 15, (LJQ_VIEW_Width(self) - 30) / 2, (LJQ_VIEW_Width(self) - 30) / 2 * image.size.height / image.size.width)];
    [leftButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [leftButton setBackgroundImage:image forState:(UIControlStateNormal)];
    leftButton.layer.cornerRadius = 8;
    [leftButton setTitleColor:UIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [leftButton addTarget:self action:@selector(confirmEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:leftButton];

}


//取消
- (void)confirmEvent:(UIButton *)sender {
    [self.superview removeFromSuperview];
   !self.agreement ? :self.agreement(self.flagInfo);
}

//关闭
- (void)closeViewAction:(UIButton *)sender {
    [self.superview removeFromSuperview];
}

- (CGFloat)returenLabelHeight:(NSString *)string size:(CGSize)size fontsize:(NSInteger)font isWidth:(BOOL)isWidth{
    CGRect rect = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    if (isWidth == YES) {
        return rect.size.width;
    }else {
        return rect.size.height;
    }
}


@end
