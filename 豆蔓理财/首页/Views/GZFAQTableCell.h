//
//  GZFAQTableCell.h
//  豆蔓理财
//
//  Created by armada on 2017/5/5.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface GZFAQTableCell : UITableViewCell

/** FAQ图标 */
@property(nonatomic, strong) UIImageView *iconImageView;
/** FAQ标题 */
@property(nonatomic, strong) UILabel *questionLabel;
/** FAQ说明 */
@property(nonatomic, strong) UILabel *answerLabel;

@end
