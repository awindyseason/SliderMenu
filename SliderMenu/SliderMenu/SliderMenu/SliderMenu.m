

#import "SliderMenu.h"

static SliderMenu *shared = nil;
@interface SliderMenu()

@end
@implementation SliderMenu

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SliderMenu new];
        
    });
    return shared;
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

