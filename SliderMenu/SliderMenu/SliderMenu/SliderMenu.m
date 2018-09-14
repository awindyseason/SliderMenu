

#import "SliderMenu.h"

static SliderMenu *shared = nil;
@interface SliderMenu()
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSArray *menuItems;

@end
@implementation SliderMenu
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SliderMenu new];
    });
    return shared;
}
- (instancetype)init{
    if (self = [super init]) {

        _state = SliderMenuClose;
    }
    return self;
}

- (void)move:(CGFloat)x{
    
    CGFloat offsetx = x;
    CGFloat offsetWidth = 0.0;
    
    for (int i = 1; i < _menuItems.count; i++) {
        UIView *v = [_view viewWithTag:100 + i];
        UIView *lastv = [_view viewWithTag:100 + i-1];
        offsetWidth += lastv.frame.size.width;
        CGFloat voffsetx = offsetx*offsetWidth/_totalWidth;
        v.transform = CGAffineTransformMakeTranslation(voffsetx, 0);
    }
    
}
- (void)releaseFromCell{
    if (_view.superview){
        self.currentCell.contentView.transform = CGAffineTransformIdentity;
        [_view removeFromSuperview];
        _indexPath = nil;
        _view = nil;
        _currentCell = nil;
        _totalWidth = 0;
        _currentOffset = 0;
        _menuItems = nil;
    }
}
- (void)close{
    [self.currentCell openMenu:false time:0.25];
}
- (void)menuForCell:(SliderCell*)cell{
    _currentCell = cell;
    UITableView *tv = (UITableView *)cell.superview;
    _indexPath = [tv indexPathForCell:cell];
    _menuItems  = [_currentCell.delegate itemsForIndexPath:_indexPath];

    _view = [SliderView new];
    _view.backgroundColor = [UIColor clearColor];
    _view.userInteractionEnabled = true;
    [cell addSubview:_view];
    _totalWidth = 0.0;
    for (int i = 0; i < _menuItems.count; i++) {
         MenuItem *obj = [_menuItems objectAtIndex:i];
        UIView *bg = [UIView new];
        bg.tag = 1000 + i;
        bg.backgroundColor =  obj.bgcolor;
        bg.userInteractionEnabled = true;
        [_view addSubview:bg];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
       
        [btn setTitle:obj.title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat width = obj.width;
        _totalWidth += width;
        btn.tag = 100 +i;
        
        btn.backgroundColor = obj.bgcolor;
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_view addSubview:btn];

        btn.frame = CGRectMake(0, 0, width, _currentCell.frame.size.height);

        bg.frame = CGRectMake(self.totalWidth, 0, 300, _currentCell.frame.size.height);
        UIView *lastBG = [_view viewWithTag:1000 + i-1];
        if (lastBG) {
            [_view insertSubview:bg aboveSubview:lastBG];
        }else{
            [_view sendSubviewToBack:bg];
        }
//        if ([_currentCell.delegate respondsToSelector:@selector(willDisplayView:)]) {
//            [_currentCell.delegate willDisplayView:btn];
//        }
    }
    _totalWidth = -_totalWidth;

    _view.frame = CGRectMake(CGRectGetMaxX(cell.frame), 0, ABS(self.totalWidth), _currentCell.frame.size.height);
    [_view layoutIfNeeded];
}
- (void)action:(UIButton *)btn{
    if ([_currentCell.delegate respondsToSelector:@selector(didSelectIndex:atIndexPath:)]) {
       if ([_currentCell.delegate didSelectIndex:btn.tag - 100 atIndexPath:self.indexPath]){
           [self close];
       }
    }
    
}

@end

@implementation MenuItem
@end
@implementation SliderView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
     
    return [super hitTest:point withEvent:event];
}
@end
