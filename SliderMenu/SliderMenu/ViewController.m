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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tv = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tv.dataSource = self;
    _tv.rowHeight = 50;

    [self.view addSubview:_tv];
    [_tv registerClass:SliderCell.class forCellReuseIdentifier:@"slidercell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SliderCell *cell = [_tv dequeueReusableCellWithIdentifier:@"slidercell"];
    cell.textLabel.text = @(indexPath.row).stringValue;
    cell.delegate = self;
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = UIColor.yellowColor;
    }else{
        cell.backgroundColor = UIColor.blueColor;
    }
    return cell;
    
}


- (NSArray<MenuItem *> *)itemsForIndexPath:(NSIndexPath *)indexPath{
    MenuItem *item1 = [MenuItem new];
    item1.title = @"编辑";
    item1.width = 80;
    item1.bgcolor = [UIColor brownColor];
    MenuItem *item2 = [MenuItem new];
    item2.title = @"删除";
    item2.width = 80;
    item2.bgcolor = [UIColor redColor];
    
    return @[item1,item2];
    
}

- (void)didSelectIndex:(NSInteger)index atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelect-index:%ld",index);
}

- (void)deleteItem:(NSIndexPath *)indexPath{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
