//
//  JSCartShopModel.h
//  JSShopCartModule
//
//  Created by XuBill on 2016/12/15.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JSCartModel;//商品
@interface JSCartShopModel : NSObject

@property (nonatomic, strong) NSString  *name;

@property (nonatomic, strong) NSString  *imageUrl;

@property (nonatomic, assign) NSInteger price;

//是否被选中
@property (nonatomic, assign) BOOL      isSelect;

@property (nonatomic, strong) NSArray<JSCartModel *>* cartModelArr;

@end
