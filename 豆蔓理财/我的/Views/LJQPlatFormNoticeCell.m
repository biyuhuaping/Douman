//
//  LJQPlatFormNoticeCell.m
//  豆蔓理财
//
//  Created by mac on 2016/12/26.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQPlatFormNoticeCell.h"
#import "LJQPlanformNoticeModel.h"

@interface LJQPlatFormNoticeCell ()

@property (nonatomic, strong)UIImageView *promptPitcure; //未读显示
@property (nonatomic, strong)UILabel *nameLabel; //
@property (nonatomic, strong)UILabel *contentLabel; //
@property (nonatomic, strong)UILabel *timeLabel; //
@property (nonatomic, strong)UIImageView *selectedPitcure;

@end

@implementation LJQPlatFormNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UIImage *image = [UIImage imageNamed:@"未读圆点"];
    self.promptPitcure = [[UIImageView alloc] initWithImage:image];
    
    self.nameLabel = [UILabel createLabelFrame:CGRectMake(25 + image.size.width, 12, SCREENWIDTH - 100, 14) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentLeft) textFont:13.f];
    self.nameLabel.numberOfLines = 0;
    self.promptPitcure.center = CGPointMake(22 + image.size.width / 2, self.nameLabel.center.y);
    [self.contentView addSubview:self.promptPitcure];
    [self.contentView addSubview:self.nameLabel];
    
    self.contentLabel = [UILabel createLabelFrame:CGRectMake(25 + image.size.width, CGRectGetMaxY(self.nameLabel.frame) + 12, SCREENWIDTH - 100, 20) labelColor:UIColorFromRGB(0x787878) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.contentLabel];
    
    self.timeLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - 175, 13, 150, 12) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentRight) textFont:11.f];
    [self.contentView addSubview:self.timeLabel];
    
    UIImage *selectedImage = [UIImage imageNamed:@"未选中"];
    self.selectedPitcure = [[UIImageView alloc] initWithImage:selectedImage];
    self.selectedPitcure.frame = CGRectMake(SCREENWIDTH - selectedImage.size.width - image.size.width - 25, CGRectGetMaxY(self.timeLabel.frame) + 20, selectedImage.size.width, selectedImage.size.height);
    self.selectedPitcure.hidden = YES;
    [self.contentView addSubview:self.selectedPitcure];
}


- (void)setModel:(LJQPlanformNoticeModel *)model {
    if (_model != model) {
        _model = model;
    }
        self.nameLabel.text = model.title;
        self.contentLabel.text = model.briff;
        self.timeLabel.text = model.pubdate;
        UIImage *image = [UIImage imageNamed:@"未读圆点"];
        [self.nameLabel setFrame:CGRectMake(25 + image.size.width, 12, SCREENWIDTH - 100, [self returnBackLabelHeight:self.nameLabel.text])];
    
        [self.contentLabel setFrame:CGRectMake(25 + LJQ_VIEW_Width(self.promptPitcure), CGRectGetMaxY(self.nameLabel.frame) + 12, SCREENWIDTH - 100, [self returnBackLabelHeight:self.contentLabel.text])];

}

- (CGFloat)returnBackLabelHeight:(NSString *)string {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH - 100, 100) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil];
    return rect.size.height;
}

- (void)setIsRead:(BOOL)isRead {
    _isRead = isRead;
    if (isRead) {
        self.promptPitcure.hidden = YES;
    }else {
        self.promptPitcure.hidden = NO;
    }
}

- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    if (isShow) {
        self.selectedPitcure.hidden = NO;
    }else {
        self.selectedPitcure.hidden = YES;
    }
}
@end
