//
//  SliderCell.m
//  Cell
//
//  Created by YH on 2018/7/3.
//  Copyright © 2018年 XCY. All rights reserved.
//

#import "SliderCell.h"
#import "SliderMenu.h"
@interface SliderCell()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) SliderMenu *menu;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation SliderCell{
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
    self.menu = SliderMenu.shared;
//    self.menu.currentOffset = 0;
    
    _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    _pan.delegate = self;
    [self.contentView addGestureRecognizer:_pan];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return  true;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == _pan) {
        
        CGFloat offsety = [_pan translationInView:gestureRecognizer.view].y;
        
        if ( ABS(offsety) > 0) {
            if (self.menu.currentCell) {
                [self.menu.currentCell openMenu:false time:0.4];
                
            }
            return false;
        }
    }else{
        
    }
    
    return true;
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGFloat panX = [pan translationInView:pan.view].x;
    CGFloat offsetX = panX + self.menu.currentOffset;
    //    NSLog(@"===%f",self.menu.currentOffset);
    if ( offsetX > 0) {
        offsetX = 0;
    }
    
    if ( self.menu.lock ) { // 抽屉执行关闭动画后才能进行下次打开
        //  取消手势
//        _pan.enabled = false;
//        _pan.enabled = true;
        accumulation = -panX;
        return;
    }else{
        offsetX = panX + self.menu.currentOffset  + accumulation;
        if (!self.menu.view.superview) {
            [self.menu menuForCell:self];
        }
    }
    
    if (pan.state == UIGestureRecognizerStateBegan){
        
        if (self.menu.currentCell  && ![self.menu.currentCell isEqual:self] ) {
            
            self.menu.lock = true;
            [self.menu.currentCell openMenu:false time:0.4];
            return;
            
        }

    }else if (pan.state == UIGestureRecognizerStateChanged){
        
        if (panX > 0&&[self.menu.currentCell isEqual:self]) {
            self.menu.lock = true;
            [self.menu.currentCell openMenu:false time:0.3];
            return;
        }
        self.menu.state = SliderMenuSlider;
        CGFloat tmpx = offsetX;
        if (tmpx < self.menu.totalWidth) {
            tmpx =  self.menu.totalWidth - (self.menu.totalWidth - tmpx )* 0.2;
        }
        
        if (tmpx > 0 ) {
            tmpx = 0;
        }
        [self move:tmpx];
        
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
        accumulation = 0;
        CGPoint speed = [pan velocityInView:self];
        
        CGFloat time = 0.3;
        
        if (offsetX < 0.5 * self.menu.totalWidth) {// 开
            
            time = MIN( ABS((self.menu.totalWidth - offsetX)*1.8/speed.x),time);
            
            [self openMenu:true time:time];
            
        }else{
            
            time = MIN( ABS(offsetX*1.8/speed.x),time);
            [self openMenu:false time:time];
            
        }
    }
}

- (void)openMenu:(BOOL)flag time:(NSTimeInterval)time{
    
    self.menu.currentOffset = flag ? self.menu.totalWidth : 0;
    self.menu.state = SliderMenuSlider;
    
    [self.layer removeAllAnimations];
    
    [UIView animateWithDuration:time delay:0 options: UIViewAnimationOptionAllowUserInteraction |  UIViewAnimationOptionCurveEaseOut animations:^{
        [self move:self.menu.currentOffset];
        
    } completion:^(BOOL finished) {
        if (flag) {
            self.menu.state = SliderMenuOpen;
            
        }else{
            self.menu.state = SliderMenuClose;
            self.menu.lock = false;
            [self.menu releaseFromCell];
            
        }
        
    }];
    
}

- (void)move:(CGFloat)x{
    self.transform = CGAffineTransformMakeTranslation(x, 0);
    [self.menu move:x];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGPoint newP = [self convertPoint:point toView:self.menu.view];
    if ( [self.menu.view pointInside:newP withEvent:event])
    {
        return [self.menu.view hitTest:newP withEvent:event];
 
    }
    return [super hitTest:point withEvent:event];
}
@end
