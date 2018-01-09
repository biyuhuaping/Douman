//
//  DMRightSlideMenu.m
//  豆蔓理财
//
//  Created by edz on 2016/12/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMRightSlideMenu.h"






#define CoverViewAlpha                  0.6

#define ViewWidth                       0.75

#define CoverViewBackGround [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]

@interface DMRightSlideMenu ()

@property (nonatomic ,assign)CGRect         menuViewframe;
@property (nonatomic ,assign)CGRect         coverViewframe;
@property (nonatomic ,strong)UIView         *coverView;
@property (nonatomic ,strong)UIView         *leftMenuView;
@property (nonatomic ,strong)UIView         *ViewC;
@property (nonatomic ,assign)BOOL           isShowCoverView;
@property (nonatomic ,strong)UIScreenEdgePanGestureRecognizer *rightEdgeGesture;

@end


@implementation DMRightSlideMenu

+(instancetype)MenuViewWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover{
    
    DMRightSlideMenu *menu = [[DMRightSlideMenu alloc]initWithDependencyView:dependencyView MenuView:leftmenuView isShowCoverView:isCover];
    
    return menu;
}


-(instancetype)initWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover{
    
    if(self = [super init]){
        self.isShowCoverView = isCover;
        
        if([self.delegate respondsToSelector:@selector(SPanGestureRecognizer)]){
            [self.delegate SPanGestureRecognizer];
            

            
        }

        
        [self addPanGestureAtDependencyView:dependencyView];
        self.leftMenuView = leftmenuView;
        
        self.ViewC = dependencyView;
        
        self.menuViewframe = leftmenuView.frame;
        
        self.coverViewframe = CGRectMake(self.menuViewframe.size.width, self.menuViewframe.origin.y, DMDeviceWidth - self.menuViewframe.size.width, self.menuViewframe.size.height);
    }
    return self;
}

-(void)setIsShowCoverView:(BOOL)isShowCoverView
{
    _isShowCoverView = isShowCoverView;
    
    if(self.isShowCoverView){
        self.coverView.backgroundColor = CoverViewBackGround;
    }else{
        self.coverView.backgroundColor = [UIColor clearColor];
    }
    
}




-(void)addPanGestureAtDependencyView:(UIView *)dependencyView{
    
    // 屏幕边缘pan手势(优先级高于其他手势)
    _rightEdgeGesture = \
    [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleLeftEdgeGesture:)];
    _rightEdgeGesture.edges                             = UIRectEdgeRight;
    [dependencyView addGestureRecognizer:_rightEdgeGesture]; //
    
}

-(void)remove{
    
    [self.ViewC removeGestureRecognizer:_rightEdgeGesture];
    
}

-(void)add {
    
    [self.ViewC addGestureRecognizer:_rightEdgeGesture];
    
}


-(void)show{
    
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.coverView];
    [window addSubview:self.leftMenuView];
    
    self.leftMenuView.frame = CGRectMake(DMDeviceWidth , self.menuViewframe.origin.y, self.menuViewframe.size.width, self.menuViewframe.size.height);
    self.coverView.frame = CGRectMake(0, 0, DMDeviceWidth, self.menuViewframe.size.height);
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.leftMenuView.frame = CGRectMake(DMDeviceWidth*0.25, 0, DMDeviceWidth*ViewWidth, self.menuViewframe.size.height);
        self.coverView.frame  = CGRectMake(0, 0, DMDeviceWidth*0.25, self.menuViewframe.size.height);
        self.ViewC.frame = CGRectMake(-DMDeviceWidth*ViewWidth, 0, DMDeviceWidth, self.menuViewframe.size.height);
        self.coverView.alpha = CoverViewAlpha;
    }];
}



-(void)hidenWithoutAnimation{
    
    [self removeCoverAndMenuView];
}
-(void)hidenWithAnimation{
    
    [self coverTap];
}


#pragma mark - 屏幕右侧菜单
-(UIView *)leftMenuView{
    
    if(_leftMenuView == nil){
        
        UIView *LeftView = [[UIView alloc]initWithFrame:self.menuViewframe];
        _leftMenuView    = LeftView;
        
    }
    return _leftMenuView;
}


#pragma mark - 遮盖
-(UIView *)coverView {
    
    if (_coverView == nil) {
        
        UIView *Cover = [[UIView alloc]initWithFrame:self.coverViewframe];
        Cover.backgroundColor                     = CoverViewBackGround;
        Cover.alpha                               = 0;
        UITapGestureRecognizer *Click             = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverTap)];
        [Cover addGestureRecognizer:Click];
        
        UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handleftPan:)];
        
        [Cover addGestureRecognizer:panGestureRecognizer];
        [Click requireGestureRecognizerToFail:panGestureRecognizer];
        
        _coverView = Cover;
    }
    return _coverView;
}


