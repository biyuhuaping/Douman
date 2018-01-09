//
//  HMTabBarViewController.m
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMTabBarViewController.h"
#import "HMNavigationController.h"

#import "UIImage+Extension.h"
#import "LunchView.h"
#import "DMMoneyViewController.h"
#import "DMMineViewController.h"
#import "DMWebUrlManager.h"
#import "DMHomeViewController.h"
#import "GZDiscoveryViewController.h"
#import "DMWebViewController.h"
#import "ZJDrawerController.h"
#import "DMSettingViewController.h"
#import "DMScafferCreditVC.h"
#import "DMViewController.h"
@interface HMTabBarViewController ()

@end

#define kInfoDictionary  [[NSBundle mainBundle] infoDictionary]
#define kVersion [kInfoDictionary objectForKey:@"CFBundleShortVersionString"]
#define kBuild [kInfoDictionary objectForKey:@"CFBundleVersion"]
#define kIdentifier [NSString stringWithFormat:@"%@_%@",kVersion,kBuild]


@implementation HMTabBarViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.translucent = NO;

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x00c79f)} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x7b7b7b)} forState:UIControlStateNormal];

    // 添加子控制器
    DMHomeViewController *home = [[DMHomeViewController alloc] init];
    [self addOneChlildVc:home title:@"首页" imageName:@"首页未点击-icon" selectedImageName:@"首页点击-icon"];
    

    DMViewController *message = [[DMViewController alloc] init];
    [self addOneChlildVc:message title:@"出借" imageName:@"出借未点击-icon" selectedImageName:@"出借点击-icon"];
    
//    DMWebViewController *goodCredit = [[DMWebViewController alloc] init];
//    goodCredit.webUrl = [[DMWebUrlManager manager] creditModel];
//    goodCredit.root = YES;
//    [self addOneChlildVc:goodCredit title:@"优质资产" imageName:@"理财默认" selectedImageName:@"理财选中"];
//    goodCredit.type = @"model";
//    goodCredit.navigationItem.title = @"优质资产";
    
    
//    GZDiscoveryViewController *dvc = [[GZDiscoveryViewController alloc] init];
//    dvc.navigationItem.title = @"发现";
//    [self addOneChlildVc:dvc title:@"发现" imageName:@"发现-默认" selectedImageName:@"发现-选中"];
    
    DMMineViewController *discover = [[DMMineViewController alloc] init];
    [self addOneChlildVc:discover title:@"我的" imageName:@"我的未点击-icon" selectedImageName:@"我的点击-icon"];

    
    if([self isNotFirstLaunch]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!PhoneNumber) {
                [home loadPrivateEnjoymentForFreshScene];
            }
        });
    }else{
        LunchView *lunchView = [[LunchView alloc] initWithFrame:DMDeviceFrame];
        [self.view addSubview:lunchView];
        lunchView.start = ^(){
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kIdentifier];
            [home loadPrivateEnjoymentForFreshScene];
        };
    }
}

- (BOOL)isNotFirstLaunch{
    BOOL firstLaunch = [[[NSUserDefaults standardUserDefaults] objectForKey:kIdentifier] boolValue];
    if (!firstLaunch) {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kIdentifier];
    }
    return firstLaunch;
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置标题
    // 相当于同时设置了tabBarItem.title和navigationItem.title
    childVc.title = title;
    
    // 设置图标
    childVc.tabBarItem.image = [[UIImage imageWithName:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (iOS7) {
        // 声明这张图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    // 添加为tabbar控制器的子控制器
    
    HMNavigationController *nav = [[HMNavigationController alloc] initWithRootViewController:childVc];

    [self addChildViewController:nav];
    
}




@end
