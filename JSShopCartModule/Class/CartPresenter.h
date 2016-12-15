//
//  CartPresenter.h
//  JSShopCartModule
//
//  Created by XuBill on 2016/12/15.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CartViewControllerProtocol <NSObject>

@end

@interface CartPresenter : NSObject
@property (nonatomic, strong) NSMutableArray       *cartData;//大数组包括小数组(店铺) 小数组包括商品模型  实际开发时，店铺应该是一个模型。其中一个属性是商品模型数组。
@property (nonatomic, weak  ) UITableView          *cartTableView;
/**
 *  存放店铺选中
 */
@property (nonatomic, strong) NSMutableArray       *shopSelectArray;
/**
 *  carbar 观察的属性变化
 */
@property (nonatomic, assign) float                 allPrices;
/**
 *  carbar 全选的状态
 */
@property (nonatomic, assign) BOOL                  isSelectAll;
/**
 *  购物车商品数量
 */
@property (nonatomic, assign) NSInteger             cartGoodsCount;
/**
 *  当前所选商品数量
 */
@property (nonatomic, assign) NSInteger             currentSelectCartGoodsCount;

- (instancetype)initWithPresenter:(id <CartViewControllerProtocol>)delegate;

//获取数据
- (void)getData;

//全选
- (void)selectAll:(BOOL)isSelect;

//row select
- (void)rowSelect:(BOOL)isSelect
        IndexPath:(NSIndexPath *)indexPath;

//row change quantity
- (void)rowChangeQuantity:(NSInteger)quantity
                indexPath:(NSIndexPath *)indexPath;

//获取价格
- (float)getAllPrices;

//左滑删除商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path;

//选中删除
- (void)deleteGoodsBySelect;
@end
