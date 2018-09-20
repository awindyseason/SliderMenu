//
//  ViewController.m
//  SliderMenu
//
//  Created by 雎琳 on 2018/9/13.
//  Copyright © 2018年 雎琳. All rights reserved.
//

#import "ViewController.h"

#import "SliderCell.h"
#import "SliderMenu.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SliderMenuDelegate>

@property (strong, nonatomic) UITableView *tv;
@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"SliderMenu";
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = barItem;
   
    _datas = @[@"0",@"1",@"2",@"3",@"4"].mutableCopy;
    _tv = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tv.dataSource = self;
    _tv.rowHeight = 50;
    _tv.tableFooterView = UIView.new;
    [self.view addSubview:_tv];
    [_tv registerClass:SliderCell.class forCellReuseIdentifier:@"slidercell"];

}
- (void)close{
    
    [[SliderMenu shared] close];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SliderCell *cell = [_tv dequeueReusableCellWithIdentifier:@"slidercell"];
    cell.menuDelegate = self;
    
    cell.textLabel.text = [_datas objectAtIndex:indexPath.row];

    return cell;
    
}

// === SliderDelegate ===
- (NSArray<MenuItem *> *)sliderMenuItemsForIndexPath:(NSIndexPath *)indexPath{
    /*
     可设置item属性：title bgcolor font width titleColor
     */
    MenuItem *item1 = [MenuItem title:@"编辑" bgcolor:UIColor.blueColor];
    MenuItem *item2 = [MenuItem title:@"删除" bgcolor:UIColor.redColor];

    return @[item1,item2];
    
}

/** 复用说明
 * 如果你的menu都是同一样式，可设置复用Identifier 。menu始终为同一对象。
 * menu不是同一样式,不设置此方法、或者返回nil;menu会重新创建。
 */
- (NSString *)sliderMenuReuseIdentifier{
    return @"EditWithDelete";
}

// return ture == 自动关闭 == [[SliderMenu shared] close];
- (BOOL)sliderMenuDidSelectIndex:(NSInteger)index atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectIndex:%ld row:%ld",index,indexPath.row);
    if (index == 1){
        [_datas removeObjectAtIndex:indexPath.row];
        // deleteRow貌似是让cell做了transform后hidden掉 并非真的delete
        [_tv deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    return false;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
