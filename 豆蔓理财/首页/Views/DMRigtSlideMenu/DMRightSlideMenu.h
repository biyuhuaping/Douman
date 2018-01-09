//
//  DMRightSlideMenu.h
//  豆蔓理财
//
//  Created by edz on 2016/12/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol DMRightSlideMenu <NSObject>

-(void)SPanGestureRecognizer;

@end



@interface DMRightSlideMenu : UIView




+(instancetype)MenuViewWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover;

/**
 *  初始化方法
 *
 *  @param dependencyView 传入需要滑出菜单的控制器的view
 *  @param leftmenuView   传入需要显示的菜单的view
 *  @param isCover        bool值，是否有右边遮挡的阴影
 *
 *  @return self
 */
-(instancetype)initWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover;

@property (nonatomic, weak)id<DMRightSlideMenu> delegate;

/**
 *  展开菜单，可放进点击事件内
 */
-(void)show;

-(void)remove;

-(void)add;

/**
 *  关闭菜单不带动画效果
 */
-(void)hidenWithoutAnimation;
/**
 *  关闭菜单带动画效果
 */
-(void)hidenWithAnimation;

@end
