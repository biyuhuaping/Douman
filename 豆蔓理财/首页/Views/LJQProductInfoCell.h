//
//  LJQProductInfoCell.h
//  豆蔓理财
//
//  Created by mac on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJQProductInfoCell : UITableViewCell

@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *messageLabel;

@property (nonatomic, assign)BOOL ishidenMessage;

- (void)createOtherView:(NSArray *)array color:(UIColor *)color indexPath:(NSInteger)index;
@end
