

#import <UIKit/UIKit.h>
#import "SliderCell.h"



@class SliderCell;

@interface SliderMenu : NSObject

@property (weak, nonatomic) SliderCell *currentCell;

+ (instancetype)shared;

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


