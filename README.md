# SliderMenu
# TableView 上cell的侧滑菜单，支持自定义按钮，及不同样式，过渡滑动效果流畅。

![= =](https://upload-images.jianshu.io/upload_images/6657057-8cb25fcda8066aee.gif?imageMogr2/auto-orient/strip)

* 文件里有两个demo
* 一个是初期的，单个cell 可复用。过渡效果一般。
* 推荐主demo。不复用，但不同cell上的menu切换效果更好。

```objective-C
设置SliderCell的代理
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
