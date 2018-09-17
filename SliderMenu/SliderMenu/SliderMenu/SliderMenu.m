

#import "SliderMenu.h"

static SliderMenu *shared = nil;
@interface SliderMenu()
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSArray *menuItems;
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
    //        if ([_currentCell.delegate respondsToSelector:@selector(willDisplayView:)]) {
    //            [_currentCell.delegate willDisplayView:btn];
    //        }
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
- (void)reset{
    if (_view.superview){
        self.currentCell.contentView.transform = CGAffineTransformIdentity;
        [_view removeFromSuperview];
        _indexPath = nil;
        //        _view = nil;
        _currentCell = nil;
        //        _totalWidth = 0;
        _currentOffset = 0;
        _menuItems = nil;
        
    }
}
- (void)releaseView{
    self.view = nil;
    self.totalWidth = 0;
    self.reuseIdent = nil;
}
- (void)close{
    [self.currentCell openMenu:false time:0.25];
}

- (void)menuForCell:(SliderCell*)cell{
    _currentCell = cell;
    UITableView *tv = (UITableView *)cell.superview;
    _indexPath = [tv indexPathForCell:cell];
    _menuItems  = [_currentCell.delegate itemsForIndexPath:_indexPath];
    NSString *reuseIdent = nil;
    if ([_currentCell.delegate respondsToSelector:@selector(reuseMenuWithIdentifier)]) {
        reuseIdent = [_currentCell.delegate reuseMenuWithIdentifier];
    }
    if(!_view || ![_reuseIdent isEqualToString:reuseIdent] ){
        
        _reuseIdent = reuseIdent;
        _view = [SliderView new];
        
        _totalWidth = 0.0;
        for (int i = 0; i < _menuItems.count; i++) {
            MenuItem *item = [_menuItems objectAtIndex:i];
            if (!item.width) {
                item.width = item.width?:[item.title sizeWithAttributes:@{NSFontAttributeName:item.font}].width + 46;
            }
            
            CGFloat width = item.width;
            _totalWidth += width;
            
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
            bgview.frame = CGRectMake(self.totalWidth, 0, 300, _currentCell.frame.size.height);
            [_view addSubview:bgview];
            
            UIView *lastBGview = [_view viewWithTag:1000 + i-1];
            if (lastBGview) {
                [_view insertSubview:bgview aboveSubview:lastBGview];
            }else{
                [_view sendSubviewToBack:bgview];
            }
            
        }
        
        _totalWidth = -_totalWidth;
        _view.frame = CGRectMake(CGRectGetMaxX(cell.frame), 0, ABS(self.totalWidth), _currentCell.frame.size.height);
    }
    
    [cell addSubview:_view];
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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    return [super hitTest:point withEvent:event];
}

@end
