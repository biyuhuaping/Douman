//
//  GZReviewedListNoRecordTableViewCell.m
//  豆蔓理财
//
//  Created by armada on 2017/1/12.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZReviewedListNoRecordTableViewCell.h"

@implementation GZReviewedListNoRecordTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"noRecordCell";
    
    GZReviewedListNoRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil) {
        cell = [[GZReviewedListNoRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.noRecordLabel.text = @"当前期限暂无记录";
    }
    return self;
}

#pragma mark - Lazy Loading
- (UILabel *)noRecordLabel {
    
    if(!_noRecordLabel) {
        _noRecordLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_noRecordLabel];
        [self.noRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsZero);
        }];
        [_noRecordLabel setFont:[UIFont systemFontOfSize:16]];
        [_noRecordLabel setTextAlignment:NSTextAlignmentCenter];
        [_noRecordLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
    }
    return _noRecordLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
