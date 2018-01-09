//
//  DMRightSlideMenuView.h
//  豆蔓理财
//
//  Created by edz on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol DMSlideMenuView <NSObject>

-(void)LeftMenuViewClick:(NSInteger)tag;

@end



@interface DMRightSlideMenuView : UIView

@property (nonatomic ,weak)id <DMSlideMenuView> customDelegate;



@end
