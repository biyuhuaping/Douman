//
//  LJQProductInfoCell.m
//  豆蔓理财
//
//  Created by mac on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQProductInfoCell.h"

@interface LJQProductInfoCell ()

@property (nonatomic, strong)UIView *promptView;

@end

@implementation LJQProductInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.messageLabel];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        self.nameLabel = [UILabel createLabelFrame:CGRectMake(20, 18, 70, 15) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:13.f];
    }
    return _nameLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        self.messageLabel = [UILabel createLabelFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 49, 18, SCREENWIDTH - CGRectGetMaxX(self.nameLabel.frame) - 50, 15) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
        self.messageLabel.numberOfLines = 0;
        
    }
    return _messageLabel;
}

- (CGFloat)returnHeight:(NSString *)string {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH - CGRectGetMaxX(self.nameLabel.frame) - 50, 300) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil];
    
    return rect.size.height;
}

//创建图片附件
- (NSAttributedString *)pitcureString {
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"未读圆点"];
    attach.bounds = CGRectMake(0, 0, 5, 5);
    NSAttributedString *attachStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    return attachStr;
}

- (NSMutableAttributedString *)returenAttribute:(NSString *)string {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute insertAttributedString:[self pitcureString] atIndex:0];
    
    return attribute;
}

//创建气泡附件
- (NSAttributedString *)pitcureStringQipao {
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"提示气泡"];
    attach.bounds = CGRectMake(0, 0, 12, 12);
    NSAttributedString *attachStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    return attachStr;
}

- (NSMutableAttributedString *)QipaoreturenAttribute:(NSString *)string {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
   
     [attribute insertAttributedString:[self pitcureStringQipao] atIndex:string.length];
    return attribute;
}

- (UIView *)CreateBottomView:(CGFloat)rect messageArr:(NSArray *)array color:(UIColor *)color indexPath:(NSInteger)index {
    self.promptView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 49, rect, SCREENWIDTH - CGRectGetMaxX(self.nameLabel.frame) - 70, 400)];
    CGFloat maxy = 0;
    for (int i = 0; i < array.count; i++) {
        NSString *string = [NSString stringWithFormat:@"%@",array[i]];
        CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH - CGRectGetMaxX(self.nameLabel.frame) - 50, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil];
        
        UILabel *label1 = [UILabel createLabelFrame:CGRectMake(0, maxy, SCREENWIDTH - CGRectGetMaxX(self.nameLabel.frame) - 50, rect.size.height) labelColor:color textAlignment:(NSTextAlignmentLeft) textFont:12.f];
        label1.numberOfLines = 0;
       
        if (index == 10) {
             label1.attributedText = [self returenAttribute:array[i]];
        }else
            if (index == 11) {
                 label1.attributedText = [self QipaoreturenAttribute:array[i]];
            }else {
                label1.text = array[i];
            }
        
        [self.promptView addSubview:label1];
        
        maxy = rect.size.height + maxy + 5;
    }
    [self.promptView setFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 49, rect, SCREENWIDTH - CGRectGetMaxX(self.nameLabel.frame) - 50, maxy)];
    return self.promptView;
}

- (void)setIshidenMessage:(BOOL)ishidenMessage {
    _ishidenMessage = ishidenMessage;
    if (_ishidenMessage) {
        self.messageLabel.hidden = YES;
        
    }else {
        self.messageLabel.hidden = NO;
    }

}

- (void)createOtherView:(NSArray *)array color:(UIColor *)color indexPath:(NSInteger)index {
  
    [self.contentView addSubview:[self CreateBottomView:18 messageArr:array color:color indexPath:index]];
}

@end
