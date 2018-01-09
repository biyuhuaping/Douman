//
//  DMPopUpWindowView.m
//  豆蔓理财
//
//  Created by edz on 2017/7/31.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMPopUpWindowView.h"
#define kDefaultKayboardHeight 216.0f
@interface DMPopUpWindowView ()

{
    CGFloat keyboardHeight;
}
@property (nonatomic, strong)DMPopUpView *popView;
@property (nonatomic, strong)NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign)CGFloat keyboardOriginY;

@property (nonatomic, strong)NSArray *messageArr; //

@end

@implementation DMPopUpWindowView

- (instancetype)initWithIsMessageStr:(NSArray *)MessageStr buttonTitle:(NSArray *)buttonTitle btnColorArr:(NSArray *)btnColorArr flag:(NSInteger)flag {
    self.messageArr = MessageStr;
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        keyboardHeight = kDefaultKayboardHeight;
        [self createviewOpenAccount:MessageStr btnTitle:buttonTitle btnColor:btnColorArr flag:flag];
        [self AddNotification];
    }
    return self;

}

- (void)createviewOpenAccount:(NSArray *)openAccount btnTitle:(NSArray *)btnTitle btnColor:(NSArray *)colorArr flag:(NSInteger)flag{
    
    UIImage *iamge = [UIImage imageNamed:@"弹出框"];
    self.popView  = [[DMPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth - 104, (DMDeviceWidth - 104) * iamge.size.height / iamge.size.width + (iPhone5 ? 40 : 20)) isOpenMessage:openAccount btnTitle:btnTitle btnColorArr:colorArr flag:flag];
    self.popView.center = CGPointMake(DMDeviceWidth / 2, DMDeviceHeight / 2);
    [self addSubview:self.popView];
    __weak DMPopUpWindowView *weakSelf = self;
    
    self.popView.agreement = ^(NSInteger flagNumber){
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
    if (self.popView.frame.origin.y != _keyboardOriginY) {
        [self resetAlertFrame];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    keyboardHeight = 0;
    [self resetAlertFrame];
}

- (void)resetAlertFrame {
    CGFloat bottom = [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.popView.frame);
    if (bottom < keyboardHeight) {
        CGFloat moveY = keyboardHeight - bottom;
        CGRect alertFrame = self.popView.frame;
        alertFrame.origin.y -= moveY;
        
        self.keyboardOriginY = alertFrame.origin.y;
        [UIView animateWithDuration:0.3f animations:^{
            self.popView.frame = alertFrame;
        }];
    }else {
        CGRect alertFrame = self.popView.frame;
        alertFrame.origin.y = ([UIScreen mainScreen].bounds.size.height - alertFrame.size.height) / 2;
        [UIView animateWithDuration:0.5 animations:^{
            self.popView.frame = alertFrame;
        }];
    }
}


- (void)showView {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.popView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.popView.alpha = 1;
    __weak DMPopUpWindowView *weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakself.popView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        weakself.alpha = 1.0;
    } completion:^(BOOL finished) {
        [weakself resetAlertFrame];
        
    }];
}



