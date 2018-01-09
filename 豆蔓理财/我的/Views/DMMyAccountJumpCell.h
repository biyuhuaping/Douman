//
//  DMMyAccountJumpCell.h
//  豆蔓理财
//
//  Created by bluesky on 2017/8/24.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMMyAccountJumpCell : UITableViewCell

@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, copy)NSString *labelText;

@property (nonatomic, assign)BOOL isOrShowTextLabel;
@property (nonatomic, copy)NSString *showText;

@end
