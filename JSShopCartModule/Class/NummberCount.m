//
//  NummberCount.m
//  JSShopCartModule
//
//  Created by XuBill on 2016/12/15.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "NummberCount.h"

@interface NummberCount ()
//加
@property (nonatomic, strong) UIButton    *addButton;
//减
@property (nonatomic, strong) UIButton    *subButton;
//数字按钮
@property (nonatomic, strong) UITextField *numberTT;

@end

@implementation NummberCount


static CGFloat const Wd = 28;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUI];
}

#pragma mark -  set UI

- (void)setUI{
    
    self.backgroundColor = [UIColor clearColor];
    self.currentCountNumber = 0;
    self.totalNum = 0;
    WEAK
    /************************** 减 ****************************/
    _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subButton.frame = CGRectMake(0, 0, Wd,Wd);
    [_subButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_normal"]
                          forState:UIControlStateNormal];
    [_subButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_no"]
                          forState:UIControlStateDisabled];
    _subButton.tag = 0;
    kWeakSelf(self);
    [self.subButton addAction:^(UIButton *btn) {
        kStrongSelf(self);
        self.currentCountNumber--;
        if (self.NumberChangeBlock) {
            self.NumberChangeBlock(self.currentCountNumber);
        }
    }];
    [self addSubview:_subButton];
    
    /************************** 内容 ****************************/
    self.numberTT = [[UITextField alloc]init];
    self.numberTT.frame = CGRectMake(CGRectGetMaxX(_subButton.frame), 0, Wd*1.5, _subButton.frame.size.height);
    self.numberTT.keyboardType=UIKeyboardTypeNumberPad;
    self.numberTT.text=[NSString stringWithFormat:@"%@",@(0)];
    self.numberTT.backgroundColor = [UIColor whiteColor];
    self.numberTT.textColor = [UIColor blackColor];
    self.numberTT.adjustsFontSizeToFitWidth = YES;
    self.numberTT.textAlignment=NSTextAlignmentCenter;
    self.numberTT.layer.borderColor = XNColor(201, 201, 201, 1).CGColor;
    self.numberTT.layer.borderWidth = 1.3;
    self.numberTT.font= XNFont(17);
    [self addSubview:self.numberTT];
    
    /************************** 加 ****************************/
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(CGRectGetMaxX(_numberTT.frame), 0, Wd,Wd);
    [_addButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_normal"]
                          forState:UIControlStateNormal];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_no"]
                          forState:UIControlStateDisabled];
    _addButton.tag = 1;
    [self.addButton addAction:^(UIButton *btn) {
        kStrongSelf(self);
        self.currentCountNumber++;
        if (self.NumberChangeBlock) {
            self.NumberChangeBlock(self.currentCountNumber);
        }
    }];
    
    [self addSubview:_addButton];
    
    /************************** 内容改变 ****************************/
    [self xw_addObserverBlockForKeyPath:@"numberTT" block:^(id obj, id oldVal, id newVal) {
        UITextField *t1 = [newVal object];
        NSString *text = t1.text;
        NSInteger changeNum = 0;
        if (text.integerValue>self.totalNum&&self.totalNum!=0) {
            
            self.currentCountNumber = self.totalNum;
            self.numberTT.text = [NSString stringWithFormat:@"%@",@(self.totalNum)];
            changeNum = self.totalNum;
            
        } else if (text.integerValue<1){
            
            self.numberTT.text = @"1";
            changeNum = 1;
            
        } else {
            
            self.currentCountNumber = text.integerValue;
            changeNum = self.currentCountNumber;
            
        }
        if (self.NumberChangeBlock) {
            self.NumberChangeBlock(changeNum);
        }
    }];
    /* 捆绑加减的enable */
    [self xw_addObserverBlockForKeyPath:@"currentCountNumber" block:^(id obj, id oldVal, id newVal) {
        self.subButton.enabled = [newVal integerValue] > 1? YES:NO;
        self.addButton.enabled = [newVal integerValue] < self.totalNum ? YES:NO;
        self.numberTT.text = [NSString stringWithFormat:@"%@",newVal];
    }];
    /* 内容颜色显示 */
    [self xw_addObserverBlockForKeyPath:@"totalNum" block:^(id obj, id oldVal, id newVal) {
        self.numberTT.textColor =  [newVal integerValue] == 0? [UIColor redColor]:[UIColor blackColor];
    }];

}

@end
