//
//  DMSlideMenu.m
//  豆蔓理财
//
//  Created by edz on 2016/11/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMSlideMenu.h"




#define CoverViewAlpha                  0.6

#define ViewWidth                       0.75

#define CoverViewBackGround [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]

@interface DMSlideMenu ()

@property (nonatomic ,assign)CGRect         menuViewframe;
@property (nonatomic ,assign)CGRect         coverViewframe;
@property (nonatomic ,strong)UIView         *coverView;
@property (nonatomic ,strong)UIView         *leftMenuView;
@property (nonatomic ,strong)UIView         *ViewC;
@property (nonatomic ,strong)UIView         *tabView;
@property (nonatomic ,assign)BOOL           isShowCoverView;;

@end

@implementation DMSlideMenu

+(instancetype)initWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView
                             tabarView:(UIView *)tabarView isShowCoverView:(BOOL)isCover{
    
    DMSlideMenu *menu = [[DMSlideMenu alloc] initWithDependencyView:dependencyView MenuView:leftmenuView tabarView:tabarView isShowCoverView:isCover];
    
    return menu;
}


-(instancetype)initWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView
                            tabarView:(UIView *)tabarView isShowCoverView:(BOOL)isCover{
    
    if(self = [super init]){
        self.isShowCoverView = isCover;
        
        [self addPanGestureAtDependencyView:dependencyView];
        self.leftMenuView = leftmenuView;

        self.ViewC = dependencyView;
        self.tabView = tabarView;
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
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = \
    [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges                             = UIRectEdgeLeft;
    [dependencyView addGestureRecognizer:leftEdgeGesture]; //
}




-(void)show{
    
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.coverView];
    [window addSubview:self.leftMenuView];
    
    
    
    self.leftMenuView.frame = CGRectMake(-self.menuViewframe.size.width, self.menuViewframe.origin.y, self.menuViewframe.size.width, self.menuViewframe.size.height);
    self.coverView.frame = CGRectMake(0, 0, DMDeviceWidth, self.menuViewframe.size.height);
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.tabView.frame = CGRectMake(DMDeviceWidth *ViewWidth, 0  , DMDeviceWidth, DMDeviceHeight);
        
        self.leftMenuView.frame = self.menuViewframe;
        
        self.coverView.frame  = CGRectMake(DMDeviceWidth*ViewWidth, 0, DMDeviceWidth, self.menuViewframe.size.height);
//        self.ViewC.frame = CGRectMake(DMDeviceWidth*0.8, 64, DMDeviceWidth, self.menuViewframe.size.height-64);
        
        self.coverView.alpha = CoverViewAlpha;
    }];
    
  
}



-(void)hidenWithoutAnimation{
    
    [self removeCoverAndMenuView];
}
-(void)hidenWithAnimation{
    
    [self coverTap];
}


#pragma mark - 屏幕左侧菜单
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


#pragma mark - 屏幕往右滑处理
- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.coverView];
    [window addSubview:self.leftMenuView];
    
   
    CGPoint translation = [gesture translationInView:gesture.view];
    
    if(UIGestureRecognizerStateBegan == gesture.state ||
       UIGestureRecognizerStateChanged == gesture.state){
        
        
//        self.ViewC.frame =      CGRectMake(0 + translation.x, 64,DMDeviceWidth-translation.x, DMDeviceHeight);
        
        
        if(translation.x <= self.menuViewframe.size.width){
            
            //10像素的地方
            

            
            if(translation.x <= 10){
                self.coverView.frame = CGRectMake(0, self.menuViewframe.origin.y, DMDeviceWidth, self.menuViewframe.size.height);
            }
            
            CGFloat x           = translation.x  - self.menuViewframe.size.width;
            CGFloat y           = self.menuViewframe.origin.y;
            CGFloat w           = self.menuViewframe.size.width;
            CGFloat h           = self.menuViewframe.size.height;
            self.leftMenuView.frame = CGRectMake(x, y, w, h);
            
            self.tabView.frame = CGRectMake(0 + translation.x, 0  , DMDeviceWidth, DMDeviceHeight);
            self.coverView.frame    = CGRectMake(self.leftMenuView.frame.size.width+x, 0,DMDeviceWidth-self.leftMenuView.frame.size.width-x, h);
            
            self.coverView.alpha    = CoverViewAlpha*(translation.x / w);
        }else{
            
            self.leftMenuView.frame = self.menuViewframe;
             self.tabView.frame =   CGRectMake(DMDeviceWidth*ViewWidth, 0,DMDeviceWidth, DMDeviceHeight);
            self.coverView.frame = self.coverViewframe;
        }
    }
    else{
        if(translation.x > self.menuViewframe.size.width/2){
            [self openMenuView];
        }else{
            [self closeMenuView];
        }
        
    }
}


