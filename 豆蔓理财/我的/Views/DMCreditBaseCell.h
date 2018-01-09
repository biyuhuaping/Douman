//
//  DMCreditBaseCell.h
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/12.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DMCreditBaseCell : UITableViewCell


@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
