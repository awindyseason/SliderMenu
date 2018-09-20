

#import "SliderMenu.h"

static SliderMenu *shared = nil;
@interface SliderMenu()

@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSString *reuseIdent;
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

- (void)transform:(CGFloat)x{
    
    CGFloat offsetx = x;
    CGFloat offsetWidth = 0.0;
    
    for (int i = 1; i < _count; i++) {
        UIView *v = [_view viewWithTag:100 + i];
        UIView *lastv = [_view viewWithTag:100 + i-1];
        offsetWidth += lastv.frame.size.width;
        CGFloat voffsetx = offsetx*offsetWidth/_maxOffset;
        v.transform = CGAffineTransformMakeTranslation(voffsetx, 0);
    }
}
- (void)removeAnimations{
    [_view.layer removeAllAnimations];
    for (UIView *v in _view.subviews) {
        for (UIView *v2 in v.subviews){
            [v2.layer removeAllAnimations];
        }
        [v.layer removeAllAnimations];
    }
}
- (void)reset{
    if (_view.superview){
        _currentCell.contentView.transform = CGAffineTransformIdentity;
        [_view removeFromSuperview];
        
        _currentCell = nil;
        _currentOffset = 0;
        
        _lock = false;
    }
}
- (void)releaseView{
    [self reset];
    _view = nil;
    _maxOffset = 0;
    _reuseIdent = nil;
}
- (void)close{
    [self.currentCell openMenu:false time:0.3 springX:3];
}

- (void)menuForCell:(SliderCell*)cell{
    _currentCell = cell;
    NSString *reuseIdent = nil;
    if ([_currentCell.menuDelegate respondsToSelector:@selector(sliderMenuReuseIdentifier)]) {
        reuseIdent = [_currentCell.menuDelegate sliderMenuReuseIdentifier];
    }
    if(!_view || ![_reuseIdent isEqualToString:reuseIdent] ){
        UITableView *tv = (UITableView *)cell.superview;
        NSIndexPath *indexPath = [tv indexPathForCell:cell];
        NSArray *menuItems  = [_currentCell.menuDelegate sliderMenuItemsForIndexPath:indexPath];
        _reuseIdent = reuseIdent;
        _view = [SliderView new];
        
        _maxOffset = 0.0;
        for (int i = 0; i < menuItems.count; i++) {
            _count = menuItems.count;
            MenuItem *item = [menuItems objectAtIndex:i];
            if (!item.width) {
                item.width = item.width?:[item.title sizeWithAttributes:@{NSFontAttributeName:item.font}].width + 46;
            }
            
            CGFloat width = item.width;
            _maxOffset += width;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.tag = 100 +i;
            btn.backgroundColor = item.bgcolor;
            btn.frame = CGRectMake(0, 0, width, _currentCell.frame.size.height);
            btn.titleLabel.font = item.font;
            [btn setTitleColor:item.titleColor forState:UIControlStateNormal];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
            [_view addSubview:btn];
            
            UIView *bgview = [UIView new];
            bgview.tag = 1000 + i;
            bgview.backgroundColor =  item.bgcolor;
            bgview.frame = CGRectMake(self.maxOffset, 0, 300, _currentCell.frame.size.height);
            [_view addSubview:bgview];
            
            UIView *lastBGview = [_view viewWithTag:1000 + i-1];
            if (lastBGview) {
                [_view insertSubview:bgview aboveSubview:lastBGview];
            }else{
                [_view sendSubviewToBack:bgview];
            }
            
        }
        
        _maxOffset = -_maxOffset;
        
        _view.frame = CGRectMake(CGRectGetMaxX(cell.frame), 0, ABS(self.maxOffset), _currentCell.frame.size.height);
    }
    
    [cell addSubview:_view];
    [_view layoutIfNeeded];
}
- (void)action:(UIButton *)btn{
    if ([_currentCell.menuDelegate respondsToSelector:@selector(sliderMenuDidSelectIndex:atIndexPath:)]) {
        UITableView *tv = (UITableView *)_currentCell.superview;
        NSIndexPath *indexPath = [tv indexPathForCell:_currentCell];
 
        if ([_currentCell.menuDelegate sliderMenuDidSelectIndex:btn.tag - 100 atIndexPath:indexPath]){
            [self close];
        }
    }
    
}

@end

@implementation MenuItem
- (instancetype)init{
    if (self  = [super init]) {
        _titleColor = UIColor.whiteColor;
        _font = [UIFont systemFontOfSize:16];
    }
    return self;
}
+ (instancetype)title:(NSString *)title bgcolor:(UIColor *)bgcolor{
    MenuItem *item = MenuItem.new;
    item.title = title;
    item.bgcolor = bgcolor;
    return item;
}
@end

@implementation SliderView

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//
//    return [super hitTest:point withEvent:event];
//}

@end
