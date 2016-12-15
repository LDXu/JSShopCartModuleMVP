//
//  CartViewController.m
//  JSShopCartModule
//
//  Created by XuBill on 2016/12/15.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "CartViewController.h"
#import "CartPresenter.h"
#import "CartBar.h"
#import "CartUIService.h"
@interface CartViewController ()<CartViewControllerProtocol>
{
    BOOL _isEdit;
    UIBarButtonItem *_editItem;
    UIBarButtonItem *_makeDataItem;
}
@property (nonatomic, strong) CartUIService *service;
@property (nonatomic, strong) CartPresenter *cartPresenter;
@property (nonatomic, strong) UITableView     *cartTableView;
@property (nonatomic, strong) CartBar  *cartBar;
@end

@implementation CartViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getNewData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*setting up*/
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.title = @"购物车";
    /*eidit button*/
    _isEdit = NO;
    _makeDataItem = [[UIBarButtonItem alloc] initWithTitle:@"新数据"
                                                     style:UIBarButtonItemStyleDone
                                                    target:self
                                                    action:@selector(makeNewData:)];
    _makeDataItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = _makeDataItem;
    
    _editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                 style:UIBarButtonItemStyleDone
                                                target:self
                                                action:@selector(editClick:)];
    _editItem.tintColor = XNColor(170, 170, 170, 1);
    self.navigationItem.rightBarButtonItem = _editItem;
    /*add view*/
    [self.view addSubview:self.cartTableView];
    [self.view addSubview:self.cartBar];
    
    //全选
    kWeakSelf(self);
    [self.cartBar.selectAllButton addAction:^(UIButton *btn) {
        kStrongSelf(self);
        btn.selected = !btn.selected;
        [self.cartPresenter selectAll:btn.selected];
    }];
    
    //删除
    [self.cartBar.deleteButton addAction:^(UIButton *btn) {
        kStrongSelf(self);
        [self.cartPresenter deleteGoodsBySelect];
    }];
    //结算
    [self.cartBar.balanceButton addAction:^(UIButton *btn) {
        kStrongSelf(self);
        NSLog(@"我要去付钱了");
    }];
    /* 观察价格属性 */
    [self.cartPresenter xw_addObserverBlockForKeyPath:@"allPrices" block:^(id obj, id oldVal, id newVal) {
       self.cartBar.money = [newVal floatValue];
    }];
    
    /* 全选 状态 */
    [self.cartPresenter xw_addObserverBlockForKeyPath:@"isSelectAll" block:^(id obj, id oldVal, id newVal) {
        self.cartBar.selectAllButton.selected = [newVal boolValue];
    }];
    
    [self.cartPresenter xw_addObserverBlockForKeyPath:@"cartGoodsCount" block:^(id obj, id oldVal, id newVal) {
        if([newVal integerValue] == 0){
            self.title = [NSString stringWithFormat:@"购物车"];
        } else {
            self.title = [NSString stringWithFormat:@"购物车(%@)",newVal];
        }
    }];
    
    
    
}


#pragma mark - lazy load


- (CartUIService *)service{
    
    if (!_service) {
        _service = [[CartUIService alloc] init];
        _service.cartPresenter = self.cartPresenter;
    }
    return _service;
}


- (UITableView *)cartTableView{
    
    if (!_cartTableView) {
        
        _cartTableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                      style:UITableViewStyleGrouped];
        [_cartTableView registerNib:[UINib nibWithNibName:@"JSCartCell" bundle:nil]
             forCellReuseIdentifier:@"JSCartCell"];
        [_cartTableView registerClass:NSClassFromString(@"JSCartFooterView") forHeaderFooterViewReuseIdentifier:@"JSCartFooterView"];
        [_cartTableView registerClass:NSClassFromString(@"JSCartHeaderView") forHeaderFooterViewReuseIdentifier:@"JSCartHeaderView"];
        _cartTableView.dataSource = self.service;
        _cartTableView.delegate   = self.service;
        _cartTableView.backgroundColor = XNColor(240, 240, 240, 1);
        _cartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XNWindowWidth, 50)];
    }
    return _cartTableView;
}

- (CartBar *)cartBar{
    
    if (!_cartBar) {
        _cartBar = [[CartBar alloc] initWithFrame:CGRectMake(0, XNWindowHeight-50, XNWindowWidth, 50)];
        _cartBar.isNormalState = YES;
    }
    return _cartBar;
}

#pragma mark - method

- (void)getNewData{
    /**
     *  获取数据
     */
    [self.cartPresenter getData];
    [self.cartTableView reloadData];
}

- (void)editClick:(UIBarButtonItem *)item{
    _isEdit = !_isEdit;
    NSString *itemTitle = _isEdit == YES?@"完成":@"编辑";
    _editItem.title = itemTitle;
    self.cartBar.isNormalState = !_isEdit;
}

- (void)makeNewData:(UIBarButtonItem *)item{
    
    [self getNewData];
}

- (CartPresenter *)cartPresenter {
    if (!_cartPresenter) {
        _cartPresenter = [[CartPresenter alloc] initWithPresenter:self];
        _cartPresenter.cartTableView = self.cartTableView;
    }
    return _cartPresenter;
}
@end
