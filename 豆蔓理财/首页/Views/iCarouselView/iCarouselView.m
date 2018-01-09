//
//  iCarouselView.m
//  豆蔓理财
//
//  Created by edz on 2016/12/16.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "iCarouselView.h"

#define SelectColor MainGreen
#define UnselectColor LightGray
#define kImageWide DMDeviceWidth/5
#define kImageHeight 30


@interface iCarouselView ()

@property (nonatomic, strong) UIView *midLine;


@property (nonatomic, strong) UIImageView *layerView1;

@end

@implementation iCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.items = [NSMutableArray array];
        
        for (int i = 0; i < 14; i++) {
            if (i == 0) {
                 [_items addObject:@(i)];
            }
            else if (i == 1) {
                [_items addObject:@(14 - i)];
            }else {
                [_items addObject:@(i - 1)];
            }
        }
            
        
        self.number = 5;

        [self initView];
        
    }
    return self;
    
}

- (void)initView {
    
    //创建maskLayer
    CALayer *maskLayer = [CALayer layer];
    //给maskLayer 设定frame
    maskLayer.frame = CGRectMake(0, 0, DMDeviceWidth, 70);
    
    UIImage *maskImage = [UIImage imageNamed:@"尺子蒙版"];
    //给图层的contents添加内容
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    
    
    [_carousel.layer setMask:maskLayer];
    [self.layer addSublayer:maskLayer];
    
    
    _carousel = [[iCarousel alloc] init];
    _carousel.frame = CGRectMake(0, 0, DMDeviceWidth, 80);
    _carousel.delegate = self;
    _carousel.dataSource = self;
    [self addSubview:_carousel];
    [_carousel addSubview:self.midLine];

    
    [_carousel isWrapEnabled];
    _carousel.type = iCarouselTypeLinear;
    
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
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{

    //create new view if no view is available for recycling

    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth/ _number, 80)];
    view.contentMode = UIViewContentModeCenter;
    UILabel *label = label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kImageWide, 40)];
    label.textColor = UnselectColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:11];
    label.tag = 1;
    label.text = [NSString stringWithFormat:@"%@个月",[_items[index] stringValue]];
    
    
    if ([label.text isEqualToString:@"0个月"]) {
        label.text = @"全部";
    }
    
    if ([label.text isEqualToString:@"13个月"]) {
        label.text = @"一月之内";
    }
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, kImageWide, kImageHeight)];
    imageview.image = [UIImage imageNamed:@"rule"];

    [view addSubview:label];
    [view addSubview:imageview];
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value;
    } else if(option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}



- (void)carouselDidScroll:(iCarousel *)carousel {
    self.midLine.hidden = YES;
    [UIView animateWithDuration:0.1 animations:^{
        UILabel *label = [self.carousel.currentItemView.subviews firstObject];
        label.textColor = UnselectColor;
        label.transform = CGAffineTransformMakeScale(1, 1);
    }];
}


- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    self.midLine.hidden = NO;
    UILabel *label = [self.carousel.currentItemView.subviews firstObject];
    [UIView animateWithDuration:0.1 animations:^{
        label.textColor = SelectColor;
        label.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }];
    if ([label.text isEqualToString:@"全部"]) {
        if([self.scroll respondsToSelector:@selector(ScrollingAnimation:)]){
            [self.scroll ScrollingAnimation:0];
        }
    }
    
    if ([label.text isEqualToString:@"一月之内"]) {
        if([self.scroll respondsToSelector:@selector(ScrollingAnimation:)]){
            [self.scroll ScrollingAnimation:13];
        }
    }
    
    for (int i = 0; i <_items.count; i ++) {
        if ([label.text isEqualToString:[NSString stringWithFormat:@"%d个月",i]]) {
            
            if([self.scroll respondsToSelector:@selector(ScrollingAnimation:)]){
                [self.scroll ScrollingAnimation:i];
            }
        }
        
    }

}

- (UIView *)midLine{
    if (_midLine == nil) {
        self.midLine = [[UIView alloc]initWithFrame:CGRectMake((DMDeviceWidth-1)/2, 40, 1, 30)];
        _midLine.backgroundColor = SelectColor;
    }
    return _midLine;
}



@end
