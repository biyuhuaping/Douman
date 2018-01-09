//
//  elseiCarouselView.h
//  豆蔓理财
//
//  Created by edz on 2016/12/20.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DMCreditDetailController.h"

@interface elseiCarouselView : UIView<iCarouselDataSource, iCarouselDelegate>

- (instancetype)initWithFrame:(CGRect)frame Type:(CreditType)type;

@property (nonatomic, strong)iCarousel *carousel;
@property (nonatomic, strong)UILabel *line;


@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic) CreditType type;

@end
