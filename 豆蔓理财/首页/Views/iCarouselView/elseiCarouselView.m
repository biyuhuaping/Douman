//
//  elseiCarouselView.m
//  豆蔓理财
//
//  Created by edz on 2016/12/20.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "elseiCarouselView.h"
#import "DMCarPledgeListModel.h"
#import "GZVerticalProgressView.h"

#define SelectColor MainGreen
#define UnselectColor LightGray
#define kImageWide DMDeviceWidth/5
#define kImageHeight 30

@interface elseiCarouselView ()


@property (nonatomic, strong) UIView *midLine;
@property (nonatomic, strong) UIImageView *layerView1;

@property (nonatomic, strong) UIImageView *moneyView;
@property (nonatomic, strong) UILabel *moneyLabel1;
@property (nonatomic, strong) UILabel *moneyLabel2;

@property (nonatomic, strong) GZVerticalProgressView *progressV;

@end

@implementation elseiCarouselView

- (instancetype)initWithFrame:(CGRect)frame Type:(CreditType)type{
    
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.type = type;
        
        [self initView];
        
    }
    return self;
    
}

- (void)initView {
        
    _carousel = [[iCarousel alloc] init];
    _carousel.frame = CGRectMake(0, 0, DMDeviceWidth, 100);
    _carousel.type = iCarouselTypeLinear;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    [self addSubview:_carousel];
    
    
    [_carousel isWrapEnabled];
    
    //创建maskLayer
    CALayer *maskLayer = [CALayer layer];
    //给maskLayer 设定frame
    
    UIImage *maskImage = [UIImage imageNamed:@"尺子蒙版"];
    //给图层的contents添加内容
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    
    [_carousel.layer setMask:maskLayer];
    [self.layer addSublayer:maskLayer];
    
    if (self.type == CarInsurancePerson) {
        maskLayer.frame = CGRectMake(0, -50, DMDeviceWidth, 170);
        [self addSubview:self.moneyView];
        [self.moneyView addSubview:self.moneyLabel1];
        [self.moneyView addSubview:self.moneyLabel2];
    }else{
        maskLayer.frame = CGRectMake(0, -20, DMDeviceWidth, 140);
    }
    [_carousel addSubview:self.midLine];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    if (self.dataArray.count == 0) {
        return 6;
    }else{
        return self.dataArray.count;
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    DMCarPledgeListModel *listModel = nil;
    if (self.dataArray.count == 0) {
        
    }else{
         listModel = self.dataArray[index];
    }
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageWide, 100)];

    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, kImageWide, kImageHeight)];
    imageview.image = [UIImage imageNamed:@"rule"];

    
    
    UIView * upview= [[UIView alloc] initWithFrame:CGRectMake(0,  0, kImageWide, 70)];
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kImageWide,40)];
    
    UILabel *number = [[UILabel alloc] init];
    number.frame = CGRectMake(0, 0, kImageWide, 20);
    number.textAlignment = NSTextAlignmentCenter;
    number.font=  SYSTEMFONT(11);
    if (listModel) {
        number.text = [NSString stringWithFormat:@"%.2f",listModel.repayAmount];
    }else{
        number.text = @"0.00";
    }
    number.textColor = [UIColor grayColor];
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake((kImageWide - 60)/2, 20, 60, 2);
    line.textAlignment=NSTextAlignmentCenter;
    line.text = @"-------";
    line.textColor = [UIColor grayColor];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 25, kImageWide, 20);
    lab.textAlignment = NSTextAlignmentCenter;
    if (listModel.settleStatus) {
        if ([listModel.settleStatus isEqualToString:@"0"]) {
            lab.text = @"待还利息";
        }else if([listModel.settleStatus isEqualToString:@"1"]){
            lab.text = @"已还利息";
        }else{
            lab.text = @"放款计息";
        }
    }else{
        lab.text = @"--金额";
    }
    if (index == self.dataArray.count -1) {
        if ([listModel.settleStatus isEqualToString:@"1"]) {
            lab.text = @"已还本息";
        }else{
            lab.text = @"待还本息";
        }
    }
    
    lab.font=  SYSTEMFONT(11);
    lab.textColor = [UIColor grayColor];
    
    // 日期
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kImageWide, 20)];
    label.textColor = UnselectColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:11];
    label.tag = 1;
    if (listModel.dueDate) {
        label.text = listModel.dueDate;
    }else{
        label.text = @"-月-日";
    }
    UILabel *isAheadSettle = [[UILabel alloc] init];
    isAheadSettle.frame = CGRectMake(0, 20, kImageWide, 20);
    isAheadSettle.textAlignment = NSTextAlignmentCenter;
    isAheadSettle.font = [UIFont systemFontOfSize:11];
    isAheadSettle.textColor = UnselectColor;
    if (self.type == CarInsurancePerson) {
        if (listModel.isAheadSettle) {
            isAheadSettle.text = @"提前还款";
        }
        if (index == 0) {
            isAheadSettle.text = @"放款计息";
        }
        
    }
    if (index == self.dataArray.count - 1) {
        if (self.type == CarInsurancePerson){
            if (listModel.isAheadSettle == 1) {
                isAheadSettle.text = @"提前还款";
            }else{
                isAheadSettle.text = @"到期结清";
            }
        }else{
            isAheadSettle.text = @"本息还清";
        }
    }
    
    if (self.type == CarInsurancePerson) {

    }else{
        [view addSubview:upview];
    }
    
    [view addSubview:imageview];
    [view addSubview:buttomView];
    [upview addSubview:number];
    [upview addSubview:line];
    [upview addSubview:lab];
    
    [buttomView addSubview:label];
    [buttomView addSubview:isAheadSettle];
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value;
    } else if(option == iCarouselOptionWrap) {
        return NO;
    }
    return value;
}


