//
//  YourCell.m
//  SliderMenu
//
//  Created by Tikbee on 2021/7/29.
//  Copyright © 2021 雎琳. All rights reserved.
//

#import "YourCell.h"

@implementation YourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = UIColor.yellowColor;
    
    _sv = [[UIScrollView alloc]init];
    _sv.backgroundColor = UIColor.brownColor;
    
    _sv.frame = CGRectMake(120, 10, 120, 40);
    [self.contentView addSubview:_sv];
    _sv.contentSize = CGSizeMake(300, 40);
    UILabel *lb = [[UILabel alloc]init];
    lb.text = @"内嵌scrollview手势优先滚动";
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = UIColor.blueColor;
    [self.sv addSubview:lb];
    lb.frame = CGRectMake(10, 10, 200, 20);
}
// 优先滚动sv（如果sv可以滚动） 不滚动slider
- (NSArray<UIView *> *)sliderFailByViews{
    return @[_sv];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
