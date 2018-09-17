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

// 对于只存在一种样式的menu 。可以设置复用 Identifier
- (NSString *)reuseMenuWithIdentifier{
    return @"EditWithDelete";
}
- (BOOL)didSelectIndex:(NSInteger)index atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectIndex:%ld row:%ld",index,indexPath.row);
    if (index == 1){
        [_datas removeObjectAtIndex:indexPath.row];
        // deleteRow貌似是让cell做了transform后hidden掉 并非真的delete
        // 删除cell本身有动画，跟menu关闭动画有影响 既return false就行。
        [_tv deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    // ture == 自动关闭
    return false;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
