//
//  DMProgressHUD.m
//  豆蔓理财
//
//  Created by edz on 2017/5/8.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMProgressHUD.h"

@interface DMProgressHUD ()

@property (nonatomic, strong)UIView *popView;



@end


@implementation DMProgressHUD

static DMProgressHUD *hud = nil;

+ (instancetype)showHUD {
    
    hud = [[self alloc] init];
    return hud;
}

+ (void)hideHUD{
    
    [hud hidehud];

}


- (void) hidehud {
    
    [_popView removeFromSuperview];
    
}

- (id) init {
    
    
    _popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight)];
    _popView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _popView.userInteractionEnabled = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];

    
    UIImageView *img = [[UIImageView alloc] init];
    
    if (self.tiedCard) {
        
        img.frame = CGRectMake((DMDeviceWidth - 321/2)/2, (DMDeviceHeight - 182/2)/2, 321/2, 182/2);
        img.image = [UIImage imageNamed:@"正在努力绑卡"];
    } else {
        
        img.frame = CGRectMake((DMDeviceWidth - 506/2)/2, (DMDeviceHeight - 147/2)/2, 506/2, 147/2);
        img.image = [UIImage imageNamed:@"即将进入徽商"];
    }
    
    
    [_popView addSubview:img];
    
    
    return self;
    
}


@end
