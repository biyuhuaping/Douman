//
//  DMSlideMenuView.h
//  豆蔓理财
//
//  Created by edz on 2016/11/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DMSlideMenuView <NSObject>

-(void)LeftMenuViewClick:(NSInteger)tag;

@end

@interface DMSlideMenuView : UIView

@property (nonatomic ,weak)id <DMSlideMenuView> customDelegate;
@property (nonatomic, strong)UIButton *landedBtn;

@end
