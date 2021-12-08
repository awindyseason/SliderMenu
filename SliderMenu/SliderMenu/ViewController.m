//
//  ViewController.m
//  SliderMenu
//
//  Created by 雎琳 on 2018/9/13.
//  Copyright © 2018年 雎琳. All rights reserved.


#import "ViewController.h"

#import "SliderCell.h"
#import "SliderMenu.h"
#import "YourCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SliderMenuDelegate>

@property (strong, nonatomic) UITableView *tv;
@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"SliderMenu";
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc]initWithTitle:@"reload" style:UIBarButtonItemStylePlain target:self action:@selector(reload)];
    self.navigationItem.rightBarButtonItems = @[rightBarItem,reloadItem];
    _datas = @[].mutableCopy;
    for (int i = 0; i < 5 ; i++) {
        [_datas addObject:@(i).stringValue];
    }
    _tv = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tv.rowHeight = 55;
    _tv.dataSource = self;
    _tv.delegate = self;
    _tv.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tv];
    [_tv registerClass:SliderCell.class forCellReuseIdentifier:@"slidercell"];
    [_tv registerNib:[UINib nibWithNibName:@"YourCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"YourCell"];
    
}

- (void)close{
    [[SliderMenu shared].currentCell close];
}
- (void)reload{
    [self.tv reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // tableview滚动 ，menu关闭
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
    if (indexPath.row < 3) {
        SliderCell *cell = [_tv dequeueReusableCellWithIdentifier:@"slidercell"];
        cell.menuDelegate = self;
        
        cell.textLabel.text = [_datas objectAtIndex:indexPath.row];
        
        return cell;
        
    }else{
        YourCell *cell = [_tv dequeueReusableCellWithIdentifier:@"YourCell"];
        cell.menuDelegate = self;
        
        return cell;
    }
   
}

// === SliderDelegate ===
- (NSArray<MenuItem *> *)sliderMenuItemsForIndexPath:(NSIndexPath *)indexPath{
    /*
     可设置item属性：title bgcolor font width titleColor 修改源码可自行添加
     */
    if (indexPath.row % 2 ==0) {
        MenuItem *item1 = [MenuItem title:@"编辑" bgcolor:UIColor.blueColor];
        MenuItem *item2 = [MenuItem title:@"删除" bgcolor:UIColor.redColor];
        
        return @[item1,item2];
    }else{
        MenuItem *item1 = [MenuItem title:@"点击关闭" bgcolor:UIColor.orangeColor];
        item1.font = [UIFont systemFontOfSize:15];
        item1.width = 120;
        item1.titleColor = UIColor.blackColor;
        return @[item1];
    }
    
}

  
- (BOOL)sliderMenuDidSelectIndex:(NSInteger)index atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectIndex:%ld row:%ld",index,indexPath.row);
    if (indexPath.row % 2 ==0) {
        if (index == 1){
            [_datas removeObjectAtIndex:indexPath.row];
            [_tv deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else{
        // 点击后自动关闭
        return true;
    }
    return false;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
