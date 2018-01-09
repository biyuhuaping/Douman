//
//  DMSetupBankTableViewCell.h
//  豆蔓理财
//
//  Created by edz on 2016/12/27.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMSetupBankTableViewCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *image;
@property (nonatomic ,strong) UILabel *name;
@property (nonatomic ,strong) UILabel *simple;
@property (nonatomic ,strong) UILabel *onetime;
@property (nonatomic ,strong) UILabel *day;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
