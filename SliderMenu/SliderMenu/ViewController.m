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
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SliderDelegate>

@property (strong, nonatomic) UITableView *tv;
@property (strong, nonatomic) NSMutableArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"SliderMenu";
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    _datas = @[@"0",@"1",@"2",@"3"].mutableCopy;
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
    cell.delegate = self;
    
    cell.textLabel.text = [_datas objectAtIndex:indexPath.row];
    cell.backgroundColor = indexPath.row % 2 ? UIColor.yellowColor : UIColor.blueColor;
    
    return cell;
    
}
// === SliderDelegate ===
- (NSArray<MenuItem *> *)itemsForIndexPath:(NSIndexPath *)indexPath{
    /*
     可设置item属性：title bgcolor font width titleColor
     */
    MenuItem *item1 = [MenuItem title:@"编辑" bgcolor:UIColor.brownColor];
    MenuItem *item2 = [MenuItem title:@"删除" bgcolor:UIColor.redColor];

    return @[item1,item2];
    
}

// menu是否复用，如果所有cell上的menu样式都一样，设置ture
- (BOOL)isReuse{
    // default is false
    return true;
}
- (BOOL)didSelectIndex:(NSInteger)index atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectIndex:%ld row:%ld",index,indexPath.row);
    if (index == 0){
        return false;
    }else{
        [_datas removeObjectAtIndex:indexPath.row];
        [_tv deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return true; // true == 自动关闭menu
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
