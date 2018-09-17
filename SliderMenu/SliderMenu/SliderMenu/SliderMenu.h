//
//  Menu.h
//  Cell
//
//  Created by YH on 2018/7/3.
//  Copyright © 2018年 XCY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderCell.h"
@class SliderCell;
@class MenuItem;

// 当前menu状态
typedef NS_ENUM(NSInteger,SliderMenuState) {
    SliderMenuClose, // 关闭
    SliderMenuSlider, // 滑动中
    SliderMenuOpen // 打开
};
@class SliderView;

@interface SliderMenu : NSObject

@property (assign, nonatomic) SliderMenuState state;
@property (assign, nonatomic) BOOL lock;
@property (assign, nonatomic) CGFloat totalWidth;
@property (strong, nonatomic) SliderView *view;
@property (weak, nonatomic) SliderCell *currentCell;
@property (assign, nonatomic) CGFloat currentOffset;

+ (instancetype)shared;


- (void)menuForCell:(SliderCell *)cell;
- (void)transform:(CGFloat)x;
- (void)close;
- (void)reset;
- (void)releaseView;

@end

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

