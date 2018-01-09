//
//  AutomicTransferView.m
//  豆蔓理财
//
//  Created by mac on 2017/5/25.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "AutomicTransferView.h"
#define kDefaultKayboardHeight 216.0f

@interface AutomicTransferView ()

{
    CGFloat keyboardHeight;
}
@property (nonatomic, strong)ItemTwoView *CalculateView;
@property (nonatomic, strong)NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign)CGFloat keyboardOriginY;



@end

@implementation AutomicTransferView

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
    self.CalculateView  = [[ItemTwoView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth - 104, (DMDeviceWidth - 104) * iamge.size.height / iamge.size.width + 20)];
    self.CalculateView.center = CGPointMake(DMDeviceWidth / 2, DMDeviceHeight / 2);
    [self addSubview:self.CalculateView];
    __weak AutomicTransferView *weakSelf = self;
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
    __weak AutomicTransferView *weakself = self;
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

@interface ItemTwoView ()

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UILabel *messageLabel;

@property (nonatomic, strong)UIButton *selectedButton;
@end

@implementation ItemTwoView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        [self createCloseBtn];
        [self addSubview:[self createView]];
        [self createButton];
    }
    return self;
}

- (void)setUp {
    
    UIImage *iamge = [UIImage imageNamed:@"弹出框"];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth - 104, (DMDeviceWidth - 104) * iamge.size.height / iamge.size.width + 20)];
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
    
    UILabel *tishiLabel = [UILabel createLabelFrame:CGRectMake(image.size.width + 10, 10, (LJQ_VIEW_Width(self) - image.size.width * 2 - 20), 20) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:18.f];
    tishiLabel.text = @"提示";
    [self addSubview:tishiLabel];
}

- (UIView *)createView {
    UIImage *image = [UIImage imageNamed:@"勾选框"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, LJQ_VIEW_Height(self) - 80, self.frame.size.width, 20)];
    
    
    
    self.selectedButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.selectedButton setFrame:CGRectMake(0, 0, 0, 0)];
    self.selectedButton.selected = YES;
    [self.selectedButton setBackgroundImage:image forState:(UIControlStateNormal)];
    [self.selectedButton addTarget:self action:@selector(changestatus:) forControlEvents:(UIControlEventTouchUpInside)];

    UILabel *label = [UILabel createLabelFrame:CGRectMake(0, 0, 0, 13) labelColor:UIColorFromRGB(0x999999) textAlignment:(NSTextAlignmentLeft) textFont:12];
    label.numberOfLines = 0;
    NSString *string = [NSString stringWithFormat:@"阅读并同意《自动债权转让投标授权协议》"];
    NSRange range = [string rangeOfString:@"意"];
    label.attributedText = [self returnAttributeWithString:string range:range length:string.length - range.location - 1 color:UIColorFromRGB(0xfd9726)];
    
    CGFloat height = [self returenLabelHeight:string size:CGSizeMake(LJQ_VIEW_Width(self) / 6 * 5, 60) fontsize:12 isWidth:NO];
    CGFloat width = [self returenLabelHeight:string size:CGSizeMake(LJQ_VIEW_Width(self) / 6 * 5, 60) fontsize:12 isWidth:YES];
    [view setFrame:CGRectMake(0, LJQ_VIEW_Height(self) - 80, self.frame.size.width, height)];
    [self.selectedButton setFrame:CGRectMake((LJQ_VIEW_Width(self) - width - image.size.width - 4) / 2, (height - image.size.height) / 2, image.size.width, image.size.height)];
    label.enabledTapEffect = NO;
    [label DM_addAttributeTapActionWithStrings:@[@"《自动债权转让投标授权协议》"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        !self.agreement ? : self.agreement();
    }];
    
    [label setFrame:CGRectMake(LJQ_VIEW_MaxX(self.selectedButton) + 5, 0, width, height)];
    [view addSubview:self.selectedButton];
    [view addSubview:label];
    return view;
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
    [rightButton setTitle:@"确定" forState:(UIControlStateNormal)];
    rightButton.layer.cornerRadius = 8;
    [rightButton setTitleColor:UIColorFromRGB(0xfd9726) forState:(UIControlStateNormal)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [rightButton addTarget:self action:@selector(cancelAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:rightButton];
    
}

- (void)changestatus:(UIButton *)sender {
    
    if (sender.selected) {
        [sender setBackgroundImage:[UIImage imageNamed:@"未勾选框"] forState:(UIControlStateNormal)];
        sender.selected = !sender.selected;
    }else {
        [sender setBackgroundImage:[UIImage imageNamed:@"勾选框"] forState:(UIControlStateNormal)];
        sender.selected = !sender.selected;
    }
}

- (void)confirmAction:(UIButton *)sender {
    [self.superview removeFromSuperview];
}

- (void)cancelAction:(UIButton *)sender {
    

    if (self.selectedButton.selected) {
        !self.JumpToWeiShang ? : self.JumpToWeiShang();
    }else {
        ShowMessage(@"需要同意协议");
    }
}

- (void)closeViewAction:(UIButton *)sender {
    
    !self.closeViewBlock ? : self.closeViewBlock();
}

- (void)layoutSubviews {
    NSString *string = @"您还未签约自动债权转让投标授权协议，现在去签约。";
    CGFloat height = [self returenLabelHeight:string size:CGSizeMake(DMDeviceWidth - 144, 200) fontsize:14.f isWidth:NO];
    [self.messageLabel setFrame:CGRectMake(20, 0, DMDeviceWidth - 144, height)];
    self.messageLabel.text = string;
    [self.messageLabel setCenter:CGPointMake((DMDeviceWidth - 104) / 2, 45 + height / 2)];
}

- (NSMutableAttributedString *)returnAttributeWithString:(NSString *)string range:(NSRange)range length:(NSInteger)length  color:(UIColor *)color{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:color} range:NSMakeRange(range.location + 1, length)];
    return attribute;
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
