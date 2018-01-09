//
//  LJQSettingMessageVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQSettingMessageVC.h"

@interface LJQSettingMessageVC ()

@property (nonatomic, strong)UISwitch *mySwitch;
@property (nonatomic, strong)UIView *promptView;

@end

@implementation LJQSettingMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"消息设置";
    
    UIImage *image = [UIImage imageNamed:@"接收消息"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp];
    [self.view addSubview:[self CreateBottomView:28 + image.size.height + 1]];
}

- (void)setUp {
    UIImage *image = [UIImage imageNamed:@"接收消息"];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 28 + image.size.height)];
    [self.view addSubview:bottomView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageV.center = CGPointMake(image.size.width / 2 + 10, bottomView.frame.size.height / 2);
    imageV.image = image;
    [bottomView addSubview:imageV];
    
    UILabel *label = [UILabel createLabelFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 15, 14, 100, image.size.height) labelColor:UIColorFromRGB(0x6d727a) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
    label.text = @"接收消息";
    [bottomView addSubview:label];
    
    self.mySwitch  = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    self.mySwitch.center = CGPointMake(SCREENWIDTH - 40, bottomView.frame.size.height / 2);
    [self.mySwitch addTarget:self action:@selector(IsOrReceive:) forControlEvents:(UIControlEventTouchUpInside)];
    self.mySwitch.on = YES;
    [bottomView addSubview:self.mySwitch];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, LJQ_VIEW_MaxY(bottomView), SCREENWIDTH, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:lineView];
    
}

- (UIView *)CreateBottomView:(CGFloat)height {
    self.promptView = [[UIView alloc] initWithFrame:CGRectMake(0, height, SCREENWIDTH, 200)];
    self.promptView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel *label = [UILabel createLabelFrame:CGRectMake(30, 27, 300, 13) labelColor:UIColorFromRGB(0x71757e) textAlignment:(NSTextAlignmentLeft) textFont:13.f];
    label.text = @"开启消息通知您收到一下消息：";
    [self.promptView addSubview:label];
    CGFloat maxy = CGRectGetMaxY(label.frame) +10;
    NSArray *array = @[@"1.账户资金变动：充值、提现、结息、回款；",@"2.卡券发放、使用、过期提示",@"3.活动及奖励到账通知"];
    for (int i = 0; i < array.count; i++) {
        NSString *string = [NSString stringWithFormat:@"%@",array[i]];
        CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH - 60, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} context:nil];
        
        UILabel *label1 = [UILabel createLabelFrame:CGRectMake(30, maxy, SCREENWIDTH - 60, rect.size.height) labelColor:UIColorFromRGB(0xb4b4b4) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        label1.numberOfLines = 0;
        label1.text = array[i];
        [self.promptView addSubview:label1];
        
        maxy = rect.size.height + maxy;
    }
    
    return self.promptView;
}

- (void)IsOrReceive:(UISwitch *)withc {
    if (withc.on) {
          NSLog(@"打开");
    }else {
        NSLog(@"关闭");
    }
}


@end
