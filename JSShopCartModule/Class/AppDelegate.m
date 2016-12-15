//
//  AppDelegate.m
//  JSShopCartModule
//
//  Created by 乔同新 on 16/6/8.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "AppDelegate.h"
#import "JSCartViewController.h"
#import "CartViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    CartViewController *cartVC = [[CartViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cartVC];
    self.window.rootViewController = nav;
    return YES;
    
//    JSCartViewController *cartVC = [[JSCartViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cartVC];
//    self.window.rootViewController = nav;
//    return YES;
}


@end
