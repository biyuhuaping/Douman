//
//  LJQTransactionView.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQTransactionView.h"
#import "LJQUpDown.h"

@interface LJQTransactionView ()

@property (nonatomic, strong)LJQUpDown *UpDownView;
@property (nonatomic, strong)LJQUpDown *otherDownView;

@property (nonatomic, strong)UIButton *firstBtn;
@property (nonatomic, strong)UIButton *sencondBtn;

@property (nonatomic, strong)UIButton *selectedBtn; //选择的button

@property (nonatomic, strong)UIView *leftView;
@property (nonatomic, strong)UIView *rightView;
@end

@implementation LJQTransactionView
@synthesize UpDownView;
@synthesize otherDownView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createTimeSelected];
        [self createTransactionState];
        
    }
    return self;
}

//查询时间
- (void)createTimeSelected {
    UIImage *image = [UIImage imageNamed:@"查询框"];
    
    UILabel *label = [UILabel createLabelFrame:CGRectMake(iPhone5 ? 10 : 23, 18, 60, image.size.height) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:14.f];
    label.text = @"查询时间";
    self.firstBtn.frame = CGRectMake(CGRectGetMaxX(label.frame) + 16, 18, iPhone5 ? image.size.width * 0.8 : image.size.width, image.size.height);
    UILabel *centerLabel = [UILabel createLabelFrame:CGRectMake(CGRectGetMaxX(self.firstBtn.frame)+ 7, 20, 15, image.size.height) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:14.f];
    centerLabel.text = @"至";
    self.sencondBtn.frame = CGRectMake(CGRectGetMaxX(centerLabel.frame) + 7, 18, iPhone5 ? image.size.width * 0.8 : image.size.width, image.size.height);
    
    [self addSubview:label];
    [self addSubview:centerLabel];
}

