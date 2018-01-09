//
//  LJQOpenAccCell.m
//  豆蔓理财
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQOpenAccCell.h"

@interface LJQOpenAccCell ()

@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *nextLabel;

@end

@implementation LJQOpenAccCell
@synthesize nameLabel;
@synthesize nextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    nameLabel = [UILabel createLabelFrame:CGRectMake(21, 20, 50, 13) labelColor:UIColorFromRGB(0xa8abb1) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    nameLabel.text = @"开户地区";
    
    self.cityLabel = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_MaxX(nameLabel), 20, 300, 13) labelColor:UIColorFromRGB(0x6d727a) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    
    UIImage *image1 = [UIImage imageNamed:@"xiangxia"];
    UIImageView *pitcure = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 40, 20, image1.size.width, image1.size.height)];
    pitcure.image = image1;
    [self.contentView addSubview:pitcure];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(LJQ_VIEW_MaxX(nameLabel), LJQ_VIEW_MaxY(self.cityLabel) + 10, SCREENWIDTH - LJQ_VIEW_MaxX(nameLabel) - 21, 1)];
    line.backgroundColor = UIColorFromRGB(0xf3f3f3);
    
    nextLabel = [UILabel createLabelFrame:CGRectMake(21, LJQ_VIEW_MaxY(line) + 20, 50, 13) labelColor:UIColorFromRGB(0xa8abb1) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    nextLabel.text = @"开户行";
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(LJQ_VIEW_MaxX(nameLabel), LJQ_VIEW_MaxY(line) + 20, SCREENWIDTH - LJQ_VIEW_MaxX(nameLabel), 13)];
    self.textField.font = [UIFont systemFontOfSize:12.f];
    self.textField.placeholder = @"开户行名称";
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(LJQ_VIEW_MaxX(nextLabel), LJQ_VIEW_MaxY(self.textField) + 10, SCREENWIDTH - LJQ_VIEW_MaxX(nameLabel) - 21, 1)];
    line1.backgroundColor = UIColorFromRGB(0xf3f3f3);
    
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:self.cityLabel];
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:nextLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:line1];
    
    UIImage *image = [UIImage imageNamed:@"确认"];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake((SCREENWIDTH - image.size.width) / 2, LJQ_VIEW_MaxY(line1) + 80, image.size.width, image.size.height);
    [button setBackgroundImage:image forState:(UIControlStateNormal)];
    [button setBackgroundImage:image forState:(UIControlStateHighlighted)];
    [button addTarget: self action:@selector(confirmEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:button];
    
    NSLog(@"%f",LJQ_VIEW_MaxY(button));

}

- (void)confirmEvent:(UIButton *)senfer {
    self.confirmBK(senfer);
}

@end
