//
//  GZHomeSecondSceneViewController.h
//  豆蔓首页分解
//
//  Created by armada on 2016/12/5.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMBaseViewController.h"

@interface GZHomePageViewController : DMBaseViewController

@property(strong, nonatomic) UIWindow *window;

- (void)loadPrivateEnjoymentForFreshScene;

- (void)prepareForNewMemInfoData;

- (void)prepareForBasicElement;

@end
