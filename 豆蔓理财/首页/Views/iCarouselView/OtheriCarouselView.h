//
//  OtheriCarouselView.h
//  豆蔓理财
//
//  Created by edz on 2016/12/19.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"


@interface OtheriCarouselView : UIView <iCarouselDataSource, iCarouselDelegate>


- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr;

@property (nonatomic, strong)iCarousel *carousel;
@property (nonatomic, strong)UILabel *line;
@property (nonatomic, assign) int number;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIImageView *screen;
@property (nonatomic, strong) UILabel *screenL;

@end
