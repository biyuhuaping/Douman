//
//  DMCalculateView.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/9/15.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMCalculateView.h"
#import "DMKeyBoard.h"
#import "iCarousel.h"
#import "DMCalculteManager.h"

#define Scale_Size(size) size*DMDeviceWidth/375


///**
// 收益方式
// - kPayInterestByMonth: 按月付息
// - kEqualAmountInterest: 等额本息
// */
//typedef NS_ENUM(NSUInteger, ProfitType) {
//    kPayInterestByMonth,
//    kEqualAmountInterest,
//};


@interface DMCalculateView ()<UITextFieldDelegate,iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) DMKeyBoard *keyBoard;
@property (nonatomic, strong) CustomTextField *amountField;
@property (nonatomic, strong) CustomTextField *rateField;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) UILabel *yuqishouyiLabel;

@property (nonatomic, strong)iCarousel *carousel;

@property (nonatomic, assign) ProfitType profitType;

@end

@implementation DMCalculateView

- (instancetype)initWithFrame:(CGRect)frame Type:(NSInteger)type Rate:(NSString *)rate Month:(NSInteger)month{
    self = [super initWithFrame:frame];
    if (self) {
        self.profitType = type;
        self.rateField.text = [rate stringByAppendingString:@"%"];
        self.carousel.currentItemIndex = month;
        
        self.frame = DMDeviceFrame;
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        [self createView];
    }
    return self;
}


- (void)cutType:(UIButton *)typeBtn{
    typeBtn.selected = YES;
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag != typeBtn.tag) {
            obj.selected = NO;
        }
    }];
    
    if (typeBtn.tag == 0) {
        self.profitType = kPayInterestByMonth;
    }else{
        self.profitType = kEqualAmountInterest;
    }
    
//#warning 按钮切换
    [self calculateProfit];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    self.keyBoard.textField = textField;
    return YES;
}

- (void)closeBtnAction:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.backView.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (DMKeyBoard *)keyBoard{
    if (!_keyBoard) {
        self.keyBoard = [[DMKeyBoard alloc] initWithFrame:CGRectMake(0, 310 , DMDeviceWidth - 25 , Scale_Size(160))];
        
        __weak __typeof(self) weakSelf = self;
        self.keyBoard.textfieldchange = ^{
//#warning textfieldchange
            [weakSelf calculateProfit];
        };
    }
    return _keyBoard;
}

- (CustomTextField *)amountField{
    if (!_amountField) {
        _amountField = [[CustomTextField alloc] initWithFrame:CGRectMake(80, 60, self.backView.bounds.size.width - 100, 30)];
        _amountField.font = FONT_Regular(14);
        _amountField.textColor = DarkGray;
        _amountField.layer.cornerRadius = 10;
        _amountField.layer.masksToBounds = YES;
        _amountField.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
        _amountField.layer.borderWidth = .5f;
        _amountField.delegate = self;
        [_amountField becomeFirstResponder];
    }
    return _amountField;
}

- (CustomTextField *)rateField{
    if (!_rateField) {
        _rateField = [[CustomTextField alloc] initWithFrame:CGRectMake(80, 160, 85, 30)];
        _rateField.delegate = self;
        _rateField.font = FONT_Regular(14);
        _rateField.textColor = DarkGray;
        _rateField.layer.cornerRadius = 10;
        _rateField.layer.masksToBounds = YES;
        _rateField.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
        _rateField.layer.borderWidth = .5f;
        _rateField.tag = 101;
    }
    return _rateField;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(12.5, DMDeviceHeight - (Scale_Size(160) + 310)- 10, DMDeviceWidth - 25, Scale_Size(160) + 310)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [@[] mutableCopy];
    }
    return _btnArray;
}

- (UILabel *)yuqishouyiLabel{
    if (!_yuqishouyiLabel) {
        _yuqishouyiLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, self.backView.bounds.size.height - Scale_Size(200), self.backView.bounds.size.width - 150, Scale_Size(40))];
        _yuqishouyiLabel.textAlignment = NSTextAlignmentRight;
        _yuqishouyiLabel.textColor = MainRed;
        _yuqishouyiLabel.font = FONT_Regular(18);
        _yuqishouyiLabel.text = @"0.00元";
    }
    return _yuqishouyiLabel;
}