- (void)carouselDidScroll:(iCarousel *)carousel {
    self.midLine.hidden = YES;
    [self.progressV removeFromSuperview];
    self.progressV = nil;
    for (UIView *view in self.carousel.currentItemView.subviews) {
        for (UILabel *label in view.subviews) {
            label.transform = CGAffineTransformMakeScale(1, 1);
            label.textColor = UnselectColor;
        }
    }
}


- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    
    if (self.type == CarInsurancePerson && carousel.currentItemIndex != 0) {
        self.midLine.hidden = YES;
    }else{
        self.midLine.hidden = NO;
    }
    for (UIView *view in self.carousel.currentItemView.subviews) {
        for (UILabel *label in view.subviews) {
            label.transform = CGAffineTransformMakeScale(1.5, 1.5);
            label.textColor = MainRed;
        }
    }
    
    if (self.dataArray.count == 0) {
        
    }else{
        DMCarPledgeListModel *listModel = self.dataArray[carousel.currentItemIndex];
        self.moneyLabel1.text = [NSString stringWithFormat:@"%.2f",listModel.repayAmount];
        if ([listModel.isSettled isEqualToString:@"1"]) {
            self.moneyLabel2.text = @"当月已还";
        }else if ([listModel.isSettled isEqualToString:@"0"]){
            self.moneyLabel2.text = @"当月待还";
        }else{
            self.moneyLabel2.text = @"放款金额";
        }
        
        if (self.type == CarInsurancePerson && carousel.currentItemIndex != 0) {
            NSArray *values = @[@(listModel.amountPrincipal),@(listModel.amountInterest)];
            NSArray *colors = @[listModel.isAheadSettle?UIColorFromRGB(0xfc6c6c):MainGreen,MainRed];
            NSArray *titles;
            if (listModel.amountInterest == 0) {
                titles = @[listModel.isAheadSettle?@"提前还款":@"已结本金",@"无待还利息"];
            }else{
                if ([listModel.isSettled isEqualToString:@"1"]) {
                    titles = @[listModel.isAheadSettle?@"提前还款":@"已结本金",@"已还利息"];
                }else{
                    titles = @[listModel.isAheadSettle?@"提前还款":@"待还本金",@"待还利息"];
                }
            }
            [self creatProgressVwith:values Colors:colors title:titles];
        }
    }
    
}

- (void)creatProgressVwith:(NSArray *)value Colors:(NSArray *)color title:(NSArray *)title{
    if (!self.progressV) {
        self.progressV = [[GZVerticalProgressView alloc]initWithFrame:CGRectMake((DMDeviceWidth - kImageWide)/2, 9, kImageWide, 70) values:value colors:color contents:value titles:title];
        [_carousel addSubview:self.progressV];
    }
}


- (NSArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [@[] copy];
    }
    return _dataArray;
}



- (UIView *)midLine{
    if (_midLine == nil) {
        if (self.type == CarInsurancePerson){
            self.midLine = [[UIView alloc]initWithFrame:CGRectMake((DMDeviceWidth-1)/2, 20, 1, 60)];
        }else{
            self.midLine = [[UIView alloc]initWithFrame:CGRectMake((DMDeviceWidth-1)/2, 50, 1, 30)];
        }
        _midLine.backgroundColor = SelectColor;
    }
    return _midLine;
}

- (UIImageView *)moneyView{
    if (_moneyView == nil) {
        self.moneyView = [[UIImageView alloc] initWithFrame:CGRectMake((DMDeviceWidth-85)/2, -45, 85, 28)];
//        _moneyView.image = [UIImage imageNamed:@"本金利息筛选框"];
    }
    return _moneyView;
}

- (UILabel *)moneyLabel1{
    if (_moneyLabel1 == nil) {
        self.moneyLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 14)];
        _moneyLabel1.text = @"0.00";
        _moneyLabel1.textColor = MainRed;
        _moneyLabel1.textAlignment = NSTextAlignmentCenter;
        _moneyLabel1.font = [UIFont systemFontOfSize:17];
    }
    return _moneyLabel1;
}

- (UILabel *)moneyLabel2{
    if (_moneyLabel2 == nil) {
        self.moneyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 85, 14)];
        _moneyLabel2.text = @"当月已结";
        _moneyLabel2.textColor = UnselectColor;
        _moneyLabel2.textAlignment = NSTextAlignmentCenter;
        _moneyLabel2.font = [UIFont systemFontOfSize:11];
    }
    return _moneyLabel2;
}


@end
