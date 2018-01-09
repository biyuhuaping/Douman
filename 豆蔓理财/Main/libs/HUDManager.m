//
//  HUDManager.m
//  财路通理财
//
//  Created by wujianqiang on 2016/11/8.
//  Copyright © 2016年 wangguomin. All rights reserved.
//

#import "HUDManager.h"
@interface HUDManager ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation HUDManager

+ (instancetype)manager{
    static HUDManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HUDManager alloc] init];
    });
    return manager;
}


- (void)showHUDWithView:(UIView *)view{
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    

}

- (void)hide{
    [self.hud hide:YES];
    self.hud = nil;
}

- (void)showHudWithText:(NSString *)text{
    if(text){
        __block MBProgressHUD *textHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        textHud.mode = MBProgressHUDModeText;
        textHud.color = [UIColor clearColor];
        textHud.removeFromSuperViewOnHide = YES;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0xffffff);
        label.font = [UIFont systemFontOfSize:15];
//        label.backgroundColor = [UIColor colorWithRed:60/255.0 green:81/255.0 blue:110/255.0 alpha:0.6];
        label.backgroundColor = [UIColor blackColor];
        label.alpha = 0.5;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = text;
        [textHud addSubview:label];
        NSLog(@"---text log--------%@",text);
        CGRect rect;
        if (text.length > 0) {
            rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 36)
                                 options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                 context:nil];
        }else{
            rect = CGRectMake(0, 0, 0, 0);
        }
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(textHud);
            make.width.equalTo(@(rect.size.width+40));
            make.height.equalTo(@36);
        }];
        label.layer.cornerRadius = 18;
        label.layer.masksToBounds = YES;
//        label.layer.borderColor = UIColorFromRGB(0x57bed8).CGColor;
//        label.layer.borderWidth = 1;
        [textHud hide:YES afterDelay:1];
    }else{
        return;
    }
    
}

@end
