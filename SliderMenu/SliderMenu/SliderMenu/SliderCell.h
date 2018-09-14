//
//  SliderCell.h
//  Cell
//
//  Created by YH on 2018/7/3.
//  Copyright © 2018年 XCY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuItem;
@protocol SliderDelegate

- (NSArray<MenuItem *> *)itemsForIndexPath:(NSIndexPath *)indexPath;

@optional

- (void)didSelectIndex:(NSInteger)index atIndexPath:(NSIndexPath *)indexPath;


@end

@interface SliderCell : UITableViewCell

@property (weak, nonatomic) NSObject<SliderDelegate> *delegate;


- (void)openMenu:(BOOL)flag time:(NSTimeInterval)time;

@end
