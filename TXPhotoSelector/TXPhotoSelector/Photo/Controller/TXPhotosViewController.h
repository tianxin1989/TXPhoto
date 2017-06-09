//
//  TXPhotosViewController.h
//  TXPhotoSelector
//
//  Created by 秦田新 on 2017/6/9.
//  Copyright © 2017年 秦田新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PhotoArrayBlock)(NSArray *photoArray);


@interface TXPhotosViewController : UIViewController

@property(nonatomic,strong)NSArray *selectedArray;

@property(nonatomic,copy)PhotoArrayBlock block;

-(void)photoArrayBlock:(PhotoArrayBlock)block;

@end
