//
//  TXShowPictureController.h
//  TXPhotoSelector
//
//  Created by 秦田新 on 2017/6/9.
//  Copyright © 2017年 秦田新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXShowPictureController : UIViewController

@property(nonatomic,strong)NSMutableArray *photoArray;
@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,assign)BOOL deleButtonHidden;
@property(nonatomic,assign)BOOL navBarHidden;


@end