#pragma mark - coverView往左滑隐藏
-(void)handleftPan:(UIPanGestureRecognizer*)recognizer{
    
    CGPoint translation = [recognizer translationInView:recognizer.view];
    static CGFloat BeganX;
    
    if(UIGestureRecognizerStateBegan == recognizer.state){
        BeganX = translation.x;
    }
   
    CGFloat Place = (-translation.x) - (-BeganX);
    
    
    if(self.leftMenuView.frame.size.width-Place>=DMDeviceWidth *0.75) {
        return;
        
    }
    

    
    if(UIGestureRecognizerStateBegan == recognizer.state ||
       UIGestureRecognizerStateChanged == recognizer.state){
        
        self.tabView.frame =      CGRectMake(_leftMenuView.frame.size.width-Place, 0,DMDeviceWidth, DMDeviceHeight);
        
        CGFloat x           = 0 ;
        CGFloat y           = self.menuViewframe.origin.y;
        CGFloat w           = self.menuViewframe.size.width;
        CGFloat h           = self.menuViewframe.size.height;
        
        
        if(Place <= DMDeviceWidth*0.75 &&  Place >0){
            
            x  = 0 - Place;
            
            //            self.leftMenuView.frame = CGRectMake(x, y, w, h);
            
            self.coverView.frame    = CGRectMake(self.leftMenuView.frame.size.width-Place, 0,DMDeviceWidth-self.leftMenuView.frame.size.width+Place, h);
            self.coverView.alpha    = CoverViewAlpha*((w - Place) / w);
            
        }else if(Place >0){
            
            x  = - self.menuViewframe.size.width;

            self.coverView.frame    = CGRectMake(0, 0,DMDeviceWidth,h);
            
        }else{
            
            x = 0;

            self.coverView.frame    = CGRectMake(self.leftMenuView.frame.size.width, 0,DMDeviceWidth-self.leftMenuView.frame.size.width, h);
            
            self.coverView.alpha    = CoverViewAlpha;
        }
        
        self.leftMenuView.frame = CGRectMake(x, y, w, h);
        
        
    }else{

        if(Place > self.menuViewframe.size.width/2){
            [self closeMenuView];
        }else{
            [self openMenuView];
        }
    }
    
}


-(void)openMenuView{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat x           = 0;
        CGFloat y           = self.menuViewframe.origin.y;
        CGFloat w           = self.menuViewframe.size.width;
        CGFloat h           = self.menuViewframe.size.height;
        self.leftMenuView.frame = CGRectMake(x, y, w, h);
        self.coverView.frame    =  CGRectMake(DMDeviceWidth*ViewWidth, 0,DMDeviceWidth, self.menuViewframe.size.height);
        self.tabView.frame = CGRectMake(DMDeviceWidth*ViewWidth, 0, DMDeviceWidth, self.menuViewframe.size.height);
        self.coverView.alpha    = CoverViewAlpha;
    }];
}

-(void)closeMenuView{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGFloat x           = -self.menuViewframe.size.width;
        CGFloat y           = self.menuViewframe.origin.y;
        CGFloat w           = self.menuViewframe.size.width;
        CGFloat h           = self.menuViewframe.size.height;
        self.leftMenuView.frame = CGRectMake(x, y, w, h);//self.LeftViewFrame;
        self.coverView.frame    = CGRectMake(0, 0,DMDeviceWidth, self.menuViewframe.size.height);
        self.tabView.frame = CGRectMake(0, 0, DMDeviceWidth, self.menuViewframe.size.height);
        
    } completion:^(BOOL finished) {
        [self removeCoverAndMenuView];
    }];
}



#pragma mark - 点击遮盖移除
-(void)coverTap{
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.leftMenuView.frame = CGRectMake(-self.menuViewframe.size.width, 0, self.menuViewframe.size.width, self.menuViewframe.size.height);
        self.coverView.frame    = CGRectMake(0, 0,DMDeviceWidth, DMDeviceHeight);
//        self.ViewC.frame = CGRectMake(0, 64, DMDeviceWidth, DMDeviceHeight);
        self.tabView.frame = CGRectMake(0, 0  , DMDeviceWidth, DMDeviceHeight);
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
//    self.ViewC.frame = CGRectMake(0, 64, DMDeviceWidth, self.menuViewframe.size.height);
    self.tabView.frame = CGRectMake(0, 0  , DMDeviceWidth, DMDeviceHeight);
    [self.coverView removeFromSuperview];
    [self.leftMenuView removeFromSuperview];
}

@end
