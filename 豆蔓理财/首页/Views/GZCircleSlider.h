//
//  GZCircleSlider.h
//  GZCircleSliderWithPanGuestrue
//
//  Created by armada on 2016/11/29.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GZCircleHandleStyle) {
    
    //circleHandle with no effect
    GZCircleHandleNone,
    
    //circleHandle with gradient
    GZCircleHandleWithGradient
};

//更新页面代理
@protocol GZCircleSliderDelegate <NSObject>

- (void)circleSliderChangeToIndex:(int)index;

@end


@interface GZCircleSlider : UIView

@property(nonatomic,assign) int currentIndex; // range is from 0 to 11

@property(nonatomic,assign) float lineWidth;

@property(nonatomic,weak) id<GZCircleSliderDelegate> delegate;

//产品控件是否被拖动或者点击
@property(nonatomic,assign) BOOL isDraggedOrTapped;

/*!
 * @brief initializer
 * @param frame The frame of GZCircleSlider
 * @param lineWidth Linewidth of circle
 * @param currentIndex Current highlighted index
 * @return Instance of GZCircleSlider
 */
- (instancetype)initWithFrame:(CGRect)frame
                    lineWidth:(float)lineWidth
                  circleColor:(UIColor *)circleColor
                 currentIndex:(int)currentIndex
               andHandleSytle:(GZCircleHandleStyle)handleStyle;

- (void)highlightDots;

- (void)handlePanEnable:(BOOL)enable;

- (void)moveHandleAtIndex:(int)index;


@end
