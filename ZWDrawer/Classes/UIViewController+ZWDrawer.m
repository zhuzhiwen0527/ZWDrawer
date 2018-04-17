//
//  UIViewController+ZWDrawer.m
//  ZWDrawer
//
//  Created by zzw on 2018/4/16.
//  Copyright © 2018年 zzw. All rights reserved.
//

#import "UIViewController+ZWDrawer.h"
#import <objc/runtime.h>
static const void * zw_leftViewKey = &zw_leftViewKey;
static const void * zw_bgImgViewKey = &zw_bgImgViewKey;
static const void * zw_maskViewKey = &zw_maskViewKey;
@implementation UIViewController (ZWDrawer)

- (void)initializeDrawer{
    self.view.backgroundColor = [UIColor blackColor];
    self.bgImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgImgView.transform = CGAffineTransformMakeScale(.9, .9);
    self.bgImgView.image = [self openglSnapshotImage];
    [self.view addSubview:self.bgImgView];
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0.184 green:0.184 blue:0.216 alpha:1];
    self.maskView.alpha = 0.2;
    
    [self.view addSubview:self.maskView];
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width*0.75 , [UIScreen mainScreen].bounds.size.height)];
    self.leftView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.leftView];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    [self.maskView addGestureRecognizer:tap];
}


#pragma mark -- 拖动隐藏

-(void)didPanEvent:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
//    NSLog(@"translation.x == %f", translation.x);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if(UIGestureRecognizerStateBegan == recognizer.state ||
       UIGestureRecognizerStateChanged == recognizer.state){
        NSLog(@"%lf, %lf",self.leftView.frame.origin.x,translation.x);
        if(self.leftView.frame.origin.x >= 0 && translation.x > 0 ){
            return;
            
        }
        
            
            CGFloat tempX = CGRectGetMinX(self.leftView.frame) + translation.x;
            self.leftView.frame = CGRectMake(tempX, 0, [UIScreen mainScreen].bounds.size.width*0.75, CGRectGetHeight(self.view.frame));
        self.maskView.alpha =(1 -(fabs(self.leftView.frame.origin.x)/[UIScreen mainScreen].bounds.size.width*0.75)) * 0.2;
        CGFloat scale =0.9 + (fabs(self.leftView.frame.origin.x)/[UIScreen mainScreen].bounds.size.width*0.75) * 0.1;
     
        self.bgImgView.transform = CGAffineTransformMakeScale(scale, scale);
        if(self.leftView.frame.origin.x <= -[UIScreen mainScreen].bounds.size.width*0.75 && translation.x<0){
            
            NSLog(@"消失");
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
            return;
            
        }
        
    }else
    {
  
        if( - self.leftView.frame.origin.x  > CGRectGetWidth(self.view.frame)*0.2){
            
               [self hidden];
        }else{
            
                [self show];
        }
     
    }
}

/**关闭左视图 */
- (void)hidden
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        self.leftView.frame = CGRectMake(- CGRectGetWidth(self.view.frame)*0.75, 0, CGRectGetWidth(self.view.frame)*0.75, CGRectGetHeight(self.view.frame));
            self.maskView.alpha = 0.0;
         self.bgImgView.transform = CGAffineTransformMakeScale(1, 1);
    }completion:^(BOOL finished) {
      
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
}

/** 打开视图 */
- (void)show
{
    self.maskView.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        self.leftView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)*0.75, CGRectGetHeight(self.view.frame));
        self.bgImgView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.maskView.alpha = 0.2;
    } completion:^(BOOL finished) {
     
    }];
}


#pragma mark -- getter & setter
- (void)setLeftView:(UIView *)leftView{
    
    objc_setAssociatedObject(self, zw_leftViewKey, leftView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (UIView *)leftView{
    
    return  objc_getAssociatedObject(self, zw_leftViewKey);
}
- (void)setMaskView:(UIView *)maskView{
    
     objc_setAssociatedObject(self, zw_maskViewKey, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView*)maskView{
       return objc_getAssociatedObject(self, zw_maskViewKey);
}
- (void)setBgImgView:(UIImageView *)bgImgView{
    
    objc_setAssociatedObject(self, zw_bgImgViewKey, bgImgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImageView*)bgImgView{
       return objc_getAssociatedObject(self, zw_bgImgViewKey);
}
#pragma mark -- private
- (UIImage *)openglSnapshotImage
{

    CGSize size = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = [UIScreen mainScreen].bounds;
    NSLog(@"%@",NSStringFromCGRect(rect));
    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}
@end
