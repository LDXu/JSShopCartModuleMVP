//
//  CartPresenter.m
//  JSShopCartModule
//
//  Created by XuBill on 2016/12/15.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "CartPresenter.h"
#import "JSCartModel.h"

@interface CartPresenter ()
{
    NSArray *_shopGoodsCount;
    NSArray *_goodsPicArray;
    NSArray *_goodsPriceArray;
    NSArray *_goodsQuantityArray;
}
//随机获取店铺下商品数
@property (nonatomic, assign) NSInteger random;

@property (nonatomic,strong) JSCartModel *jsCartModell;
@property (nonatomic,weak) id<CartViewControllerProtocol> delegate;
@end

@implementation CartPresenter
- (instancetype)initWithPresenter:(id <CartViewControllerProtocol>)delegate{
    self = [self init];
    if (self) {
        self.delegate = delegate;
        _jsCartModell = [[JSCartModel alloc]init];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //6
        _shopGoodsCount  = @[@(1),@(8),@(5),@(2),@(4),@(4)];
        _goodsPicArray  = @[@"http://pic.5tu.cn/uploads/allimg/1606/pic_5tu_big_2016052901023305535.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_2016052901023303745.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_201605291711245481.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_2016052901023285762.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1506/091630516760.jpg",
                            @"http://pic.5tu.cn/uploads/allimg/1506/091630516760.jpg"];
        _goodsPriceArray = @[@(30.45),@(120.09),@(7.8),@(11.11),@(56.1),@(12)];
        _goodsQuantityArray = @[@(12),@(21),@(1),@(10),@(3),@(5)];
    }
    return self;
}

- (NSInteger)random{
    
    NSInteger from = 0;
    NSInteger to   = 5;
    
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
    
}

#pragma mark - make data

- (void)getData{
    //数据个数
    NSInteger allCount = 20;
    NSInteger allGoodsCount = 0;
    NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:allCount];
    NSMutableArray *shopSelectAarry = [NSMutableArray arrayWithCapacity:allCount];
    //创造店铺数据
    for (int i = 0; i<allCount; i++) {
        //创造店铺下商品数据
        NSInteger goodsCount = [_shopGoodsCount[self.random] intValue];
        NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:goodsCount];
        for (int x = 0; x<goodsCount; x++) {
            JSCartModel *cartModel = [[JSCartModel alloc] init];
            cartModel.p_id         = @"122115465400";
            cartModel.p_price      = [_goodsPriceArray[self.random] floatValue];
            cartModel.p_name       = [NSString stringWithFormat:@"%@这是一个很长很长的名字呀呀呀呀呀呀",@(x)];
            cartModel.p_stock      = 22;
            cartModel.p_imageUrl   = _goodsPicArray[self.random];
            cartModel.p_quantity   = [_goodsQuantityArray[self.random] integerValue];
            [goodsArray addObject:cartModel];
            allGoodsCount++;
        }
        [storeArray addObject:goodsArray];
        [shopSelectAarry addObject:@(NO)];
    }
    self.cartData = storeArray;
    self.shopSelectArray = shopSelectAarry;
    self.cartGoodsCount = allGoodsCount;
}

- (float)getAllPrices{
    
    __block float allPrices   = 0;
    NSInteger shopCount       = self.cartData.count;
    NSInteger shopSelectCount = self.shopSelectArray.count;
    if (shopSelectCount == shopCount && shopCount!=0) {
        self.isSelectAll = YES;
    }
    
    for (NSArray *storeArr in self.cartData) {
        for (JSCartModel *model in storeArr) {
            if (model.isSelect) {
                allPrices += model.p_quantity*model.p_price;
            }
        }
    }
    return allPrices;
}

- (void)selectAll:(BOOL)isSelect{
    
    __block float allPrices   = 0;
    for (int i = 0; i < self.shopSelectArray.count; i++) {
        [self.shopSelectArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:isSelect]];
    }
    for (NSArray *storeArr in self.cartData) {
        for (JSCartModel *model in storeArr) {
            model.isSelect = isSelect;
            if (model.isSelect) {
                allPrices += model.p_quantity*model.p_price;
            }
        }
    }
    self.allPrices = allPrices;
    [self.cartTableView reloadData];
    
}

- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section          = indexPath.section;
    NSInteger row              = indexPath.row;
    
    NSMutableArray *goodsArray = self.cartData[section];
    NSInteger shopCount        = goodsArray.count;
    JSCartModel *model         = goodsArray[row];
    [model setValue:@(isSelect) forKey:@"isSelect"];
    //判断是都到达足够数量
    NSInteger isSelectShopCount = 0;
    for (JSCartModel *model in goodsArray) {
        if (model.isSelect) {
            isSelectShopCount++;
        }
    }
    [self.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelectShopCount==shopCount?YES:NO)];
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
}

- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath{
    
    NSInteger section  = indexPath.section;
    NSInteger row      = indexPath.row;
    
    JSCartModel *model = self.cartData[section][row];
    
    [model setValue:@(quantity) forKey:@"p_quantity"];
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
}

//左滑删除商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path{
    
    NSInteger section = path.section;
    NSInteger row     = path.row;
    
    NSMutableArray *shopArray = self.cartData[section];
    [shopArray removeObjectAtIndex:row];
    if (shopArray.count == 0) {
        /*1 删除数据*/
        [self.cartData removeObjectAtIndex:section];
        /*2 删除 shopSelectArray*/
        [self.shopSelectArray removeObjectAtIndex:section];
        [self.cartTableView reloadData];
    } else {
        [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }
    self.cartGoodsCount-=1;
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
}

//选中删除
- (void)deleteGoodsBySelect{
    
    /*1 删除数据*/
    NSInteger index1 = -1;
    NSMutableIndexSet *shopSelectIndex = [NSMutableIndexSet indexSet];
    for (NSMutableArray *shopArray in self.cartData) {
        index1++;
        
        NSInteger index2 = -1;
        NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
        for (JSCartModel *model in shopArray) {
            index2++;
            if (model.isSelect) {
                [selectIndexSet addIndex:index2];
            }
        }
        NSInteger shopCount = shopArray.count;
        NSInteger selectCount = selectIndexSet.count;
        if (selectCount == shopCount) {
            [shopSelectIndex addIndex:index1];
            self.cartGoodsCount-=selectCount;
        }
        [shopArray removeObjectsAtIndexes:selectIndexSet];
    }
    [self.cartData removeObjectsAtIndexes:shopSelectIndex];
    /*2 删除 shopSelectArray*/
    [self.shopSelectArray removeObjectsAtIndexes:shopSelectIndex];
    [self.cartTableView reloadData];
    /*3 carbar 恢复默认*/
    self.allPrices = 0;
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
    
}



@end
