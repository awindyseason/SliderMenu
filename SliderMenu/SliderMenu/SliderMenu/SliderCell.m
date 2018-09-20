
#import "SliderCell.h"
#import "SliderMenu.h"

@interface SliderCell()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) SliderMenu *menu;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@property (assign, nonatomic) BOOL lastPanStateIsEnd;
@property (assign, nonatomic) BOOL cancelAnimationCompletion;
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
- (void)pan:(UIPanGestureRecognizer *)pan{
    if (_lastPanStateIsEnd && _menu.state == SliderMenuSlider && [_menu.currentCell isEqual:self]) {
        _cancelAnimationCompletion = true;
        
        [pan setTranslation:CGPointMake(self.layer.presentationLayer.frame.origin.x, 0) inView:pan.view];
    _menu.currentOffset = 0;
        [self move:self.layer.presentationLayer.frame.origin.x];
        
        
        [self.layer removeAllAnimations];
        [self.menu removeAnimations];
        
    }
    
    CGFloat panX = [pan translationInView:pan.view].x;
    if ( _menu.state == SliderMenuClose && panX >= 0 ) {
        //        [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
        return;
    }
    
    CGFloat offsetX = panX + _menu.currentOffset ;
    
    if ( _menu.lock ) {
        if (panX < 0){
            accumulation = -panX;
        }
        return;
    }else{
        if ( offsetX > 0) {
            offsetX = 0;
        }
        offsetX += accumulation;
        
        if (!_menu.view.superview) {
            [_menu menuForCell:self];
        }
    }
    
    _lastPanStateIsEnd = false;
    
    if (pan.state == UIGestureRecognizerStateBegan){
        
        if (_menu.currentCell  && ![_menu.currentCell isEqual:self] ) {
            _menu.lock = true;
            if (_menu.currentCell.hidden) {
                [_menu.currentCell openMenu:false time:0 springX:0];
            }else{
                if (panX > 0){
                    [_menu.currentCell openMenu:false time:0.35 springX:0];
                }else{
                    [_menu.currentCell openMenu:false time:0.15 springX:0];
                }
            }
            return;
        }
        
    }else if (pan.state == UIGestureRecognizerStateChanged){

        if (panX > 0 && [_menu.currentCell isEqual:self]) {
            if (_menu.state == SliderMenuOpen) {
                _pan.enabled = false;
                _pan.enabled = true;
                [_menu.currentCell openMenu:false time:0.35 springX:3];
            }
            return;
        }
        
        _menu.state = SliderMenuSlider;
        
        CGFloat tmpx = offsetX;
        if (tmpx < _menu.maxOffset) {
            tmpx =  _menu.maxOffset - (_menu.maxOffset - tmpx )* 0.25;
        }
        
        if (tmpx > 0 ) {
            tmpx = 0;
        }
        
        [self move:tmpx];
        
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        _lastPanStateIsEnd = true;
        accumulation = 0;
        CGPoint speed = [pan velocityInView:self];
        // time 根据滑动手势快慢 自适应改变 0.25 ~ 0.4之间
        CGFloat time = 0.4;
        if (offsetX < 0.3 * _menu.maxOffset || offsetX < -30) {// 开
            
            time = MAX(MIN(ABS((_menu.maxOffset - offsetX)*1.8/speed.x),time),0.25);
            if (offsetX < _menu.maxOffset){
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

- (void)openMenu:(BOOL)open time:(NSTimeInterval)time springX:(CGFloat)springX{
    
    CGFloat moveX = open ? _menu.maxOffset : 0;
    CGFloat alpha = open ? 1 : 0.5;
    _menu.state = SliderMenuSlider;
    [self.layer removeAllAnimations];
    [self.menu removeAnimations];
    UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionOverrideInheritedDuration |  UIViewAnimationOptionCurveEaseOut;
    
    
    [UIView animateWithDuration:time delay:0 options:options  animations:^{
        self.menu.view.alpha = alpha;
        [self move:moveX + springX];
        
    } completion:^(BOOL finished) {
         self.menu.view.alpha = 1;
        if (self.cancelAnimationCompletion){
            [self.menu removeAnimations];
            self.cancelAnimationCompletion = false;
            return ;
        }
        if (finished) {
            
            if (springX != 0 && !self.menu.lock) {
                
                [UIView animateWithDuration:0.3 delay:0 options:options animations:^{
                    [self move:moveX];
                } completion:nil];
                
            }
            if (open) {
                
                self.menu.state = SliderMenuOpen;
                self.menu.currentOffset = self.menu.maxOffset;
            }else{
                self.menu.state = SliderMenuClose;
                self.menu.currentOffset = 0;
                self.menu.lock = false;
                self.menu.lock = false;
                [self.menu reset];
            }
        }else{
            //            NSLog(@"false");
        }
    }];
}

- (void)move:(CGFloat)x{
    self.transform = CGAffineTransformMakeTranslation(x, 0);
    [_menu transform:x];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == _pan) {
        
        CGFloat panY = [_pan translationInView:gestureRecognizer.view].y;
        if ( ABS(panY) > 0) {
            if (_menu.currentCell) {
                [_menu.currentCell openMenu:false time:0.4 springX:0];
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
/* 点击关闭
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 [super touchesBegan:touches withEvent:event];
 if ([SliderMenu shared].state == SliderMenuOpen) {
 [[SliderMenu shared] close];
 }
 }
 */
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
