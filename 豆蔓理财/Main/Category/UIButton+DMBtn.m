//
//  UIButton+DMBtn.m
//  豆蔓分解
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIButton+DMBtn.h"
#import <objc/runtime.h>



@implementation UIButton (DMBtn)

+ (UIButton *)createBtnType:(UIButtonType)type BtnFrame:(CGRect)frame BtnTittle:(NSString *)tittle state:(UIControlState)state{
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:tittle forState:(state)];
    return button;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(drive)) {
        class_addMethod([self class], sel, class_getMethodImplementation(self, @selector(startEngine:)), "v@:@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

- (void)startEngine:(NSString *)brand {
    NSLog(@"这是什么鬼");
}

- (void)drive {
    
}

@end
