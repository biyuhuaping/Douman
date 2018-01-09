//
//  iCarouselView.h
//  豆蔓理财
//
//  Created by edz on 2016/12/16.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"


@protocol iCarouselScrolling <NSObject>

-(void)ScrollingAnimation:(NSInteger)tag;

@end


@interface iCarouselView : UIView <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong)iCarousel *carousel;
@property (nonatomic, strong)UILabel *line;
@property (nonatomic, assign) int number;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, weak) id <iCarouselScrolling> scroll;

@end
