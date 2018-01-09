//
//  DMProgressHUD.h
//  豆蔓理财
//
//  Created by edz on 2017/5/8.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMHUDSHOW) {
    DMHUDTIED_CARD,
    DMHUDGET_INTO
};

@interface DMProgressHUD : UIView



@property (nonatomic, assign)BOOL tiedCard; // 



+ (instancetype)showHUD;//实现绑卡hud
+ (void)hideHUD;//清除绑卡hud\




@end
