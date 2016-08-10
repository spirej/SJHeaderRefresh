# SJHeaderRefresh
- 首先贴上MJ在GitHub上的源码和说明 [MJRefresh源码和说明地址](https://github.com/CoderMJLee/MJRefresh) 其实看过作者自己写的说明之后差不多都能拿来自己用了。这里我主要是说一下基于MJRefresh自定义的刷新视图。

- 可以先下载作者的demo看一下，打开之后如下图的目录结构：
![MJDIYHeader.png](http://upload-images.jianshu.io/upload_images/1276164-65f056d4b0a213c5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)这个DIY文件夹里面就是作者给的自定义刷新视图的实例。

- 现在我DIY一个自己的下拉和上拉加载更多视图。话不多说直接上代码：[我的示例自定义刷新视图下载地址](https://github.com/SPIREJ/SJHeaderRefresh)
自定义一个类继承自MJRefreshHeader，这里我定义的类名位XSHeaderRefresh。
我的运行效果图：
![XSRefresh.gif](http://upload-images.jianshu.io/upload_images/1276164-402d3fefffeb9ff2.gif?imageMogr2/auto-orient/strip)

- XSHeaderRefresh.h
```
#import "MJRefreshHeader.h"
@interface XSHeaderRefresh : MJRefreshHeader
@end
```

- XSHeaderRefresh.m（下面代码全部为.m文件内容）
1)自定义视图用到哪些UI元素在这里声明
```
#import "XSHeaderRefresh.h"
@interface XSHeaderRefresh()
@property(weak, nonatomic) UIView * headerFreshView;
@property(weak, nonatomic)UILabel * label;
@property(nonatomic, strong)UIImageView * imageView;
@end
```
2)这里做控件的初始化配置
      @implementation XSHeaderRefresh
      - (void)prepare {
          [super prepare];
          // 设置控件的高度
          self.mj_h = 75;
          UIView * view = [[UIView alloc] init];
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
      
  3)设置子控件的位置和尺寸
 
      - (void)placeSubviews
      {
          [super placeSubviews];
          self.headerFreshView.bounds = CGRectMake(0, 0, 110, 20);
          self.headerFreshView.center = CGPointMake(self.mj_w*0.5, self.mj_h-20);
          self.label.frame = CGRectMake(30, 0, 80, 20);
          self.imageView.frame = CGRectMake(10, 5, 10, 10);
      }
      
4)重写父类方法
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
      
     5)图片旋转（自定义）
      -(void)startAnimation
      {
          CABasicAnimation *basicAni= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
          basicAni.duration = 1;
          basicAni.repeatCount = MAXFLOAT;
          //    basicAni.repeatDuration = 3;
          basicAni.toValue = @(M_PI * 2);
          [self.imageView.layer addAnimation:basicAni forKey:nil];
      }
      - (void)endAnimation
      {
          [self.imageView.layer removeAllAnimations];
      }
 
- 调用类的示例
  1）
      __unsafe_unretained UITableView *tableView = self.tableView;
          // 下拉刷新
          tableView.mj_header= [XSHeaderRefresh headerWithRefreshingBlock:^{
          // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          // 结束刷新
          [tableView.mj_header endRefreshing];
        });
      }];
2）也可以这样
```
self.productListTabView.mj_header = [XSHeaderRefresh headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
self.productListTabView.mj_footer = [XSFooterRefresh footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
```
其中`refresh`和`loadMore`是你刷新和加载的方法
上拉加载代码中也有示例就不多做描述了。
