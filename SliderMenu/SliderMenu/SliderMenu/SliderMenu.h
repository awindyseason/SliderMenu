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

typedef NS_ENUM(NSInteger,SliderMenuState) {
    SliderMenuClose,
    SliderMenuSlider,
    SliderMenuOpen
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

- (void)releaseFromCell;
- (void)menuForCell:(SliderCell *)cell;
- (void)move:(CGFloat)x;
- (void)close;

@end

@interface MenuItem:NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) CGFloat width;
@property (strong, nonatomic) UIColor *bgcolor;
@end
@interface SliderView:UIView
@end

