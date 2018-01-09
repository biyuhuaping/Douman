//
//  DMBaseViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMBaseViewController.h"
#import "DMHomeViewController.h"
#import <UMMobClick/MobClick.h>
@interface DMBaseViewController ()

@end


static NSString *refreshImage = @"refresh_robot";

@implementation DMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mainBack;

    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    if([self isKindOfClass:[DMHomeViewController class]]){
       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else {
       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }

    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x00c79f)} forState:UIControlStateSelected];

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:UIColorFromRGB(0x4b5159)}];
    
    _back = [UIButton buttonWithType:UIButtonTypeCustom];
    _back.frame = CGRectMake(0, 0, 22/2, 40/2);
    [_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected ];
    [_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _back.titleLabel.font = [UIFont systemFontOfSize:14];
    [_back addTarget: self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_back];
    
}

- (void)backClick:(id)sender{
    
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

- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [formatter stringFromNumber:money];
}


- (NSString *)returnDecimalString:(NSString *)string {
    
    NSString *Decimal;
    
    if ([string containsString:@"."]) {
        Decimal = string;
    }else {
        Decimal = [string stringByAppendingString:@".00"];
    }
    
    return Decimal;
}

- (BOOL) isEmpty:(NSString *)string{
    
    if ([string isKindOfClass:[NSNumber class]]) {
        if ([[NSString stringWithFormat:@"%@",string] isEqualToString:@"0"]) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if (string == nil || string == NULL || ![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


- (void)alertShowMessage:(NSString *)string cancelString:(NSString *)cancelString confirmString:(NSString *)confirmString action:(SEL)actionnn actionOther:(SEL)otherActtion{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:confirmString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (actionnn) {
            //创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
            NSMethodSignature *sigg = [NSNumber instanceMethodSignatureForSelector:@selector(init)];
            NSInvocation *invocatin = [NSInvocation invocationWithMethodSignature:sigg];
            [invocatin setTarget:self];
            [invocatin setSelector:actionnn];
            [invocatin invoke];
        }
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelString style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (otherActtion) {
            //创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
            NSMethodSignature *sigg = [NSNumber instanceMethodSignatureForSelector:@selector(init)];
            NSInvocation *invocatin = [NSInvocation invocationWithMethodSignature:sigg];
            [invocatin setTarget:self];
            [invocatin setSelector:actionnn];
            [invocatin invoke];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:libraryAction];
    
    [self.navigationController presentViewController:alert animated:YES completion:^{
        
        
    }];
}

#pragma 插入图片
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


- (MJRefreshGifHeader *)setRefreshHeader:(void (^)())refresh{
    MJRefreshGifHeader *header  = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        if (refresh) {
            refresh();
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = UIColorFromRGB(0xbababa);
    [header setImages:@[[UIImage imageNamed:refreshImage]] forState:MJRefreshStateIdle];
    [header setImages:@[[UIImage imageNamed:refreshImage]] forState:MJRefreshStatePulling];
    [header setImages:@[[UIImage imageNamed:refreshImage]] forState:MJRefreshStateRefreshing];
    return header;
}

- (MJRefreshBackGifFooter *)setRefreshFooter:(void(^)())refresh{
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        if (refresh) {
            refresh();
        }
    }];
    footer.stateLabel.textColor = UIColorFromRGB(0xbababa);
    [footer setImages:@[[UIImage imageNamed:refreshImage]] forState:MJRefreshStateIdle];
    [footer setImages:@[[UIImage imageNamed:refreshImage]] forState:MJRefreshStatePulling];
    [footer setImages:@[[UIImage imageNamed:refreshImage]] forState:MJRefreshStateRefreshing];
    return footer;
}

@end
