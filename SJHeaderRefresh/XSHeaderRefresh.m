//
//  XSHeaderRefresh.m
//  XSHeaderRefresh
//
//  Created by SPIREJ on 15/12/3.
//  Copyright © 2015年 SPIREJ. All rights reserved.
//

#import "XSHeaderRefresh.h"


@interface XSHeaderRefresh()
{
    CGFloat _angle;
    BOOL isOK;
}
@property(weak, nonatomic) UIView * headerFreshView;
@property(weak, nonatomic)UILabel * label;
@property(nonatomic, strong)UIImageView * imageView;

@end

@implementation XSHeaderRefresh
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    _angle = 1.0;
    isOK = YES;
    // 设置控件的高度
    self.mj_h = 75;
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor lightGrayColor];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    self.headerFreshView = view;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [self.headerFreshView addSubview:label];
    self.label = label;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"arrow"];
    [self.headerFreshView addSubview:imageView];
    self.imageView = imageView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.headerFreshView.bounds = CGRectMake(0, 0, 85, 20);
    self.headerFreshView.center = CGPointMake(self.mj_w*0.5, self.mj_h-30);
    
    self.label.frame = CGRectMake(20, 0, 65, 20);

    self.imageView.frame = CGRectMake(10, 5, 10, 10);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}


 
 #pragma mark 监听控件的刷新状态
 - (void)setState:(MJRefreshState)state
 {
 MJRefreshCheckState;
 
 switch (state) {
 case MJRefreshStateIdle:
         self.label.text = @"下拉刷新";
         [self endAnimation];
         break;
 case MJRefreshStatePulling:
         self.label.text = @"松开加载更多";
         [self endAnimation];
         break;
 case MJRefreshStateRefreshing:
         self.label.text = @"加载中...";
         [self startAnimation];
 break;
 default:
 break;
 }
 }
 


#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    self.label.textColor = [UIColor blackColor];
}


#pragma mark 图片旋转
-(void)startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    if (!isOK) {
        return;
    }
    [UIView setAnimationDidStopSelector:@selector(startAnimation)];
    _angle += 15;
    self.imageView.layer.anchorPoint = CGPointMake(0.5,0.5);//以右下角为原点转，（0,0）是左上角转，（0.5,0,5）心中间转，其它以此类推
    self.imageView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    self.imageView.animationDuration = 1;
    [UIView commitAnimations];
}
- (void)endAnimation
{
    isOK = !isOK;
}



@end
