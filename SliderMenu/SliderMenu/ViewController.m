//
//  ViewController.m
//  SliderMenu
//
//  Created by 雎琳 on 2018/9/13.
//  Copyright © 2018年 雎琳. All rights reserved.


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
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
   
    _datas = @[@"0",@"1",@"2",@"3",@"4"].mutableCopy;
    _tv = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tv.dataSource = self;
    _tv.rowHeight = 55;
    _tv.delegate = self;
    _tv.tableFooterView = UIView.new;
    [self.view addSubview:_tv];
    [_tv registerClass:SliderCell.class forCellReuseIdentifier:@"slidercell"];
    
}
- (void)close{
    [[SliderMenu shared].currentCell close];
}

- (void)open:(SliderCell *)cell{
    [[SliderMenu shared].currentCell close];
     [cell openMenu:true time:0.3 springX:0];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([SliderMenu shared].currentCell.state == SliderMenuOpen) {
           [[SliderMenu shared].currentCell close];
    }
   
 
 
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
