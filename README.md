# SliderMenu 

##UITableView/UICollectionView  左滑编辑、删除按钮、
~使用简单
~可自定义
~流畅平滑




```objective-C
=== How To Use === 
 1，继承 YourCell : SliderCell  
 UICollectionView 需要 修改下SliderCell : CollectViewCell
 2，设置SliderCell的代理
 cell.menuDelegate = self;
// 设置按钮样式
- (NSArray<MenuItem *> *)sliderMenuItemsForIndexPath:(NSIndexPath *)indexPath{
    /*
     可设置item属性：title bgcolor font width titleColor
     */
    MenuItem *item1 = [MenuItem title:@"编辑" bgcolor:UIColor.blueColor];
    MenuItem *item2 = [MenuItem title:@"删除" bgcolor:UIColor.redColor];

    return @[item1,item2];
    
}

```
