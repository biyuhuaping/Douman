//
//  LJQCouponsCell.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQCouponsCell.h"

@interface LJQCouponsCell ()

{
    UILongPressGestureRecognizer *longPressGesture;
    
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, strong)UILabel *AcountOrRateLabel;
@property (nonatomic, strong)UILabel *instructionsLabel; //说明类型
@property (nonatomic, strong)UILabel *describeLabel; //描述
@property (nonatomic, strong)UILabel *dateLabel; //有效期
@property (nonatomic, strong)UILabel *NewOrOldLabel; //
@property (nonatomic, strong)UIImageView *bottomView; //底层图片
@property (nonatomic, strong)UIImageView *backImageView; //返回图片


@property (nonatomic, strong)UIImageView *OldPitcure;

@end

@implementation LJQCouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }
    return self;
}

- (void)setUp {
  
    UIImage *image = [UIImage imageNamed:@"返现卡底色背景"];
    UIImage *back = [UIImage imageNamed:@"返现卡-箭头"];
    self.bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, SCREENWIDTH - 24, image.size.height)];
    
    //添加手势
    self.AcountOrRateLabel = [UILabel createLabelFrame:CGRectMake(13, 14, 60, 45) labelColor:UIColorFromRGB(0xfa9c22) textAlignment:(NSTextAlignmentLeft) textFont:42.f];
    [self.bottomView addSubview:self.AcountOrRateLabel];
    
    self.instructionsLabel = [UILabel createLabelFrame:CGRectMake(20 + CGRectGetMidX(self.AcountOrRateLabel.frame), 35, 40, 14) labelColor:UIColorFromRGB(0x808080) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
    [self.bottomView addSubview:self.instructionsLabel];
    
    //类型描述
    self.describeLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH - 24) / 2 - 18 - back.size.width, 20, (SCREENWIDTH - 24) / 2, 15) labelColor:UIColorFromRGB(0xf9d23) textAlignment:(NSTextAlignmentRight) textFont:14.f];
    [self.bottomView addSubview:self.describeLabel];
    
    self.durationLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH - 24) / 2 - 18 - back.size.width, 40, (SCREENWIDTH - 24) / 2, 15) labelColor:UIColorFromRGB(0x808080) textAlignment:(NSTextAlignmentRight) textFont:10.f];
    [self.bottomView addSubview:self.durationLabel];
    
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 33 - back.size.width, 26, back.size.width, back.size.height)];
    [self.bottomView addSubview:self.backImageView];
    
    self.dateLabel = [UILabel createLabelFrame:CGRectMake(13, CGRectGetMaxY(self.describeLabel.frame) + 30, 200, 12) labelColor:UIColorFromRGB(0x808080) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
    [self.bottomView addSubview:self.dateLabel];
    
    self.NewOrOldLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH - 24) / 2 - 13, CGRectGetMaxY(self.describeLabel.frame) + 30, (SCREENWIDTH - 24) / 2, 15)labelColor:UIColorFromRGB(0xbdbdbd) textAlignment:(NSTextAlignmentRight) textFont:11.f];
    [self.bottomView addSubview:self.NewOrOldLabel];
    
    UIImage *OldImage = [UIImage imageNamed:@"已过期"];
    self.OldPitcure = [[UIImageView alloc] initWithImage:OldImage];
    self.OldPitcure.frame = CGRectMake(0, 0, OldImage.size.width, OldImage.size.height);
    CGPoint point = self.describeLabel.center;
    self.OldPitcure.center = CGPointMake(point.x + 20, point.y);
    [self.bottomView addSubview:self.OldPitcure];
    
    [self.contentView addSubview:self.bottomView];
}

