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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
