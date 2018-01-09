//
//  GZCircleProgressView.h
//  Test
//
//  Created by armada on 2016/12/10.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GZCircleProgressViewPopViewProtocol

/**
 * 弹出提示框
 */
- (void)popRemainderView;

/**
 * 蒙层褪去动画
 */
- (void)allMasksFadeAnimation;
@end

@interface GZCircleProgressView : UIView

@property(nonatomic,assign) CGFloat progress;

@property(nonatomic,weak) id<GZCircleProgressViewPopViewProtocol> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                 circleRadius:(CGFloat)radius
              circleLineWidth:(CGFloat)circleLineWidth
                       titles:(NSArray<NSString *> *)titles
                       values:(NSArray<NSString *> *)values
                    dotColors:(NSArray<UIColor *> *)dotColors;

- (void)removeLabelCountTimer;

@end