- (void)setCouponCategory:(YHCouponCategory)couponCategory{
    
    _couponCategory =couponCategory;
    switch (couponCategory) {
        case YHCouponCategoryReturnCard:
       //返现卡
        {
            UIImage *image = [UIImage imageNamed:@"返现卡底色背景"];
            self.bottomView.image = image;
            UIImage *back = [UIImage imageNamed:@"返现卡-箭头"];
            self.backImageView.image = back;
            self.AcountOrRateLabel.textColor = UIColorFromRGB(0xfb9d23);
            self.describeLabel.textColor = UIColorFromRGB(0xfb9d23);
            //self.NewOrOldLabel.text = @"新手专享产品外均可使用";
        }
            break;
            
        case YHCouponCategoryExperienceCard:
        {
            UIImage *image = [UIImage imageNamed:@"已过期底色背景"];
            self.bottomView.image = image;
            UIImage *back = [UIImage imageNamed:@"已过期-箭头"];
            self.backImageView.image = back;
            self.AcountOrRateLabel.textColor = UIColorFromRGB(0xffffff);
            self.describeLabel.textColor = UIColorFromRGB(0xbdbdbd);
            //self.NewOrOldLabel.text = @"新手专享产品外均可使用";
        }
            break;
            
        case YHCouponCategoryCoupon:
            //加息
        {
            UIImage *image = [UIImage imageNamed:@"加息券底色背景"];
            self.bottomView.image = image;
            UIImage *back = [UIImage imageNamed:@"加息券-箭头"];
            self.backImageView.image = back;
            self.AcountOrRateLabel.textColor = UIColorFromRGB(0x2ac580);
            self.describeLabel.textColor = UIColorFromRGB(0x2ac580);
            //self.NewOrOldLabel.text = @"新手专享产品外均可使用";
        }
            break;
            
        default:
            break;
    }
    
}

- (CGSize)returnLabelSize:(NSString *)string size:(CGSize)size dic:(NSDictionary *)dic{
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size;
}

- (void)setIsExpired:(BOOL)isExpired {
    if (isExpired) {
        self.OldPitcure.hidden = NO;
    }else {
        self.OldPitcure.hidden = YES;
    }
}


- (void)setIsArrow:(BOOL)isArrow {
    if (isArrow) {
        UIImage *back = [UIImage imageNamed:@"加息券-箭头"];
         [self.describeLabel setFrame:CGRectMake((SCREENWIDTH - 24) / 2 - 18 - back.size.width, 26, (SCREENWIDTH - 24) / 2, 15)];
        self.backImageView.hidden = NO;
    }else {
        self.backImageView.hidden = YES;
        [self.describeLabel setFrame:CGRectMake((SCREENWIDTH - 24) / 2 - 18 , 26, (SCREENWIDTH - 24) / 2, 15)];
    }
}

- (void)addGesture {
    
    if(!longPressGesture) {
        
        longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureAction:)];
        longPressGesture.minimumPressDuration = 0.1f;
        self.bottomView.userInteractionEnabled = YES;
        [self.bottomView addGestureRecognizer:longPressGesture];
    }
    
    if(!tapGesture) {
        
        tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        self.bottomView.userInteractionEnabled = YES;
        [self.bottomView addGestureRecognizer:tapGesture];
    }
}

#pragma mark - Tap Gesture Action
-(void)tapGestureAction: (UITapGestureRecognizer *)tap {
    
    if(tap.state == UIGestureRecognizerStateBegan) {
        self.bottomView.layer.borderWidth = 1.0f;
        self.bottomView.layer.borderColor = [UIColor redColor].CGColor;
    }else if(tap.state ==  UIGestureRecognizerStateFailed) {
        self.bottomView.layer.borderWidth = 0.0f;
        self.bottomView.layer.borderColor = [UIColor clearColor].CGColor;
    }else if(tap.state == UIGestureRecognizerStateEnded) {
        self.bottomView.layer.borderWidth = 0.0f;
        self.bottomView.layer.borderColor = [UIColor clearColor].CGColor;
        [self.updateDelegate updateUserInterfaceWithCouponModel:self.model];
        [self.popDelegate popViewControllerWithAnimated:YES];
    }
}

#pragma mark - LongPress Gesture Action
- (void)longPressGestureAction:(UILongPressGestureRecognizer *)longPress {
    
    if(longPress.state == UIGestureRecognizerStateBegan) {
        self.bottomView.layer.borderWidth = 2.0f;
        self.bottomView.layer.borderColor = [UIColor redColor].CGColor;
    }else if(longPress.state ==  UIGestureRecognizerStateFailed) {
        self.bottomView.layer.borderWidth = 0.0f;
        self.bottomView.layer.borderColor = [UIColor clearColor].CGColor;
    }else if(longPress.state == UIGestureRecognizerStateEnded) {
        self.bottomView.layer.borderWidth = 0.0f;
        self.bottomView.layer.borderColor = [UIColor clearColor].CGColor;
        [self.updateDelegate updateUserInterfaceWithCouponModel:self.model];
        [self.popDelegate popViewControllerWithAnimated:YES];
    }
}

