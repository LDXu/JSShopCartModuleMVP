//
//  NummberCount.h
//  JSShopCartModule
//
//  Created by XuBill on 2016/12/15.
//  Copyright © 2016年 乔同新. All rights reserved.
//
// https://github.com/ChandHsu/XQNumCalculateView 加减封装控件
#import <UIKit/UIKit.h>
typedef void(^JSNumberChangeBlock)(NSInteger count);
@interface NummberCount : UIView
/**
 *  总数
 */
@property (nonatomic, assign) NSInteger           totalNum;
/**
 *  当前显示价格
 */
@property (nonatomic, assign) NSInteger           currentCountNumber;
/**
 *  数量改变回调
 */
@property (nonatomic, copy  ) JSNumberChangeBlock NumberChangeBlock;
@end
