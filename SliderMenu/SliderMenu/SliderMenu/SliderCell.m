
#import "SliderCell.h"
#import "SliderMenu.h"

@interface SliderCell()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) SliderMenu *menu;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation SliderCell{
    //使 menu 连贯从一个cell到另一个cell 需要计算的积累量
    CGFloat accumulation;
}
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
    _menu = SliderMenu.shared;
    _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    _pan.delegate = self;
    [self.contentView addGestureRecognizer:_pan];
}
/* 点击关闭
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 [super touchesBegan:touches withEvent:event];
 if ([SliderMenu shared].state == SliderMenuOpen) {
 [[SliderMenu shared] close];
 }
 }
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == _pan) {
        
        CGFloat panY = [_pan translationInView:gestureRecognizer.view].y;
        if ( ABS(panY) > 0) {
            if (_menu.currentCell) {
                [_menu.currentCell openMenu:false time:0.4];
            }
            return false;
        }
    }
    return true;
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGFloat panX = [pan translationInView:pan.view].x;
    
    if ( _menu.state == SliderMenuClose && panX > 0 ) {
        [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
        return;
    }
    
    CGFloat offsetX = panX + _menu.currentOffset;
    if ( offsetX > 0) {
        offsetX = 0;
    }
    if ( _menu.lock ) {
        // 从一个cell到另一个cell 。menu锁住，等待关闭后才能打开
        //        _pan.enabled = false;
        //        _pan.enabled = true;
        if (panX < 0){
            accumulation = -panX;
        }
        return;
    }else{
        offsetX = panX + _menu.currentOffset  + accumulation;
        if (!_menu.view.superview) {
            [_menu menuForCell:self];
        }
    }
    
    if (pan.state == UIGestureRecognizerStateBegan){
        
        if (_menu.currentCell  && ![_menu.currentCell isEqual:self] ) {
            _menu.lock = true;
            if (_menu.currentCell.hidden) {
                [_menu.currentCell openMenu:false time:0];
            }else{
                [_menu.currentCell openMenu:false time:0.4];
            }
            return;
        }
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        // 轻微右滑关闭  不想选择可以注释掉
        if (panX > 0 && [_menu.currentCell isEqual:self]) {
            if (_menu.state != SliderMenuClose) {
                _menu.lock = true;
                [_menu.currentCell openMenu:false time:0.3];
            }
            return;
        }
        
        _menu.state = SliderMenuSlider;
        CGFloat tmpx = offsetX;
        if (tmpx < _menu.maxOffset) {
            tmpx =  _menu.maxOffset - (_menu.maxOffset - tmpx )* 0.2;
        }
        
        if (tmpx > 0 ) {
            tmpx = 0;
        }
        [self move:tmpx];
        
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        accumulation = 0;
        CGPoint speed = [pan velocityInView:self];
        CGFloat time = 0.4;
        // time 根据滑动手势快慢 自适应改变
        if (offsetX < 0.5 * _menu.maxOffset) {// 开
            
            time = MIN(ABS((_menu.maxOffset - offsetX)*1.8/speed.x),time);
            [self openMenu:true time:time];
            
        }else{

            time = MIN( ABS(offsetX*1.8/speed.x),time);
            [self openMenu:false time:time];
            
        }
    }
}

- (void)openMenu:(BOOL)open time:(NSTimeInterval)time{
    
    _menu.currentOffset = open ? _menu.maxOffset : 0;
    _menu.state = SliderMenuSlider;
    
    [self.layer removeAllAnimations];
    
    [UIView animateWithDuration:time delay:0 options: UIViewAnimationOptionAllowUserInteraction |  UIViewAnimationOptionCurveEaseOut animations:^{
        [self move:self.menu.currentOffset];
        
    } completion:^(BOOL finished) {
        if (open) {
            self.menu.state = SliderMenuOpen;
        }else{
            self.menu.state = SliderMenuClose;
            self.menu.lock = false;
            [self.menu reset];
        }
    }];
}

- (void)move:(CGFloat)x{
    self.transform = CGAffineTransformMakeTranslation(x, 0);
    [_menu transform:x];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGPoint newP = [self convertPoint:point toView:_menu.view];
    if ( [_menu.view pointInside:newP withEvent:event])
    {
        return [_menu.view hitTest:newP withEvent:event];
        
    }
    return [super hitTest:point withEvent:event];
}
- (void)dealloc{
    [[SliderMenu shared] releaseView];
}
@end
