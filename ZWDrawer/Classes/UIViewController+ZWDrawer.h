//
//  UIViewController+ZWDrawer.h
//  ZWDrawer
//
//  Created by zzw on 2018/4/16.
//  Copyright © 2018年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZWDrawer)
@property (nonatomic,strong) UIView * maskView;
@property (nonatomic,strong) UIView * leftView;
@property (nonatomic,strong) UIImageView * bgImgView;
+ (UIViewController *)createDrawer;

@end
