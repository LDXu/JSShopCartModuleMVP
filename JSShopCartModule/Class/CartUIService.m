//
//  CartUIService.m
//  JSShopCartModule
//
//  Created by XuBill on 2016/12/15.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "CartUIService.h"
#import "CartPresenter.h"
#import "JSCartCell.h"
#import "JSCartHeaderView.h"
#import "JSCartFooterView.h"
#import "JSCartModel.h"
#import "JSNummberCount.h"
@implementation CartUIService
#pragma mark - UITableView Delegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cartPresenter.cartData.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.cartPresenter.cartData[section] count];
}

#pragma mark - header view

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [JSCartHeaderView getCartHeaderHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSMutableArray *shopArray = self.cartPresenter.cartData[section];
    
    JSCartHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JSCartHeaderView"];
    //店铺全选
    [headerView.selectStoreGoodsButton addAction:^(UIButton *xx){
        xx.selected = !xx.selected;
        BOOL isSelect = xx.selected;
        [self.cartPresenter.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelect)];
        for (JSCartModel *model in shopArray) {
            [model setValue:@(isSelect) forKey:@"isSelect"];
        }
        [self.cartPresenter.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        
        self.cartPresenter.allPrices = [self.cartPresenter getAllPrices];
    }];
    //店铺选中状态
    headerView.selectStoreGoodsButton.selected = [self.cartPresenter.shopSelectArray[section] boolValue];

    return headerView;
}

#pragma mark - footer view

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [JSCartFooterView getCartFooterHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSMutableArray *shopArray = self.cartPresenter.cartData[section];
    
    JSCartFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JSCartFooterView"];
    
    footerView.shopGoodsArray = shopArray;
    
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [JSCartCell getCartCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSCartCell"
                                                       forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(JSCartCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    JSCartModel *model = self.cartPresenter.cartData[section][row];
    //cell 选中
    kWeakSelf(self);
    [cell.selectShopGoodsButton addAction:^(UIButton *btn) {
        kStrongSelf(self);
        btn.selected = !btn.selected;
        [self.cartPresenter rowSelect:btn.selected IndexPath:indexPath];
    }];
    //数量改变
    cell.nummberCount.NumberChangeBlock = ^(NSInteger changeCount){
        kStrongSelf(self);
        [self.cartPresenter rowChangeQuantity:changeCount indexPath:indexPath];
    };
    cell.model = model;
}

#pragma mark - delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.cartPresenter deleteGoodsBySingleSlide:indexPath];
    }
}

@end
