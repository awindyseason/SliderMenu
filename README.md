# SliderMenu 

##UITableView/UICollectionView  的左滑菜单、侧滑菜单
~使用非常简单
~支持自定义按钮
~优化手势动画的体验，有流畅的过度效果和小动画




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