- (void)createTransactionState {
    UIImage *image = [UIImage imageNamed:@"认--购-选中"];
    UILabel *label = [UILabel createLabelFrame:CGRectMake(iPhone5 ? 10 : 23, image.size.height + 31, 60, image.size.height) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:14.f];
    label.text = @"交易类型";
    
    NSArray *nameArr = @[@"认 购",@"回 款",@"充 值",@"提 现",@"红包奖金",@"平台服务费"];
    CGFloat height = CGRectGetMaxY(self.firstBtn.frame) + 13;
    NSInteger index = 0;
    for (NSInteger number = 0; number < 2; number++) {
        
        for (NSInteger i = 0; i < (number > 0 ? 3 : 3); i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(CGRectGetMaxX(label.frame) + ((iPhone5 ? image.size.width * 0.8 : image.size.width) + 10) * i + 16, height, iPhone5 ? image.size.width * 0.8 : image.size.width, image.size.height);
            button.tag = 1000 + i + index;
            [button setTitle:nameArr[i + index] forState:(UIControlStateNormal)];
            button.layer.cornerRadius = 10;
            button.layer.borderColor = UIColorFromRGB(0xf6f6f6).CGColor;
            button.layer.borderWidth = 1;
            button.titleLabel.font = [UIFont systemFontOfSize:12.f];
            [button setTitleColor:UIColorFromRGB(0x595757) forState:(UIControlStateNormal)];
            [button setBackgroundColor:[UIColor whiteColor]];

            if (number == 0 && i == 0 ) {
                [button setTitleColor:MainRed forState:(UIControlStateNormal)]; /////////////whiteColor
//                [button setBackgroundColor:UIColorFromRGB(0xffb246)];
                button.layer.borderColor = MainRed.CGColor; //////////////0xffb246
                self.selectedBtn = button;
            }
            [button addTarget: self action:@selector(transactionState:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:button];
        }
        height = height + image.size.height + 11;
        index = 3;
    }
    
    [self addSubview:label];
}
//交易类型按钮选择事件
- (void)transactionState:(UIButton *)sender {
    
    if (self.selectedBtn.tag == sender.tag) {
        [sender setTitleColor:MainRed forState:(UIControlStateNormal)]; /////////////whiteColor
//        [sender setBackgroundColor:UIColorFromRGB(0xffb246)];
        sender.layer.borderColor = MainRed.CGColor; //////////////0xffb246
    }else {
        [sender setTitleColor:MainRed forState:(UIControlStateNormal)]; /////////////whiteColor
//        [sender setBackgroundColor:UIColorFromRGB(0xffb246)];
        sender.layer.borderColor = MainRed.CGColor; //////////////0xffb246
        
        [self.selectedBtn setTitleColor:UIColorFromRGB(0x595757) forState:(UIControlStateNormal)];
        [self.selectedBtn setBackgroundColor:[UIColor whiteColor]];
        self.selectedBtn.layer.borderColor = UIColorFromRGB(0xf6f6f6).CGColor;
    }
    self.selectedBtn = sender;
    self.buttonSelectedBK(sender.tag - 1000);
}


- (UIButton *)firstBtn {
    if (!_firstBtn) {
        self.firstBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"查询框"] forState:(UIControlStateNormal)];
        [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"查询框"] forState:(UIControlStateHighlighted)];
        [self.firstBtn setTitle:[self nowDate] forState:(UIControlStateNormal)];
        self.firstBtn.titleLabel.font = [UIFont systemFontOfSize:iPhone5 ? 12.f : 13.f];
        [self.firstBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [self.firstBtn setTitleColor:UIColorFromRGB(0x595757) forState:(UIControlStateNormal)];
        [self.firstBtn addTarget:self action:@selector(firstTimeSelected:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    [self addSubview:_firstBtn];
    
    return _firstBtn;
}

- (void)firstTimeSelected:(UIButton *)sender {
    
   // NSArray *nameArray = @[@"112",@"331",@"32344",@"677"];
    //CGFloat height = 80;
    //if (UpDownView == nil) {
        
      //  if (otherDownView != nil) {
        //    [otherDownView hiddenActionBtn:self.sencondBtn];
          //  [self downDealloc];
       // }

        
       // UpDownView = [[LJQUpDown alloc] showDropDown:sender Height:height rowHeight:20 NameArr:nameArray ImageArr:nil AnimatonFlag:@"down"];
       // __weak typeof(self) weakSelf = self;
       // UpDownView.ClickOnblock = ^(NSInteger index,NSString *string) {
         //   NSLog(@"%ld---%@",index,string);
          //  [weakSelf ViewDealloc];
       // };
   // }else {
     //   [UpDownView hiddenActionBtn:sender];
      //  [self ViewDealloc];
   // }
    
    if (sender.selected) {
        sender.selected = !sender.selected;
        [self removeLeftvIEW];
    }else {
        sender.selected = !sender.selected;
        [self createLeftDatePicker];
        [self removeRightViewgg];
    }

    
}

- (void)ViewDealloc {
    UpDownView = nil;
}


- (UIButton *)sencondBtn {
    if (!_sencondBtn ) {
        self.sencondBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.sencondBtn setBackgroundImage:[UIImage imageNamed:@"查询框"] forState:(UIControlStateNormal)];
        [self.sencondBtn setBackgroundImage:[UIImage imageNamed:@"查询框"] forState:(UIControlStateHighlighted)];
        [self.sencondBtn setTitle:[self nowDate] forState:(UIControlStateNormal)];
        self.sencondBtn.titleLabel.font = [UIFont systemFontOfSize:iPhone5 ? 12.f : 13.f];
        [self.sencondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [self.sencondBtn setTitleColor:UIColorFromRGB(0x595757) forState:(UIControlStateNormal)];
        [self.sencondBtn addTarget:self action:@selector(sencondTimeSelected:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    [self addSubview:_sencondBtn];
    return _sencondBtn;
}

- (void)sencondTimeSelected:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = !sender.selected;
        [self removeRightViewgg];
    }else {
        sender.selected = !sender.selected;
        [self createDatePicker];
        [self removeLeftvIEW];
    }

}

- (void)downDealloc {
    otherDownView = nil;
}

//创建时间选择器
- (void)createDatePicker {
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, DMDeviceHeight - 230, DMDeviceWidth, 200)];
    self.rightView.backgroundColor = [UIColor whiteColor];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    datePicker.center = CGPointMake(DMDeviceWidth / 2, 100);
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSTimeInterval oneYearTime = 365 * 24 * 60 * 60;
    NSDate *todayDate = [NSDate date];
    
    NSDate *oneYearFromToday = [todayDate dateByAddingTimeInterval:- 10 * oneYearTime];
    NSDate *twoYearsFromToday = [todayDate dateByAddingTimeInterval:10 * oneYearTime];
    datePicker.minimumDate = oneYearFromToday;
    datePicker.maximumDate = twoYearsFromToday;
    
    [datePicker addTarget:self
                          action:@selector(datePickerDateChanged:)
                forControlEvents:UIControlEventValueChanged];
    
    [self.rightView addSubview:datePicker];
    
    
    UIButton *cancleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancleBtn setFrame:CGRectMake(20, 0, 30, 30)];
    [cancleBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [cancleBtn addTarget:self action:@selector(RightcancleAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [cancleBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [self.rightView addSubview:cancleBtn];
    
    UIButton *finshBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [finshBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [finshBtn setFrame:CGRectMake(SCREENWIDTH - 50, 0, 30, 30)];
    finshBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [finshBtn addTarget:self action:@selector(RightfinshBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [finshBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [self.rightView addSubview:finshBtn];

    
    [[UIApplication sharedApplication].keyWindow addSubview:self.rightView];
}

- (void)RightcancleAction:(UIButton *)sender {
    //取消
    self.sencondBtn.selected = !self.sencondBtn.selected;
    [self removeRightViewgg];
}

- (void)RightfinshBtnAction:(UIButton *)sender {
    //确认
    self.sencondBtn.selected = !self.sencondBtn.selected;
    [self removeRightViewgg];
    self.rightTime(self.sencondBtn.titleLabel.text);
}

- (void)datePickerDateChanged:(UIDatePicker *)datePicker {
    [self.sencondBtn setTitle:[self returnTimeStringDate:datePicker.date] forState:(UIControlStateNormal)];
    //self.rightTime([self returnTimeStringDate:datePicker.date]);
}

- (void)removeRightViewgg {
    [self.rightView removeFromSuperview];
    self.rightView = nil;
}

- (void)createLeftDatePicker {
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, DMDeviceHeight - 230, DMDeviceWidth, 200)];
    self.leftView.backgroundColor = [UIColor whiteColor];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    datePicker.center = CGPointMake(DMDeviceWidth / 2, 100);
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSTimeInterval oneYearTime = 365 * 24 * 60 * 60;
    NSDate *todayDate = [NSDate date];
    
    NSDate *oneYearFromToday = [todayDate dateByAddingTimeInterval:- 10 * oneYearTime];
    NSDate *twoYearsFromToday = [todayDate dateByAddingTimeInterval:10 * oneYearTime];
    datePicker.minimumDate = oneYearFromToday;
    datePicker.maximumDate = twoYearsFromToday;
    
    [datePicker addTarget:self
                   action:@selector(LeftdatePickerDateChanged:)
         forControlEvents:UIControlEventValueChanged];
    
    [self.leftView addSubview:datePicker];
    
    UIButton *cancleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancleBtn setFrame:CGRectMake(20, 0, 30, 30)];
    [cancleBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [cancleBtn addTarget:self action:@selector(LeftcancleAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [cancleBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [self.leftView addSubview:cancleBtn];
    
    UIButton *finshBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [finshBtn setTitle:@"确定" forState:(UIControlStateNormal)];
     [finshBtn setFrame:CGRectMake(SCREENWIDTH - 50, 0, 30, 30)];
    finshBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [finshBtn addTarget:self action:@selector(LeftfinshBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [finshBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [self.leftView addSubview:finshBtn];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.leftView];
}

- (void)LeftcancleAction:(UIButton *)sender {
    //取消
    self.firstBtn.selected = !self.firstBtn.selected;
    [self removeLeftvIEW];
}

- (void)LeftfinshBtnAction:(UIButton *)sender {
    //确认
    self.firstBtn.selected = !self.firstBtn.selected;
    [self removeLeftvIEW];
    self.leftTime(self.firstBtn.titleLabel.text);
}

- (void)LeftdatePickerDateChanged:(UIDatePicker *)datePicker {
    [self.firstBtn setTitle:[self returnTimeStringDate:datePicker.date] forState:(UIControlStateNormal)];
    //self.leftTime([self returnTimeStringDate:datePicker.date]);
}

- (void)removeLeftvIEW {
    [self.leftView removeFromSuperview];
    self.leftView = nil;
}


- (void)dismiss {
    [self.leftView removeFromSuperview];
    [self.rightView removeFromSuperview];
    self.leftView = nil;
    self.rightView = nil;
}

- (NSString *)returnTimeStringDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

- (NSString *)nowDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

@end