- (void)setModel:(LJQCouponsModel *)model {
    if (_model != model) {
        _model = model;
    }
    //可以使用
    if ([_model.status isEqualToString:@"PLACED"]) {
        
        NSString *parValueStr;
        if ([_model.type isEqualToString:@"INTEREST"]) {
            //加息券
            self.couponCategory = YHCouponCategoryCoupon;
            parValueStr = [_model.parValue stringByAppendingString:@"%"];
             self.instructionsLabel.text = @"加息券";
        }else {
            //返现卡
            self.couponCategory = YHCouponCategoryReturnCard;
            parValueStr = [_model.parValue stringByAppendingString:@"元"];
             self.instructionsLabel.text = @"返现卡";
        }
        
        
        [self.AcountOrRateLabel AttributeString:parValueStr DIC:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} range:NSMakeRange(parValueStr.length - 1, 1)];
        CGSize size = [self returnLabelSize:parValueStr size:CGSizeMake(200, 45) dic:@{NSFontAttributeName:[UIFont systemFontOfSize:42.f]}];
        self.AcountOrRateLabel.frame = CGRectMake(13, 14, size.width, 45);
        self.instructionsLabel.frame = CGRectMake(size.width, 35, 40, 14);
        NSString *string = [NSString stringWithFormat:@"单次投资%@元及以上",_model.minimumInvest];
        NSRange range = [string rangeOfString:@"元"];
        [self.describeLabel AttributeString:string DIC:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f],NSForegroundColorAttributeName:UIColorFromRGB(0x808080)} range:NSMakeRange(range.location, string.length - range.location)];
        self.dateLabel.text = [NSString stringWithFormat:@"有效期至%@",_model.timeExpire];
        //self.instructionsLabel.text = _model.couponName;
        //self.NewOrOldLabel.text = @"新手专享产品外均可使用";
        
        if ([_model.minimumDuration isEqualToString:_model.maximumDuration]) {
            self.durationLabel.text = [NSString stringWithFormat:@"可用于%@个月的产品",_model.maximumDuration];
        }else {
            self.durationLabel.text = [NSString stringWithFormat:@"可用于%@～%@个月的产品",_model.minimumDuration,_model.maximumDuration];
        }
        
    }else {
        self.couponCategory = YHCouponCategoryExperienceCard;
        NSString *parValueStr;
        if ([_model.type isEqualToString:@"INTEREST"]) {
            //加息券
            parValueStr = [_model.parValue stringByAppendingString:@"%"];
            self.instructionsLabel.text = @"加息券";
        }else {
            //返现卡
            parValueStr = [_model.parValue stringByAppendingString:@"元"];
             self.instructionsLabel.text = @"返现卡";
        }
        
        
        [self.AcountOrRateLabel AttributeString:parValueStr DIC:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} range:NSMakeRange(parValueStr.length - 1, 1)];
        CGSize size = [self returnLabelSize:parValueStr size:CGSizeMake(200, 45) dic:@{NSFontAttributeName:[UIFont systemFontOfSize:42.f]}];
        self.AcountOrRateLabel.frame = CGRectMake(13, 14, size.width, 45);
        self.instructionsLabel.frame = CGRectMake(size.width, 35, 40, 14);
        NSString *string = [NSString stringWithFormat:@"单次投资%@元及以上",_model.minimumInvest];
        NSRange range = [string rangeOfString:@"元"];
        [self.describeLabel AttributeString:string DIC:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f],NSForegroundColorAttributeName:UIColorFromRGB(0x808080)} range:NSMakeRange(range.location, string.length - range.location)];
        self.dateLabel.text = [NSString stringWithFormat:@"有效期至%@",_model.timeExpire];
//        self.instructionsLabel.text = _model.couponName;
        //self.NewOrOldLabel.text = @"新手专享产品外均可使用";
        
    }
}

@end
