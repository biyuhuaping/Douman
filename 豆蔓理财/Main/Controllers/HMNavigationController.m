//
//  HMNavigationController.m
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMNavigationController.h"


#import "UIImage+Extension.h"
#import "UIBarButtonItem+Extension.h"


@interface HMNavigationController ()

@end

@implementation HMNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
/**
 *  当导航控制器的view创建完毕就调用
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self)weakSelf = self;
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

/**
 *  当第一次使用这个类的时候调用1次
 */
+ (void)initialize
{
    // 设置UINavigationBarTheme的主
    [self setupNavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
}

+ (void)load {
    // 设置UINavigationBarTheme的主
    [self setupNavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 设置导航栏背景
//    if (!iOS7) {
//        [appearance setBackgroundImage:[UIImage imageWithName:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
//    }
    // 设置导航栏背景颜色
    [appearance setBarTintColor:[UIColor whiteColor]];
    
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarBackground"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x595757);
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs];
}

//2919736842

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeZero;
    shadow.shadowColor = UIColorFromRGB(0x595757);
    textAttrs[NSShadowAttributeName] = shadow;
    
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
       
        if (isOrEmpty(barHidden)) {
           viewController.hidesBottomBarWhenPushed = YES; 
        }
        
        
        
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"返回按钮" highImageName:@"返回按钮" target:self action:@selector(back)];
        viewController.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0xfffffff);
    }
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0x595757),NSFontAttributeName:[UIFont systemFontOfSize:17]};
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
//#warning 这里用的是self, 因为self就是当前正在使用的导航控制器
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}
@end
