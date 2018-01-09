//
//  DMBaseViewController.h
//  豆蔓理财
//
//  Created by edz on 2016/11/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "UILabel+init.h"
#import "UIButton+DMBtn.h"

@interface DMBaseViewController : UIViewController

@property (nonatomic, strong)UIImageView *img ;
@property (nonatomic, strong)UIButton *back;

- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money;

- (NSString *)returnDecimalString:(NSString *)string;

- (BOOL) isEmpty:(NSString *)string;

- (void)alertShowMessage:(NSString *)string cancelString:(NSString *)cancelString confirmString:(NSString *)confirmString action:(SEL)actionnn actionOther:(SEL)otherActtion;

//只加载图片
- (NSAttributedString *)pitcureStringName:(NSString *)imageName imageBounds:(CGRect)imageBounds;

//文字和图片
- (NSMutableAttributedString *)returenAttribute:(NSString *)string imageName:(NSString *)imageName imageBounds:(CGRect)imageBounds index:(NSInteger)index;

- (MJRefreshGifHeader *)setRefreshHeader:(void(^)())refresh;

- (MJRefreshBackGifFooter *)setRefreshFooter:(void(^)())refresh;
@end
