//
//  CartUIService.h
//  JSShopCartModule
//
//  Created by XuBill on 2016/12/15.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CartPresenter;
@interface CartUIService : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CartPresenter *cartPresenter;
@end
