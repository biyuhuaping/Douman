//
//  elesICarousel.h
//  豆蔓理财
//
//  Created by edz on 2016/12/29.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface elesICarousel : UIView<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong)iCarousel *carousel;
@property (nonatomic, strong)UILabel *line;

@property (nonatomic, copy)NSString *rate;
@property (nonatomic, assign) int number;

@property (nonatomic, strong) NSMutableArray *items;

- (instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr;

@property (nonatomic, strong) NSArray *dataArray;

@end
