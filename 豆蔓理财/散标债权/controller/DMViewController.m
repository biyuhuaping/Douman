//
//  DMViewController.m
//  豆蔓理财
//
//  Created by edz on 2017/7/31.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMViewController.h"
#import "DMScafferCreditVC.h"
#import "DMSelectProductVC.h"
#import "DMAdzukibeanRobtVC.h"
#import "MenuButton.h"

@interface DMViewController ()<MenuButtonDelegate>
{
    DMSelectProductVC *productVC;
    DMScafferCreditVC *scafferVC;
    DMAdzukibeanRobtVC *robotVC;
}
@property (nonatomic, strong) MenuButton *menuBtn;

@property (nonatomic, strong)DMBaseViewController *currentVC;
@property (nonatomic, strong) NSArray *vcArray;
@end

@implementation DMViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"exchange" object:nil];
        self.tabBar.hidden = YES;
        [self setNavBar];
        scafferVC = [[DMScafferCreditVC alloc] init];
        productVC = [[DMSelectProductVC alloc] init];
        robotVC = [[DMAdzukibeanRobtVC alloc] init];
        self.viewControllers = @[scafferVC,productVC,robotVC];
        self.selectedIndex = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
}

- (void)receiveMessage:(NSNotification *)notification{
    if ([notification.name isEqualToString:@"exchange"]) {
        NSInteger index = [notification.userInfo[@"index"] integerValue];
        [self.menuBtn setSelectButtonWithIndex:index];
        [self setChoseWithIndex:index];
    }
}


- (void)setNavBar {
    self.navigationController.navigationBar.translucent = NO;
    self.menuBtn = [[MenuButton alloc] initWithFrame:CGRectMake(0, 20, DMDeviceWidth-20, 44) TitleArray:@[@"债权专区",@"我要出借",@"小豆机器人"] SelectColor:UIColorFromRGB(0x00c79f) UnselectColor:UIColorFromRGB(0x4b5159)];
    self.menuBtn.delegate = self;
    [self.menuBtn setSelectButtonWithIndex:1];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.titleView = self.menuBtn;
}

- (void)selectButtonWithIndex:(NSInteger)index{
    [self setChoseWithIndex:index];
}

- (void)setChoseWithIndex:(NSInteger )index{
    self.selectedIndex = index;
}


@end
