//
//  DMPerCheckCollectionCell.h
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/13.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMPerCheckCollectionCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UIImageView *isPass;

@end
