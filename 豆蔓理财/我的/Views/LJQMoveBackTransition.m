//
//  LJQMoveBackTransition.m
//  豆蔓理财
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQMoveBackTransition.h"
#import "DMMineViewController.h"
#import "DMHoldCreditViewController.h"
#import "LJQMineCell.h"

@implementation LJQMoveBackTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    DMMineViewController *toVC = (DMMineViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    DMHoldCreditViewController *fromVC = (DMHoldCreditViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    
   // LJQMineCell *cell = (LJQMineCell *)[toVC.MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    toVC.view.alpha = 0;
   // [containerView insertSubview:toVC.view belowSubview:fromVC.view];
   // [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:toVC.view];
   // [containerView addSubview:cell.pieChartView];
    
    //发生动画
  //  cell.pieChartView.frame = fromVC.pieChartView.frame;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toVC.view.alpha = 1.0f;
    //    cell.pieChartView.frame = toVC.finalCellRect;
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];

}

@end
