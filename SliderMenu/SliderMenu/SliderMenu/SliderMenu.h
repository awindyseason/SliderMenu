

#import <UIKit/UIKit.h>
#import "SliderCell.h"


typedef NS_ENUM(NSInteger,SliderMenuState) {
    SliderMenuClose, // 关闭
    SliderMenuSlider, // 滑动中
    SliderMenuOpen // 打开
};
@class SliderView;

@interface SliderMenu : NSObject

// menu 状态
@property (assign, nonatomic) SliderMenuState state;
// lock 锁 , default is false . lock 为ture menu 不能滑动
@property (assign, nonatomic) BOOL lock;
// menu 的view
@property (strong, nonatomic ,readonly) SliderView *view;
// 当前menu所处的cell
@property (weak, nonatomic) SliderCell *currentCell;
// 当前偏移量
@property (assign, nonatomic) CGFloat currentOffset;
// menu 打开时的偏移量 ABS(maxOffset) == menu的宽度
@property (assign, nonatomic ,readonly) CGFloat maxOffset;

+ (instancetype)shared;

- (void)menuForCell:(SliderCell *)cell;
- (void)transform:(CGFloat)x;
- (void)close;
- (void)reset;
- (void)releaseView;

@end

// 配置按钮样式
@interface MenuItem:NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *bgcolor;

@property (assign, nonatomic) CGFloat width;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *font;

+ (instancetype)title:(NSString *)title bgcolor:(UIColor *)bgcolor;
@end

@interface SliderView:UIView
@end

