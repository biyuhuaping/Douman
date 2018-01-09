//
//  LJQUserInfoThreeCell.m
//  豆蔓理财
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQUserInfoThreeCell.h"
#import "LJQUserInfoModel.h"
@interface LJQUserInfoThreeCell ()

@property (nonatomic, strong)UIImageView *bottomView;
@property (nonatomic, strong)UIImageView *addPitcureView;

@property (nonatomic, strong)UILabel *numberLabel; //银行号
@property (nonatomic, strong)UILabel *personLabel; //开户名
@property (nonatomic, strong)UILabel *bankLabel; //开户行

@end

@implementation LJQUserInfoThreeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (UIImageView *)bottomView {
    UIImage *image = [UIImage imageNamed:@"未开户底框"];
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, DMDeviceWidth - 20, (DMDeviceWidth - 20) * image.size.height / image.size.width)];
        _bottomView.image = image;
    }
    return _bottomView;
}

- (void)createNotOpenAccount {
    
    [self.bottomView setImage:[UIImage imageNamed:@"未开户底框"]];
    
    UIImage *image = [UIImage imageNamed:@"立即开户icon"];
    self.addPitcureView = [[UIImageView alloc] initWithFrame:CGRectMake((DMDeviceWidth - image.size.width - 20) / 2, 50, image.size.width, image.size.height)];
    self.addPitcureView.image= image;
    [self.bottomView addSubview:self.addPitcureView];
    
    UILabel *label = [UILabel createLabelFrame:CGRectMake(0, LJQ_VIEW_MaxY(self.addPitcureView) + 26, DMDeviceWidth - 20, 16) labelColor:UIColorFromRGB(0x6d727a) textAlignment:(NSTextAlignmentCenter) textFont:15.f];
    label.text = @"您还没有开通徽商银行存管账户";
    [self.bottomView addSubview:label];
     [self.contentView addSubview:self.bottomView];
}


- (void)createOpenAccount {
    UIImage *image = [UIImage imageNamed:@"电子交易账户"];
    [self.bottomView setImage:image];
    
    CGFloat scale = (DMDeviceWidth - 20) / image.size.width;
    self.numberLabel = [UILabel createLabelFrame:CGRectMake(17, 85 * scale, LJQ_VIEW_Width(self.bottomView) - 34, 22) labelColor:UIColorFromRGB(0x505050) textAlignment:(NSTextAlignmentLeft) textFont:21.f];
    self.numberLabel.text = CARD_NUMBER;
    [self.bottomView addSubview:self.numberLabel];
    
    self.personLabel = [UILabel createLabelFrame:CGRectMake(17, LJQ_VIEW_MaxY(self.numberLabel) + 35, 300, 15) labelColor:UIColorFromRGB(0x6d727a) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
    self.personLabel.text = [NSString stringWithFormat:@"开户名：%@",REALNAME];
    [self.bottomView addSubview:self.personLabel];
    
    self.bankLabel = [UILabel createLabelFrame:CGRectMake(17, LJQ_VIEW_MaxY(self.personLabel) + 17, LJQ_VIEW_Width(self.bottomView) - 34, 15) labelColor:UIColorFromRGB(0x6d727a) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
    self.bankLabel.text = @"开户行：徽商银行股份有限公司合肥花园街支行";
    [self.bottomView addSubview:self.bankLabel];
     [self.contentView addSubview:self.bottomView];
}

- (void)openAccount:(UIButton *)sender {
    if (self.openAccount) {
        self.openAccount(sender);
    }
}

- (void)layoutSubviews {
     self.personLabel.text = [NSString stringWithFormat:@"开户名：%@", isOrEmpty(self.infoModel.name) ? @"" : self.infoModel.name];
}

- (void)setIsOpenAccount:(BOOL)isOpenAccount {
    _isOpenAccount = isOpenAccount;
    [self.bottomView removeFromSuperview];
    self.bottomView = nil;
    if (_isOpenAccount == YES) {
        //开户
        [self createOpenAccount];
    }else {
        //未开户
        [self createNotOpenAccount];
    }
}

@end
