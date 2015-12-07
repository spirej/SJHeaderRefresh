//
//  ViewController.m
//  SJHeaderRefresh
//
//  Created by SPIREJ on 15/12/7.
//  Copyright © 2015年 SPIREJ. All rights reserved.
//

#import "ViewController.h"
//#import "MJRefresh.h"
#import "XSHeaderRefresh.h"
#import "XSFooterRefresh.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)NSArray * array;

@end

@implementation ViewController

- (NSArray *)array
{
    if (!_array) {
        NSMutableArray * mArray = [NSMutableArray array];
        for (NSInteger  i = 0; i < 20; i++) {
            [mArray  addObject:[NSString stringWithFormat:@"costom>>>%ld",i]];
        }
        _array = [mArray copy];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    __unsafe_unretained UITableView *tableView = self.tableView;
    
    // 下拉刷新
    tableView.mj_header= [XSHeaderRefresh headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [tableView.mj_header endRefreshing];
        });
    }];
    
    
    // 上拉刷新
    tableView.mj_footer = [XSFooterRefresh footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [tableView.mj_footer endRefreshing];
        });
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = @"test";
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
