# SJHeaderRefresh
[详细说明地址http://www.jianshu.com/p/67a7aebcad2d](http://www.jianshu.com/p/67a7aebcad2d)

我的运行效果图：
![XSRefresh.gif](http://upload-images.jianshu.io/upload_images/1276164-402d3fefffeb9ff2.gif?imageMogr2/auto-orient/strip)
 
- 调用类的示例
  1） 
```
__unsafe_unretained UITableView *tableView = self.tableView;
// 下拉刷新
tableView.mj_header= [XSHeaderRefresh headerWithRefreshingBlock:^{
      // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      // 结束刷新
      [tableView.mj_header endRefreshing];
      });
}];
```
2）也可以这样
```
self.productListTabView.mj_header = [XSHeaderRefresh headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
self.productListTabView.mj_footer = [XSFooterRefresh footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
```
其中`refresh`和`loadMore`是你刷新和加载的方法
上拉加载代码中也有示例就不多做描述了。