#pragma mark - 屏幕往左滑处理
- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.coverView];
    [window addSubview:self.leftMenuView];
    
    
    CGPoint translation = [gesture translationInView:gesture.view];
    

    
    
    if(UIGestureRecognizerStateBegan == gesture.state ||
       UIGestureRecognizerStateChanged == gesture.state){
        
        
        
        
        self.ViewC.frame =  CGRectMake(0 + translation.x - DMDeviceWidth*0.25, 0,DMDeviceWidth, DMDeviceHeight);
        
        if( -translation.x +DMDeviceWidth*0.25 <= self.menuViewframe.size.width){
            
            //10像素的地方
            
            
            
            if(-translation.x <= 10){
                self.coverView.frame = CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight);
            }
            
            CGFloat x           = (-translation.x)  - self.menuViewframe.size.width;
            CGFloat y           = self.menuViewframe.origin.y;
            CGFloat w           = self.menuViewframe.size.width;
            CGFloat h           = self.menuViewframe.size.height;
            self.leftMenuView.frame = CGRectMake(-x, y, w, h);
            self.coverView.frame    = CGRectMake(0, 0,-x, h);
            self.coverView.alpha    = CoverViewAlpha*(-translation.x / w);
            
            
        }else{
            
            self.leftMenuView.frame = CGRectMake(DMDeviceWidth*0.25, 0, DMDeviceWidth*ViewWidth, self.menuViewframe.size.height);
            self.coverView.frame  = CGRectMake(0, 0, DMDeviceWidth*0.25, DMDeviceHeight);
            self.ViewC.frame = CGRectMake(-DMDeviceWidth*ViewWidth, 0, DMDeviceWidth, self.menuViewframe.size.height);
            
            
            
            
        }
        
        
        
    }
    else{
        
        if(-translation.x > self.menuViewframe.size.width/2){
            [self openMenuView];
        }else{
            [self closeMenuView:YES];
        }
        
    }
}


#pragma mark - coverView往右滑隐藏
-(void)handleftPan:(UIPanGestureRecognizer*)recognizer{
    
    CGPoint translation = [recognizer translationInView:recognizer.view];
    static CGFloat BeganX;
    
    if(UIGestureRecognizerStateBegan == recognizer.state){
        BeganX = translation.x;
    }
    
    CGFloat Place = (-translation.x) - (-BeganX);

    if (Place >=0 ) {
        
        return;
    }
    

    
    if(UIGestureRecognizerStateBegan == recognizer.state ||
       UIGestureRecognizerStateChanged == recognizer.state){
        
        self.ViewC.frame =   CGRectMake(-DMDeviceWidth*ViewWidth -Place, 0,DMDeviceWidth, DMDeviceHeight);
        
        
        
        CGFloat x           = 0 ;
        CGFloat y           = self.menuViewframe.origin.y;
        CGFloat w           = self.menuViewframe.size.width;
        CGFloat h           = self.menuViewframe.size.height;
        
        if(-Place <= self.leftMenuView.frame.size.width &&  -Place >0){
            
            x  =  Place;
            
            //            self.leftMenuView.frame = CGRectMake(x, y, w, h);
            
            self.coverView.frame    = CGRectMake(0, 0,DMDeviceWidth*0.25-Place, h);
            self.coverView.alpha    = CoverViewAlpha*((w + Place) / w);
            self.leftMenuView.frame = CGRectMake(DMDeviceWidth*0.25-x, y, w, h);
            
        }else if(Place >0){
            

            
        }else{

            self.coverView.frame    = CGRectMake(0, 0,0, h);
            self.coverView.alpha    = CoverViewAlpha;
            self.leftMenuView.frame = CGRectMake(DMDeviceWidth, y, w, h);
        }
        
        
        
        
    }else{
        
        if(-Place > self.menuViewframe.size.width/2){
            
            
            [self closeMenuView:NO];
        }else{
            [self openMenuView];
        }
    }
    
}


-(void)openMenuView{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat x           = DMDeviceWidth*0.25;
        CGFloat y           = self.menuViewframe.origin.y;
        CGFloat w           = self.menuViewframe.size.width;
        CGFloat h           = self.menuViewframe.size.height;
        self.leftMenuView.frame = CGRectMake(x, y, w, h);
        self.coverView.frame    =  CGRectMake(0, 0,x, h);
        self.ViewC.frame = CGRectMake(-DMDeviceWidth*ViewWidth, 0, DMDeviceWidth, self.menuViewframe.size.height);
        self.coverView.alpha    = CoverViewAlpha;
        

        
    }];
}

-(void)closeMenuView:(BOOL)animations{
    
    
    if (animations) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            
            CGFloat y           = self.menuViewframe.origin.y;
            CGFloat w           = self.menuViewframe.size.width;
            CGFloat h           = self.menuViewframe.size.height;
            self.leftMenuView.frame = CGRectMake(DMDeviceWidth, y, w, h);//self.LeftViewFrame;
            self.coverView.frame    = CGRectMake(0, 0,DMDeviceWidth, h);
            self.ViewC.frame = CGRectMake(0, 0, DMDeviceWidth, h);
            
        } completion:^(BOOL finished) {
            [self removeCoverAndMenuView];
            
            
            
        }];

    } else {
        
         [self removeCoverAndMenuView];
        
    }
    
    
}



#pragma mark - 点击遮盖移除
-(void)coverTap{
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        self.leftMenuView.frame = CGRectMake(DMDeviceWidth, 0, 0, self.menuViewframe.size.height);
        self.coverView.frame    = CGRectMake(0, 0,DMDeviceWidth, DMDeviceHeight);
        self.ViewC.frame = CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight);
        self.coverView.alpha    = 0.0;
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self.leftMenuView removeFromSuperview];
    }];
    
}





#pragma mark - 移除菜单和遮盖
-(void)removeCoverAndMenuView{
    
    self.leftMenuView.frame = CGRectMake(-self.leftMenuView.frame.size.width, 0, self.leftMenuView.frame.size.width, DMDeviceHeight);
    self.coverView.frame    = CGRectMake(0, 0,DMDeviceWidth, DMDeviceHeight);
    self.coverView.alpha    = 0.0;
    self.ViewC.frame = CGRectMake(0, 0, DMDeviceWidth, self.menuViewframe.size.height);
    
    [self.coverView removeFromSuperview];
    [self.leftMenuView removeFromSuperview];
}


@end
