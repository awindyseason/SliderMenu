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
// 是否复用 (只存在一种menu样式时使用)
- (BOOL)isReuse;

- (BOOL)didSelectIndex:(NSInteger)index atIndexPath:(NSIndexPath *)indexPath;


@end

@interface SliderCell : UITableViewCell

@property (weak, nonatomic) NSObject<SliderDelegate> *delegate;


- (void)openMenu:(BOOL)flag time:(NSTimeInterval)time;

@end
