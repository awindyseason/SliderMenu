
#import "SliderCell.h"
#import "SliderMenu.h"

@interface SliderCell()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (assign, nonatomic) BOOL lastPanStateIsEnd;
@property (assign, nonatomic) BOOL cancelAnimationCompletion;
@property (assign, nonatomic ,readonly) CGFloat maxOffset;
@property (assign, nonatomic) CGFloat currentOffset;
@property (strong, nonatomic ,readonly) UIView *menusView;
@property (assign, nonatomic) NSInteger count;
@end

@implementation SliderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepare];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self prepare];
}

- (void)prepare{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    _pan.delegate = self;
    [self.contentView addGestureRecognizer:_pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    if (!self.menuDelegate) {
        return;
    }
    if (_lastPanStateIsEnd && self.state == SliderMenuSlider && [SliderMenu.shared.currentCell isEqual:self]) {
        _cancelAnimationCompletion = true;
        self.currentOffset = 0; //useful
        [pan setTranslation:CGPointMake(self.layer.presentationLayer.frame.origin.x, 0) inView:pan.view];
        [self move:self.layer.presentationLayer.frame.origin.x];
        [self.layer removeAllAnimations];
        [self removeAnimations];
    }
    
    CGFloat panX = [pan translationInView:pan.view].x;
    if ( self.state == SliderMenuClose && panX >= 0 && [SliderMenu.shared.currentCell isEqual:self]) {
        
        return;
    }
    
    CGFloat offsetX = panX + _currentOffset ;
    
    if ( offsetX > 0) {
        offsetX = 0;
    }
    
    _lastPanStateIsEnd = false;
    if (SliderMenu.shared.currentCell  && ![SliderMenu.shared.currentCell isEqual:self] ) {
        
        [SliderMenu.shared.currentCell cancelPan];
        
        if (SliderMenu.shared.currentCell.hidden) {
            [SliderMenu.shared.currentCell openMenu:false time:0 springX:0];
        }else{
            [SliderMenu.shared.currentCell openMenu:false time:0.35 springX:0];
        }
        
        SliderMenu.shared.currentCell = self;
        
    }
    
    if (!_menusView.superview) {
        [self addMenusForCell];
    }
    if (pan.state == UIGestureRecognizerStateBegan){
        [self.layer removeAllAnimations];
        [self removeAnimations];
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        // 轻微右滑关闭。如果不需要可以注释掉该方法
        if (panX > 0 && [SliderMenu.shared.currentCell isEqual:self]) {
            if (self.state == SliderMenuOpen) {
                // 轻微右滑关闭 终止手势
                [self cancelPan];
                [self openMenu:false time:0.35 springX:3];
            }
            return;
        }
        
        self.state = SliderMenuSlider;
        
        CGFloat moveX = offsetX;
        if (moveX < _maxOffset) {
            moveX =  _maxOffset - (_maxOffset - moveX ) * 0.25;
        }
        if (moveX > 0 ) {
            moveX = 0;
        }
        
        [self move:moveX];
        
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        _lastPanStateIsEnd = true;
        
        CGPoint speed = [pan velocityInView:self];
        // time 根据滑动手势快慢 自适应改变 0.25 ~ 0.4之间
        CGFloat time = 0.4;
        // 判断滑动速度和幅度决定开或关 可自行调整
        if (offsetX < 0.3 * _maxOffset || offsetX < -30) {// 开
            
            time = MAX(MIN(ABS((_maxOffset - offsetX)*1.8/speed.x),time),0.25);
            if (offsetX < _maxOffset){
                [self openMenu:true time:time springX:3];
            }else{
                [self openMenu:true time:time springX:-10];
            }
            
        }else{
            
            time = MAX(MIN( ABS(offsetX*1.8/speed.x),time),0.25);
            [self openMenu:false time:time springX:3];
            
        }
    }
}
- (void)close{
    
    [self openMenu:false time:0.3 springX:3];
}
- (void)openMenu:(BOOL)open time:(NSTimeInterval)time springX:(CGFloat)springX{
    
    CGFloat moveX = open ? _maxOffset : 0;
    CGFloat alpha = open ? 1 : 0.5;
    
    self.state = SliderMenuSlider;
    [self.layer removeAllAnimations];
    [self removeAnimations];
    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionOverrideInheritedDuration |  UIViewAnimationOptionCurveEaseOut;
    
    [UIView animateWithDuration:time delay:0 options:options  animations:^{
        self.menusView.alpha = alpha;
        [self move:moveX + springX];
        
    } completion:^(BOOL finished) {
        self.menusView.alpha = 1;
        if (self.cancelAnimationCompletion){
            [self removeAnimations]; // useful
            self.cancelAnimationCompletion = false;
            return ;
        }
        if (finished) {
            if (springX != 0 ) {
                [UIView animateWithDuration:0.3 delay:0 options:options animations:^{
                    [self move:moveX];
                } completion:nil];
            }
            if (open) {
                self.state = SliderMenuOpen;
                self.currentOffset = self.maxOffset;
            }else{
                self.state = SliderMenuClose;
                self.currentOffset = 0;
            }
        }else{
            //            NSLog(@"false");
        }
    }];
}

- (void)move:(CGFloat)x{
    self.transform = CGAffineTransformMakeTranslation(x, 0);
    [self transform:x];
}


- (void)transform:(CGFloat)x{
    
    CGFloat offsetx = x;
    CGFloat offsetWidth = 0.0;
    
    for (int i = 1; i < _count; i++) {
        UIView *v = [_menusView viewWithTag:100 + i];
        UIView *lastv = [_menusView viewWithTag:100 + i-1];
        offsetWidth += lastv.frame.size.width;
        CGFloat voffsetx = offsetx*offsetWidth/_maxOffset;
        v.transform = CGAffineTransformMakeTranslation(voffsetx, 0);
    }
}

- (void)removeAnimations{
    [_menusView.layer removeAllAnimations];
    
    for (UIView *v in _menusView.subviews) {
        [v.layer removeAllAnimations];
    }
}


- (void)addMenusForCell{
    
    SliderMenu.shared.currentCell = self;
    
    if(!_menusView  ){
        NSIndexPath *indexPath = [self indexPath];
        NSArray *menuItems  = [self.menuDelegate sliderMenuItemsForIndexPath:indexPath];
        _count = menuItems.count;
        _menusView = [UIView new];
        _maxOffset = 0.0;
        for (int i = 0; i < menuItems.count; i++) {
            MenuItem *item = [menuItems objectAtIndex:i];
            if (!item.width) {
                item.width = item.width?:[item.title sizeWithAttributes:@{NSFontAttributeName:item.font}].width + 36;
            }
            
            CGFloat width = item.width;
            _maxOffset += width;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.tag = 100 +i;
            btn.backgroundColor = item.bgcolor;
            btn.frame = CGRectMake(0, 0, width, self.frame.size.height);
            btn.titleLabel.font = item.font;
            [btn setTitleColor:item.titleColor forState:UIControlStateNormal];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didSelectMenu:) forControlEvents:UIControlEventTouchUpInside];
            [_menusView addSubview:btn];
            
            UIView *bgview = [UIView new];
            bgview.tag = 1000 + i;
            bgview.backgroundColor =  item.bgcolor;
            bgview.frame = CGRectMake(self.maxOffset, 0, width *2, self.frame.size.height);
            [_menusView addSubview:bgview];
            
            UIView *lastBGview = [_menusView viewWithTag:1000 + i-1];
            if (lastBGview) {
                [_menusView insertSubview:bgview aboveSubview:lastBGview];
            }else{
                [_menusView sendSubviewToBack:bgview];
            }
        }
        
        _maxOffset = -_maxOffset;
        _menusView.frame = CGRectMake(CGRectGetMaxX(self.frame), 0, ABS(self.maxOffset), self.frame.size.height);
        [self addSubview:_menusView];
        [_menusView layoutIfNeeded];
    }
    
}

- (void)didSelectMenu:(UIButton *)btn{
    if ([self.menuDelegate respondsToSelector:@selector(sliderMenuDidSelectIndex:atIndexPath:)]) {
         NSIndexPath *indexPath = [self indexPath];
        if ([self.menuDelegate sliderMenuDidSelectIndex:btn.tag - 100 atIndexPath:indexPath]){
            [self close];
        }
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == _pan) {
        
        CGFloat panY = [_pan translationInView:gestureRecognizer.view].y;
        if ( ABS(panY) > 0) {
            if (SliderMenu.shared.currentCell) {
                [SliderMenu.shared.currentCell openMenu:false time:0.4 springX:0];
            }
            return false;
        }
    }
    return true;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    _lastPanStateIsEnd = false;
}
- (void)cancelPan{
    _pan.enabled = false;
    _pan.enabled = true;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGPoint newP = [self convertPoint:point toView:_menusView];
    if ( [_menusView pointInside:newP withEvent:event])
    {
        return [_menusView hitTest:newP withEvent:event];
    }
    return [super hitTest:point withEvent:event];
}

- (NSIndexPath *)indexPath{
    UITableView *tv = (UITableView *)self.superview;
    return  [tv indexPathForCell:self];
}

@end