- (void)createView {
    [self addSubview:self.backView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 44)];
    titleLabel.text = @"收益计算器";
    titleLabel.textColor = UIColorFromRGB(0x595757);
    titleLabel.font = FONT_Regular(17);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(self.backView.bounds.size.width - 50, 0, 50, 50);
    [closeButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backView addSubview:self.amountField];
    [self.backView addSubview:self.rateField];
    [self.backView addSubview:titleLabel];
    [self.backView addSubview:closeButton];
    
    NSArray *titleArray = @[@"投资金额",@"收益方式",@"年化利率"];
    for (int i = 0; i < 3; i ++) {
        UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60 + 50 * i, 100, 30)];
        tagLabel.text = titleArray[i];
        tagLabel.font = FONT_Regular(12);
        tagLabel.textColor = DarkGray;
        [self.backView addSubview:tagLabel];
    }
    
    NSArray *btnArray = @[@"按月付息",@"等额本息"];
    for (int i = 0; i < 2; i ++) {
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.tag = i;
        typeBtn.frame = CGRectMake(80 + 100*i, 110, 85, 30);
        [typeBtn setTitle:btnArray[i] forState:UIControlStateNormal];
        typeBtn.titleLabel.font = FONT_Regular(12);
        [typeBtn setBackgroundImage:[UIImage imageNamed:@"calculate_btnbkg"] forState:UIControlStateSelected];
        [typeBtn setBackgroundImage:[UIImage imageNamed:@"calculate_btnbkg"] forState:UIControlStateHighlighted];
        [typeBtn setBackgroundImage:[UIImage imageNamed:@"calculate_btnbkgunselect"] forState:UIControlStateNormal];
        [typeBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        [typeBtn setTitleColor:MainRed forState:UIControlStateNormal];
        if (i == self.profitType) {
            typeBtn.selected = YES;
        }
        [self.backView addSubview:typeBtn];
        [self.btnArray addObject:typeBtn];
        [typeBtn addTarget:self action:@selector(cutType:) forControlEvents:UIControlEventTouchUpInside
         ];
    }
    
    [self.backView addSubview:self.carousel];
    
    UIImageView *shadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 190, 50, 80)];
    shadowImage.image = [UIImage imageNamed:@"calcul_shaw"];
    [self.backView addSubview:shadowImage];
    UIImageView *rightshadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.backView.bounds.size.width-50, 190, 50, 80)];
    rightshadowImage.image = [UIImage imageNamed:@"calcul_shaw_right"];
    [self.backView addSubview:rightshadowImage];

    
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 100, 80)];
    monthLabel.text = @"产品期限";
    monthLabel.font = FONT_Regular(12);
    monthLabel.textColor = DarkGray;
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:monthLabel];
    
    
    UILabel *yuquLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.backView.bounds.size.height - Scale_Size(200), 100, Scale_Size(40))];
    yuquLabel.text = @"预期收益";
    yuquLabel.font = FONT_Regular(12);
    yuquLabel.textColor = DarkGray;
    [self.backView addSubview:yuquLabel];
    [self.backView addSubview:self.yuqishouyiLabel];
    [self.backView addSubview:self.keyBoard];

    self.backView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.backView.alpha = 0.01;
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.transform = CGAffineTransformMakeScale(1, 1);
        self.backView.alpha = 1;
    }];
}

- (iCarousel *)carousel{
    if (!_carousel) {
        _carousel = [[iCarousel alloc] init];
        _carousel.frame = CGRectMake(30, 190, DMDeviceWidth-30, 80);
        _carousel.type = iCarouselTypeLinear;
        _carousel.delegate = self;
        _carousel.dataSource = self;
        [_carousel isWrapEnabled];
    }
    return _carousel;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 12;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth/6, 70)];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, DMDeviceWidth/6, 50)];
    imageview.image = [UIImage imageNamed:@"calcul_rule"];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageview];
    
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , DMDeviceWidth/6, 40)];
    monthLabel.text = [NSString stringWithFormat:@"%zd个月",index+1];
    monthLabel.font = FONT_Regular(11);
    monthLabel.textColor = DarkGray;
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:monthLabel];

    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing){
        return value;
    }else if(option == iCarouselOptionWrap) {
        return YES; //是否循环
    }
    return value;
}

- (void)carouselDidScroll:(iCarousel *)carousel {
    [self.carousel.currentItemView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            obj.transform = CGAffineTransformMakeScale(1, 1);
            ((UILabel *)obj).textColor = DarkGray;
            ((UILabel *)obj).font = FONT_Regular(11);
        }
    }];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    [self.carousel.currentItemView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            obj.transform = CGAffineTransformMakeScale(1.5, 1.5);
            ((UILabel *)obj).textColor = MainRed;
            ((UILabel *)obj).font = FONT_Regular(12);
        }
    }];
    
//#warning 切换月份
    [self calculateProfit];
}

- (void)calculateProfit{
    NSString *profit = [[DMCalculteManager manager] calculatePorfitWithAmount:self.amountField.text Rate:self.rateField.text Type:self.profitType Month:[@(self.carousel.currentItemIndex+1) stringValue]];
    self.yuqishouyiLabel.text = [profit stringByAppendingString:@"元"];
    
    
    NSRange range = [self.yuqishouyiLabel.text rangeOfString:@"元"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.yuqishouyiLabel.text];
    [str addAttribute:NSFontAttributeName value:FONT_Regular(14) range:range];
    self.yuqishouyiLabel.attributedText = str;
}


@end
