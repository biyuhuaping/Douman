//
//  AppDelegate.m
//  豆蔓理财
//
//  Created by edz on 2016/11/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "AppDelegate.h"
#import "HMTabBarViewController.h"
#import "HMNavigationController.h"
#import "LLLockViewController.h"
#import "DMLoginViewController.h"
#import "DMLoginRequestManager.h"
#import "common.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "GZFilteredProtocol.h"

#define LockSecond 60
#define LoginSecond 1800

@interface AppDelegate ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger second;

@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic) NSInteger repeatSecond;   // 记录循环登录时间

@property (nonatomic, strong)NSThread *thread;

@property (nonatomic, strong) CLTShareView *shareView;



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //[NSURLProtocol registerClass:[GZFilteredProtocol class]];
    
    //状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];

    if (AccessToken) {
        NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassWord"];
        [[DMLoginRequestManager manager] loginWithUserName:PhoneNumber PassWord:passWord Success:^() {
            
        } Faild:^{
            [[DMLoginRequestManager manager] exit];
        }];
    }
    HMTabBarViewController * hmtab = [[HMTabBarViewController alloc]init];
    self.window.rootViewController = hmtab;
    
    //友盟统计
    UMConfigInstance.appKey = @"58759438f43e4808fb002442";
    UMConfigInstance.channelId = @"App Store"; //应用的渠道标识，默认为App Store
    [MobClick startWithConfigure:UMConfigInstance];
    
    //分享
    [UMSocialWechatHandler setWXAppId:@"wx7fc84b3b9ce4ad60" appSecret:@"d2dcbdfbc9133daa89ab2779c2219df3" url:@""];
    
    //AZT_PDFReader
    screenScale = [[UIScreen mainScreen] scale];
    
    // 循环登录
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.repeatSecond = LoginSecond;
        self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(subSeconds) userInfo:nil repeats:YES];
    });
    
    [self isNetWorking];
    
    [self.window addSubview:self.shareView];
    self.shareView.alpha = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    return YES;
}

- (void)isNetWorking {
    //开启网络指示器
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"reachability"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"1");
        }
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
             [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"reachability"];
             [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"1");
        }
        if (status == AFNetworkReachabilityStatusUnknown) {
             [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"reachability"];
             [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"0");
        }
        if (status == AFNetworkReachabilityStatusNotReachable) {
             [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"reachability"];
             [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"0");
        }
    }];
    [manager startMonitoring];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [UMSocialSnsService handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:nil];

    self.second = LockSecond;
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(subSecond) userInfo:nil repeats:YES];
            }
        });
    });
    
    
    [self.timer1 invalidate];
    self.timer1 = nil;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    //即将进入活跃状态，刷新用户之前登录保存的token
    if (AccessToken) {
       NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassWord"];
        [[DMLoginRequestManager manager] loginWithUserName:PhoneNumber PassWord:passWord Success:^() {
            
        } Faild:^{
            
        }];
    }
    
    self.repeatSecond = LoginSecond;
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(subSeconds) userInfo:nil repeats:YES];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (self.second < 1 && Lock) {
        // 手势解锁相关
        NSString* pswd = [LLLockPassword loadLockPassword];
        if (pswd) {
            [self showLLLockViewController:LLLockViewTypeCheck];
        }
        
    }

}

- (void)subSeconds{
    if (self.repeatSecond > 0) {
        self.repeatSecond --;
    }else{
        self.repeatSecond = LoginSecond;
        if (AccessToken) {
            NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassWord"];
            [[DMLoginRequestManager manager] loginWithUserName:PhoneNumber PassWord:passWord Success:^() {
                
            } Faild:^{
                
            }];
        }
    }
}

- (void)subSecond{
    if (self.second > 0) {
        self.second -- ;
    }else{
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)showLLLockViewController:(LLLockViewType)type
{
    self.second = LockSecond;
    if(self.window.rootViewController.presentingViewController == nil){
        LLLockViewController *lockVC = [[LLLockViewController alloc] initWithType:type];
        HMNavigationController *lockNav = [[HMNavigationController alloc] initWithRootViewController:lockVC];
        [self.window.rootViewController presentViewController:lockNav animated:NO completion:nil];
    }
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (CLTShareView *)shareView{
    if (!_shareView) {
        self.shareView = [[CLTShareView alloc] init];
    }
    return _shareView;
}


- (void)userDidTakeScreenshot:(NSNotification *)notification{
    if ([WXApi isWXAppInstalled]) {
        
        UIImage *image = [self imageWithScreenshot];
        [self.shareView show];
        
        __weak __typeof(self) weakSelf = self;
        _shareView.wechatBlock = ^(NSInteger index){
            if (index == 0) {
                [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
                
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil  image:image location:nil urlResource:nil presentedController:weakSelf.window.rootViewController completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        
                    }
                }];
            }else{
                [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil  image:image location:nil urlResource:nil presentedController:weakSelf.window.rootViewController completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        
                    }
                }];
            }
        };
    }
}


- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}


@end
