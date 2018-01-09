//
//  OtheriCarouselView.m
//  豆蔓理财
//
//  Created by edz on 2016/12/19.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "OtheriCarouselView.h"
#import "GZVerticalProgressView.h"
#import "UILabel+DMLabel.h"
#define SelectColor MainGreen
#define UnselectColor LightGray

#define kImageWide DMDeviceWidth/5
#define kImageHeight 30

@interface OtheriCarouselView ()
{
    NSString *str1;
    
    NSString *settleStatus;
    NSString *settletitle;
    
    NSString *amountPrincipal;
    NSString *amountInterest;
}

@property (nonatomic, strong) UIImageView *layerView1;

@property (nonatomic, strong) GZVerticalProgressView *progressV;

@property (nonatomic, strong) UILabel *pregress;

@end

@implementation OtheriCarouselView


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
    
//    
//    _line = [[UILabel alloc] init];
//    _line.frame = CGRectMake(0, 50, DMDeviceWidth, 1);
//    _line.backgroundColor= UIColorFromRGB(0x5080aa);
//    [self addSubview:_line];
//    
//    
//    for (int u = 0; u < 10*_number; u++) {
//        UILabel *shortline = [[UILabel alloc] init];
//        shortline.frame = CGRectMake(0+DMDeviceWidth/_number/10*u, 45, 1, 5);
//        shortline.backgroundColor = UIColorFromRGB(0x5080aa);
//        [self addSubview:shortline];
//    }
//    for (int i = 0; i < _number; i ++) {
//        UILabel *longline = [[UILabel alloc] init];
//        longline.frame = CGRectMake((DMDeviceWidth/_number)/2+i*DMDeviceWidth/_number, 40, 1, 10);
//        longline.backgroundColor = UIColorFromRGB(0x50f1bf);
//        [self addSubview:longline];
//    }
//    
    
    
    
    _carousel = [[iCarousel alloc] init];
    _carousel.frame = CGRectMake(0, -20, DMDeviceWidth, 100);
    _carousel.delegate = self;
    _carousel.dataSource = self;
    [self addSubview:_carousel];
    
    [_carousel isWrapEnabled];
    _carousel.type = iCarouselTypeLinear;
    
    //创建maskLayer
    CALayer *maskLayer = [CALayer layer];
    //给maskLayer 设定frame
    maskLayer.frame = CGRectMake(0, -40, DMDeviceWidth, 95);

    
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
    UILabel *Label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {

        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth/ _number, 100)];


        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, DMDeviceWidth/_number, 20)];
        label.textColor = UnselectColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:11];
        label.tag = 1;
        [view addSubview:label];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, kImageWide, kImageHeight)];
        imageview.image = [UIImage imageNamed:@"rule"];

        
        Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, DMDeviceWidth/_number, 20)];
        Label.textColor = UnselectColor;
        Label.textAlignment = NSTextAlignmentCenter;
        Label.font = [label.font fontWithSize:11];
        Label.tag = 1;
        
        
        [view addSubview:imageview];
        [view addSubview:Label];
        
        
    }
    else
    {
        label = (UILabel *)[view viewWithTag:1];
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
    }

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
    
    [self.progressV setHidden:YES];
    [self.pregress setHidden:YES];
    for (int i = 0; i < self.dataArray.count; i ++) {
        UIView *view = [self.carousel itemViewAtIndex:i];
        UILabel *monthLabel = [view.subviews firstObject];
        UILabel *Label = [view.subviews lastObject];
        monthLabel.textColor = UnselectColor;
        Label.textColor = UnselectColor;
        
        for (UILabel *label in view.subviews) {
            label.transform = CGAffineTransformMakeScale(1, 1);
            Label.transform = CGAffineTransformMakeScale(1, 1);;
        }
    }
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    
    
    UILabel *label = nil;
    [self.progressV setHidden:NO];
    [self.pregress setHidden:NO];
    for (label in self.carousel.currentItemView.subviews) {
        UILabel *monthLabel = [self.carousel.currentItemView.subviews firstObject];
        UILabel *aLabel = [self.carousel.currentItemView.subviews lastObject];
        monthLabel.textColor = MainRed;
        aLabel.textColor = MainRed;
        aLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);
        monthLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);;
    }
    
    if (self.dataArray.count == 0) {
        
    }else{
    
        
        
        if ([[self.dataArray[carousel.currentItemIndex] objectForKey:@"settleStatus"] isEqual:[NSNumber numberWithInt:1]]) {
            settleStatus = @"月结收益";
            settletitle = @"本金回款";
            
            amountPrincipal = [_dataArray[carousel.currentItemIndex] objectForKey:@"settlePrincipal"];
            amountInterest = [_dataArray[carousel.currentItemIndex] objectForKey:@"settleInterest"];
        } else {
            settleStatus = @"待结收益";
            settletitle = @"待回本金";
            
            amountPrincipal = [_dataArray[carousel.currentItemIndex] objectForKey:@"noSettlePrincipal"];
            amountInterest = [_dataArray[carousel.currentItemIndex] objectForKey:@"noSettleInterest"];

        }

        
        NSNumber *a;
        NSNumber *b;
        
        
        
        
        
       
        if ([amountPrincipal isKindOfClass:[NSNull class]]) {
            a = @(1);
        } else {
            a = [NSNumber numberWithDouble:amountPrincipal.doubleValue];
        }
        
       
        
        if ([amountInterest isKindOfClass:[NSNull class]]) {
            b = @(1);
        } else {
            
            b = [NSNumber numberWithFloat:amountInterest.floatValue];
        }

        if (!amountPrincipal) {
            a = @(1);
        }
        if (!amountInterest) {
            b = @(1);
        }
        
        if (!settleStatus) {
            settleStatus = @"";
        }
        if (!settletitle) {
            settletitle = @"";
        }
        
        NSArray *values = @[a,b];
        NSArray *contents = @[a,b];
        NSArray *colors = @[MainGreen,MainRed];
        NSArray *titles = @[settletitle,settleStatus];
        NSString *settleAmount = [_dataArray[carousel.currentItemIndex] objectForKey:@"settleAmount"];
        
        if (a.doubleValue == 1) {
            contents = @[@(0),@(0)];
        } else {
            contents = @[a,b];
        }

        
            
            if ([[self.dataArray[carousel.currentItemIndex] objectForKey:@"settleStatus"] isEqual:[NSNumber numberWithInt:1]]) {
                 str1 =[NSString stringWithFormat:@"+%@\n当月已结",[_dataArray[carousel.currentItemIndex] objectForKey:@"settleAmount"]];
                
                if ([settleAmount isKindOfClass:[NSNull class]]) {
                    str1 = [NSString stringWithFormat:@"+0\n当月已结"];
                    
                }
                
                [self creatProgressVwith:values Colors:colors title:titles contents:contents];
                
            } else if ([[self.dataArray[carousel.currentItemIndex] objectForKey:@"settleStatus"] isEqual:[NSNumber numberWithInt:0]]){
                
                
                
                str1 =[NSString stringWithFormat:@"+%@\n当月待结",[_dataArray[carousel.currentItemIndex] objectForKey:@"settleAmount"]];
                
                if ([settleAmount isKindOfClass:[NSNull class]]) {
                    str1 = [NSString stringWithFormat:@"+0\n当月已结"];
                    
                }
                
                [self creatProgressVwith:values Colors:colors title:titles contents:contents];

            } else if ([[self.dataArray[carousel.currentItemIndex] objectForKey:@"settleStatus"] isEqual:[NSNumber numberWithInt:2]]){

                
                str1 =[NSString stringWithFormat:@"%@\n认购金额",[_dataArray[carousel.currentItemIndex] objectForKey:@"investAmount"]];
                [self createProgress];
            }
        
       
  

        
        [self Createscreen];

    }

    
}

