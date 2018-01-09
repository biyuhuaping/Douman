//
//  LJQBaseViewVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQBaseViewVC.h"
#import <UMMobClick/MobClick.h>
@interface LJQBaseViewVC ()

@property (nonatomic, strong)UIButton *back;

@end

@implementation LJQBaseViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:UIColorFromRGB(0x4b5159)}];
    
    _back = [UIButton buttonWithType:UIButtonTypeCustom];
    _back.frame = CGRectMake(0, 0, 22/2, 40/2);
    [_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _back.adjustsImageWhenHighlighted = NO;
    _back.titleLabel.font = [UIFont systemFontOfSize:14];
    [_back addTarget: self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_back];
    
    
}

- (void)backClick:(id)sender

{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.title.length > 0) {
        [MobClick beginLogPageView:self.title];
    }else {
        [MobClick beginLogPageView:self.navigationItem.title];
    }
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.title.length > 0) {
        [MobClick beginLogPageView:self.title];
    }else {
        [MobClick beginLogPageView:self.navigationItem.title];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [formatter stringFromNumber:money];
}

//设置小数点后两位
- (NSString *)returnDecimalString:(NSString *)string {
   
    NSString *Decimal;
    
    if ([string containsString:@"."]) {
        Decimal = string;
    }else {
        Decimal = [string stringByAppendingString:@".00"];
    }
    
    return Decimal;
}


//创建图片附件
- (NSAttributedString *)pitcureStringName:(NSString *)imageName imageBounds:(CGRect)imageBounds{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:imageName];
    attach.bounds = imageBounds;
    NSAttributedString *attachStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    return attachStr;
}

- (NSMutableAttributedString *)returenAttribute:(NSString *)string imageName:(NSString *)imageName imageBounds:(CGRect)imageBounds index:(NSInteger)index{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute insertAttributedString:[self pitcureStringName:imageName imageBounds:imageBounds] atIndex:index];
    
    return attribute;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
