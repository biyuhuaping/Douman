//
//  LJQMoveTransition.m
//  豆蔓理财
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQMoveTransition.h"
#import "DMMineViewController.h"
#import "DMHoldCreditViewController.h"

#import "LJQMineCell.h"

@implementation LJQMoveTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    DMMineViewController *fromVC = (DMMineViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DMHoldCreditViewController *toVC = (DMHoldCreditViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containView = [transitionContext containerView];
    
   // LJQMineCell *cell = (LJQMineCell *)[fromVC.MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
  //  fromVC.finalCellRect = [containView convertRect:cell.pieChartView.frame fromView:cell.pieChartView.superview];
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
   
    [containView addSubview:toVC.view];
    [containView addSubview:toVC.pieChartView];
    
  //  toVC.pieChartView.frame = cell.pieChartView.frame;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [containView layoutIfNeeded];
        toVC.view.alpha = 1.0;
        toVC.pieChartView.frame = [containView convertRect:toVC.pieChartView.frame fromView:toVC.pieChartView.superview];
    } completion:^(BOOL finished) {
        //告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

}

@end
