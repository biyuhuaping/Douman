//
//  LJQSuccessWithDrawalVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQSuccessWithDrawalVC.h"

@interface LJQSuccessWithDrawalVC ()

@property (nonatomic, strong)UIView *promptView;

@end

@implementation LJQSuccessWithDrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"提现";
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"申请成功"];
   UIView *view1 = [self setUpImageName:@"申请成功" StrColor:UIColorFromRGB(0x1ac67e) label:@"申请成功" label2:[self withDrawalNowDate]];
    view1.center = CGPointMake(SCREENWIDTH / 2, 47 + image.size.height / 2);
    [self.view addSubview:view1];
    
    UIImage *iamge2 = [UIImage imageNamed:@"形状-5"];
    UIImageView *pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(view1.frame) + image.size.width / 2, LJQ_VIEW_MaxY(view1) + 8, iamge2.size.width, iamge2.size.height)];
    pitcureView.image = iamge2;
    [self.view addSubview:pitcureView];
    
    UIView *view2 = [self setUpImageName:@"形状-4" StrColor:UIColorFromRGB(0x6d727a) label:@"资金到账" label2:@"预计1-2个工作日到账"];
    view2.center = CGPointMake(SCREENWIDTH / 2, LJQ_VIEW_MaxY(pitcureView) + 8 + image.size.height / 2);
    [self.view addSubview:view2];
    
    UIImage *image2 = [UIImage imageNamed:@"完成"];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake((SCREENWIDTH - image2.size.width) / 2, LJQ_VIEW_MaxY(view2) + 50, image2.size.width, image2.size.height);
    [button setBackgroundImage:image2 forState:(UIControlStateNormal)];
    [button setBackgroundImage:image2 forState:(UIControlStateHighlighted)];
    [button addTarget: self action:@selector(SuccessAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    [self.view addSubview:[self CreateBottomView:41.f + LJQ_VIEW_MaxY(button)]];

    UILabel *firstLabel = [UILabel createLabelFrame:CGRectMake(0, LJQ_VIEW_Height(self.view) - 46 - 60, SCREENWIDTH, 13) labelColor:UIColorFromRGB(0x6d727a) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
    firstLabel.text = @"客服热线";
    [self.view addSubview:firstLabel];
    
    UILabel *secondLabel = [UILabel createLabelFrame:CGRectMake(0, LJQ_VIEW_Height(self.view) - 33 - 60, SCREENWIDTH, 13) labelColor:UIColorFromRGB(0x6d727a) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
    secondLabel.text = @"400-003-3939";
    [self.view addSubview:secondLabel];
}

- (UIView *)setUpImageName:(NSString *)imageName StrColor:(UIColor *)color label:(NSString *)string1 label2:(NSString *)string2 {
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIImageView *pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    pitcureView.image = image;
    
    UILabel *label = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_MaxX(pitcureView) + 10, 0, 60, 15) labelColor:color textAlignment:(NSTextAlignmentLeft) textFont:14.f];
    label.text = string1;
    
    UILabel *timeLabel = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_MaxX(pitcureView) + 10, LJQ_VIEW_MaxY(label) + 8, 130, 12) labelColor:UIColorFromRGB(0xa8abb1) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
    timeLabel.text = string2;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130 + LJQ_VIEW_MaxX(pitcureView) + 10, image.size.height)];
    [view addSubview:pitcureView];
    [view addSubview:label];
    [view addSubview:timeLabel];
    return view;
}

- (UIView *)CreateBottomView:(CGFloat)space {
    self.promptView = [[UIView alloc] initWithFrame:CGRectMake(0, space, SCREENWIDTH, 50)];
    self.promptView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel *label = [UILabel createLabelFrame:CGRectMake(30, 0, 100, 13) labelColor:UIColorFromRGB(0x6d727a) textAlignment:(NSTextAlignmentLeft) textFont:13.f];
    label.text = @"温馨提示";
    [self.promptView addSubview:label];
    CGFloat maxy = CGRectGetMaxY(label.frame) +10;
    NSArray *array = @[@"双休日和法定节假日期间，用户可以申请提现，豆蔓智投会在下一个工作日进行处理。"];
    for (int i = 0; i < array.count; i++) {
        NSString *string = [NSString stringWithFormat:@"%@",array[i]];
        CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH - 60, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} context:nil];
        
        UILabel *label1 = [UILabel createLabelFrame:CGRectMake(30, maxy, SCREENWIDTH - 60, rect.size.height) labelColor:UIColorFromRGB(0xa8abb1) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        label1.numberOfLines = 0;
        label1.text = array[i];
        [self.promptView addSubview:label1];
        
        maxy = rect.size.height + maxy;
    }
    
    return self.promptView;
}



- (void)SuccessAction:(UIButton *)sender {
    NSLog(@"完成");
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (NSString *)withDrawalNowDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}



@end
