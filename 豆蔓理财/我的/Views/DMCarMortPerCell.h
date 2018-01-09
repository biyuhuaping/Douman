//
//  DMCarMortPerCell.h
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/13.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMCarMortPerCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *authenArray;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
