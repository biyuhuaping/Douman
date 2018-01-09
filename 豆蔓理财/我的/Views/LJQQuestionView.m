//
//  LJQQuestionView.m
//  豆蔓理财
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQQuestionView.h"
#define kDefaultKayboardHeight 216.0f
@interface LJQQuestionView ()

{
    CGFloat keyboardHeight;
}
@property (nonatomic, strong)ItemView *CalculateView;
@property (nonatomic, strong)NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign)CGFloat keyboardOriginY;


@end

@implementation LJQQuestionView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        keyboardHeight = kDefaultKayboardHeight;
        [self createview];
        [self AddNotification];
    }
    return self;
}
- (void)createview {
    
    UIImage *iamge = [UIImage imageNamed:@"弹出框"];
    self.CalculateView  = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth - 104, (DMDeviceWidth - 104) * iamge.size.height / iamge.size.width)];
    self.CalculateView.center = CGPointMake(DMDeviceWidth / 2, DMDeviceHeight / 2);
    [self addSubview:self.CalculateView];
    __weak LJQQuestionView *weakSelf = self;
    self.CalculateView.closeView = ^() {
        [weakSelf removeFromSuperview];
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

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.CalculateView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.CalculateView.alpha = 1;
    __weak LJQQuestionView *weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakself.CalculateView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        weakself.alpha = 1.0;
    } completion:^(BOOL finished) {
         [weakself resetAlertFrame];
        
    }];
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.5 animations:^{
        self.CalculateView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.CalculateView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)dismissFromView {
    [UIView animateWithDuration:0.5 animations:^{
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


@interface ItemView ()

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UILabel *messageLabel;
@end

@implementation ItemView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        [self createCloseBtn];
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
    
    self.messageLabel = [UILabel createLabelFrame:CGRectMake(0, 0, 0, 0) labelColor:UIColorFromRGB(0x929397) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
    self.messageLabel.numberOfLines = 0;
    [self.bottomView addSubview:self.messageLabel];
}

- (void)createCloseBtn {
    
    UIImage *image = [UIImage imageNamed:@"关闭"];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundImage:image forState:(UIControlStateNormal)];
    [button setFrame:CGRectMake(LJQ_VIEW_Width(self.bottomView) - image.size.width - 10, 10, image.size.width, image.size.height)];
    [button addTarget:self action:@selector(closeViewAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:button];
}

- (void)closeViewAction:(UIButton *)sender {
    
    !self.closeView ? : self.closeView();
}

- (void)layoutSubviews {
    NSString *string = @"转让人未到手的利息需要您先行垫付，下期回款时此部分利息返回您的个人账户。";
    CGFloat height = [self returenLabelHeight:string size:CGSizeMake(DMDeviceWidth - 144, 200) fontsize:14.f isWidth:NO];
    [self.messageLabel setFrame:CGRectMake(20, 0, DMDeviceWidth - 144, height)];
    self.messageLabel.text = string;
    [self.messageLabel setCenter:CGPointMake((DMDeviceWidth - 104) / 2, self.bottomView.center.y)];
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