- (void)Createscreen {

    
    if (self.screen) {
        [self.screen removeFromSuperview];
        self.screen = nil;
    }

    _screen = [[UIImageView alloc] init];
    CGFloat k = (DMDeviceWidth - 84*3 - 10)/2;
    _screen.frame = CGRectMake(5+1*(k+84)-6, -70+30, 100, 35);
//    _screen.image = [UIImage imageNamed:@"本金利息筛选框"];
    _screen.backgroundColor = [UIColor clearColor];
    [self addSubview:_screen];
    
    _screenL = [[UILabel alloc] init];
    _screenL.frame = CGRectMake(0, 0, 100, 35);
    _screenL.numberOfLines = 0;
    _screenL.textColor = MainRed;
    _screenL.font = SYSTEMFONT(11);
    _screenL.textAlignment = NSTextAlignmentCenter;
    
     NSRange range = [str1 rangeOfString:@"\n"];
    
    _screenL.attributedText = [self returnAttributeWithString:str1 range:range length:str1.length - range.location - 1 color:MainRed];
    
    [_screen addSubview:_screenL];
    
}


- (void)createProgress{
    
    if (self.pregress) {
        [self.pregress removeFromSuperview];
        self.pregress = nil;
    }
    if (self.progressV) {
        [self.progressV removeFromSuperview];
        self.progressV = nil;
    }
    
    self.pregress = [[UILabel alloc] init];
    _pregress.frame = CGRectMake((DMDeviceWidth/_number)/2+2*DMDeviceWidth/_number, 5, 1, 52);
    _pregress.backgroundColor = MainGreen;
    [self addSubview:_pregress];

    
}



- (void)creatProgressVwith:(NSArray *)value Colors:(NSArray *)color title:(NSArray *)title contents:(NSArray *)contents {
    if (self.progressV) {
        [self.progressV removeFromSuperview];
        self.progressV = nil;
    }
    if (self.pregress) {
        [self.pregress removeFromSuperview];
        self.pregress = nil;
    }
    
    self.progressV = [[GZVerticalProgressView alloc]initWithFrame:CGRectMake((DMDeviceWidth - 150)/2+.5, -7, 150, 67) values:value colors:color contents:contents titles:title];
    [self addSubview:self.progressV];
    
}

- (NSMutableAttributedString *)returnAttributeWithString:(NSString *)string range:(NSRange)range length:(NSInteger)length  color:(UIColor *)color{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],NSForegroundColorAttributeName:MainRed} range:NSMakeRange(0, range.location)];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:LightGray} range:NSMakeRange(range.location+1, length)];
    return attribute;
}

@end
