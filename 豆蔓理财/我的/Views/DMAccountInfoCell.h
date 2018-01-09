//
//  DMAccountInfoCell.h
//  豆蔓理财
//
//  Created by bluesky on 2017/8/25.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,showTextStyle){
    showTextStyleNone,
    showTextStyleWithColor
};
@interface DMAccountInfoCell : UITableViewCell

@property (nonatomic, copy)NSString *cellName;
@property (nonatomic, assign)showTextStyle textStyle;
@property (nonatomic, copy)NSString *showText;

@end
