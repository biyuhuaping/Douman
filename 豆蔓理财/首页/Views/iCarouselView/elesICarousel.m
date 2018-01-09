//
//  elesICarousel.m
//  豆蔓理财
//
//  Created by edz on 2016/12/29.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "elesICarousel.h"

#define SelectColor MainGreen
#define UnselectColor LightGray
#define kImageWide DMDeviceWidth/5
#define kImageHeight 30


@interface elesICarousel ()
@property (nonatomic, strong) UIView *midLine;

@property (nonatomic, strong) UIImageView *layerView1;

@end

@implementation elesICarousel



- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr {
    
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.dataArray = arr;
        
        
        self.number = 5;
        
        [self initView];
        
    }
    return self;
    
}



- (void)initView {
    
    _carousel = [[iCarousel alloc] init];
    _carousel.frame = CGRectMake(0, 0, DMDeviceWidth, 100);
    _carousel.delegate = self;
    _carousel.dataSource = self;
    [self addSubview:_carousel];
    
    [_carousel addSubview:self.midLine];
    [_carousel isWrapEnabled];
    _carousel.type = iCarouselTypeLinear;
    
    //创建maskLayer
    CALayer *maskLayer = [CALayer layer];
    //给maskLayer 设定frame
    maskLayer.frame = CGRectMake(0, -20, DMDeviceWidth, 100);
    
    UIImage *maskImage = [UIImage imageNamed:@"尺子蒙版"];
    
    //给图层的contents添加内容
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    
    
    [_carousel.layer setMask:maskLayer];
    [self.layer addSublayer:maskLayer];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_dataArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    UIView * upview= nil;
    UILabel *Label = nil;
    
    //create new view if no view is available for recycling
    
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth/ _number, 100)];

    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, DMDeviceWidth/_number, 20)];
    label.textColor = UnselectColor; 
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:11];

    label.tag = 1;
    
    Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, DMDeviceWidth/_number, 20)];
    Label.textColor = UnselectColor;
    Label.textAlignment = NSTextAlignmentCenter;
    Label.font = [label.font fontWithSize:11];
    [view addSubview:Label];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, kImageWide, kImageHeight)];
    imageview.image = [UIImage imageNamed:@"rule"];

    
    upview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, DMDeviceWidth/_number, 70)];
    
    UILabel *amountLable = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, DMDeviceWidth/_number, 20)];
    amountLable.textAlignment = NSTextAlignmentCenter;
    amountLable.font=  SYSTEMFONT(11);
    
    NSDictionary *dic = self.dataArray[index];
    if ([dic objectForKey:@"investAmount"]) {
        amountLable.text = [dic objectForKey:@"investAmount"];
    }else if ([dic objectForKey:@"monthAmount"]){
        amountLable.text = [dic objectForKey:@"monthAmount"];
    }else{
        amountLable.text = @"0";
    }
    amountLable.textColor = UnselectColor;
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake((DMDeviceWidth/_number - 60)/2, 20, 60, 2);
    line.textAlignment = NSTextAlignmentCenter;
    line.text = @"-------";
    line.textColor = UnselectColor;
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 25, DMDeviceWidth/_number, 20);
    lab.textAlignment = NSTextAlignmentCenter;
    
    if ([[self.dataArray[index] objectForKey:@"settleStatus"] isEqual:[NSNumber numberWithInt:1]]) {
        lab.text = @"已结利息";
    } else if ([[self.dataArray[index] objectForKey:@"settleStatus"] isEqual:[NSNumber numberWithInt:0]]){
        lab.text = @"预计收益";
    } else if ([[self.dataArray[index] objectForKey:@"settleStatus"] isEqual:[NSNumber numberWithInt:2]]) {
        lab.text = @"认购金额";
    }
    

    if ([[self.dataArray[0] objectForKey:@"panduan"] isEqualToString:@"1"]) {
        if (index == 0) {
            Label.text = @"计息日";
        }
    }
    
    if ([[self.dataArray[1] objectForKey:@"panduan"] isEqualToString:@"2"]){
        if (index == 0) {
            Label.text = @"认购日";
        } else if (index == 1) {
            Label.text = @"计息日";
        }
    }
        
    if (index == self.dataArray.count -1) {
        Label.text = @"到期结清";
        lab.text = @"还本付息";
    }
    

    lab.font=  SYSTEMFONT(11);
    lab.textColor = UnselectColor;
    
    
    [view addSubview:label];
    [view addSubview:upview];
    [view addSubview:imageview];
    
    [view addSubview:amountLable];
    [upview addSubview:line];
    [upview addSubview:lab];
    
     label.text = [self.dataArray[index] objectForKey:@"time"];
    if ([[self.dataArray[index] objectForKey:@"time"] isEqual:[NSNull null]]) {
        label.text = @"0";
    }
    
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
    for (int i = 0; i < self.dataArray.count; i ++) {
        UIView *view = [self.carousel itemViewAtIndex:i];
//        UILabel *monthLabel = [view.subviews firstObject];
//        UILabel *a = [view.subviews lastObject];
        
//        monthLabel.textColor = UnselectColor;
//        a.textColor = MainRed;
        for (UILabel *label in view.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                label.transform = CGAffineTransformMakeScale(1, 1);
                label.textColor = UnselectColor;
            }
    }
    }
}


- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    self.midLine.hidden = NO;
    
//    UILabel *label = nil;
    
    for (UILabel *label in self.carousel.currentItemView.subviews) {
//        UILabel *monthLabel = [self.carousel.currentItemView.subviews firstObject];
//        UILabel *a = [self.carousel.currentItemView.subviews lastObject];
//        UILabel *n = (UILabel *)[self.carousel.currentItemView viewWithTag:111111];
//        monthLabel.textColor = MainRed;
//        a.textColor = MainRed;
//        n.textColor = MainRed;
//        monthLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);
//        a.transform = CGAffineTransformMakeScale(1.3, 1.3);
//        n.transform = CGAffineTransformMakeScale(1.3, 1.3);
        
        if ([label isKindOfClass:[UILabel class]]) {
            label.transform = CGAffineTransformMakeScale(1.3, 1.3);
            label.textColor = MainRed;
        }
        
        
    }
}

- (UIView *)midLine{
    if (_midLine == nil) {
        self.midLine = [[UIView alloc]initWithFrame:CGRectMake((DMDeviceWidth-1)/2, 49, 1, 30)];
        _midLine.backgroundColor = SelectColor;
    }
    return _midLine;
}

@end