- (void)dismissFromView {
    [UIView animateWithDuration:0.3 animations:^{
        self.popView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.popView.alpha = 0;
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


@interface DMPopUpView ()

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UILabel *messageLabel;

@property (nonatomic, strong)UIImageView *statusImageView;

@property (nonatomic, strong)NSArray *messageArr;
@property (nonatomic, assign)NSInteger flagInfo;

@property (nonatomic, strong)NSArray *buttonTitleArr;
@property (nonatomic, strong)NSArray *btnColorArr;
@property (nonatomic, strong)NSMutableArray *buttonArr;
@end

@implementation DMPopUpView

- (instancetype)initWithFrame:(CGRect)frame isOpenMessage:(NSArray *)messageArr btnTitle:(NSArray *)btnTitle btnColorArr:(NSArray *)btnColorArr flag:(NSInteger)flag {
    self.messageArr = messageArr;
    self.buttonTitleArr = btnTitle;
    self.btnColorArr = btnColorArr;
    self.flagInfo = flag;
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        [self textView:messageArr];
        [self createCloseBtnWithFlag:flag];
        [self createBtnView];
    }
    return self;
}

- (void)createBtnView {
    UIImage *image = [UIImage imageNamed:@"tanchuang_button_two"];
    NSArray *imageArr = @[@"tanchuang_button_one",@"tanchuang_button_two"];
    for (int i = 0; i < self.buttonTitleArr.count; i++) {
        
        UIButton *Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        Button.backgroundColor = UIColorFromRGB(0xffffff);
        
        if (self.buttonTitleArr.count == 1) {
          [Button setFrame:CGRectMake((LJQ_VIEW_Width(self) - (LJQ_VIEW_Width(self) - 30) / 2) / 2, LJQ_VIEW_Height(self) - ((LJQ_VIEW_Width(self) - 30) / 2 * image.size.height / image.size.width) - 15, (LJQ_VIEW_Width(self) - 30) / 2, (LJQ_VIEW_Width(self) - 30) / 2 * image.size.height / image.size.width)];
        }else {
          [Button setFrame:CGRectMake( 10 + (LJQ_VIEW_Width(self) - 10 * (self.buttonTitleArr.count + 1)) / self.buttonTitleArr.count * i + 10 * i, LJQ_VIEW_Height(self) - ((LJQ_VIEW_Width(self) - 30) / 2 * image.size.height / image.size.width) - 15, (LJQ_VIEW_Width(self) - 30) / 2, (LJQ_VIEW_Width(self) - 30) / 2 * image.size.height / image.size.width)];
        }
        
        [Button setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:(UIControlStateNormal)];
        
        Button.layer.cornerRadius = 8;
        [Button setTitle:self.buttonTitleArr[i] forState:(UIControlStateNormal)];
        [Button setTitleColor:self.btnColorArr[i] forState:(UIControlStateNormal)];
        
        
        Button.titleLabel.font = FONT_Regular(16.f);
        [Button addTarget:self action:@selector(confirmEventAction:) forControlEvents:(UIControlEventTouchUpInside)];
        Button.tag = 1000 + i;
        
        
        [self addSubview:Button];
        [self.buttonArr addObject:Button];
    }
    
    for (int i = 1; i < self.buttonTitleArr.count; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(LJQ_VIEW_Width(self) / self.buttonTitleArr.count * i, LJQ_VIEW_Height(self) - 41, 1, 40)];
        [self addSubview:line];
    }
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

- (void)textView:(NSArray *)stringArr {
    UILabel *tishiLabel = [UILabel createLabelFrame:CGRectMake(0, 10, LJQ_VIEW_Width(self), 20) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:18.f];
    tishiLabel.text = stringArr[0];
    [self.bottomView addSubview:tishiLabel];
    
    CGFloat height = [self returenLabelHeight:stringArr[1] size:CGSizeMake(DMDeviceWidth - 144, 200) fontsize:14.f isWidth:NO];
    
    self.messageLabel = [UILabel createLabelFrame:CGRectMake(0, 0, DMDeviceWidth - 144, height) labelColor:UIColorFromRGB(0x929397) textAlignment:( height <= 20 ? NSTextAlignmentCenter :NSTextAlignmentLeft) textFont:14.f];
    self.messageLabel.center = CGPointMake(self.center.x, self.center.y - 20);
    self.messageLabel.numberOfLines = 0;
   
    
    if (self.flagInfo == 1) {
        NSString *string = stringArr[1];
        NSRange range1 = [string rangeOfString:@"省"];
        NSRange range2 = [string rangeOfString:@"元"];
        
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 2;
        paragraphStyle.paragraphSpacingBefore = 5;
        [attribute addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, string.length - 1)];
        [attribute addAttributes:@{NSFontAttributeName:FONT_Light(14.f),NSForegroundColorAttributeName:MainRed} range:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
        self.messageLabel.attributedText = attribute;
    }else {
         self.messageLabel.text = stringArr[1];
    }
    
    
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

- (void)setButtonTitleArr:(NSArray *)buttonTitleArr {
    if (_buttonTitleArr != buttonTitleArr) {
        _buttonTitleArr = buttonTitleArr;
    }
}

- (void)confirmEventAction:(UIButton *)sender {
    [self.superview removeFromSuperview];
    !self.agreement ? :self.agreement(sender.tag);
}

//关闭
- (void)closeViewAction:(UIButton *)sender {
    [self.superview removeFromSuperview];
}


- (CGFloat)returenLabelHeight:(NSString *)string size:(CGSize)size fontsize:(NSInteger)font isWidth:(BOOL)isWidth{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (self.flagInfo == 1) {
        paragraphStyle.lineSpacing = 10;
        paragraphStyle.paragraphSpacingBefore = 5.f;
    }
    
    CGRect rect = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    if (isWidth == YES) {
        return rect.size.width;
    }else {
        return rect.size.height;
    }
}

- (NSMutableArray *)buttonArr {
    if (!_buttonArr) {
        _buttonArr = [@[] mutableCopy];
    }
    return _buttonArr;
}

@end
