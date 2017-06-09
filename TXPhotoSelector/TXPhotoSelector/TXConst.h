//
//  TXConst.h
//  TXPhotoSelector
//
//  Created by 秦田新 on 2017/6/9.
//  Copyright © 2017年 秦田新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXConst : NSObject

#define g_screenWidth [UIScreen mainScreen].bounds.size.width
#define g_screenHeight [UIScreen mainScreen].bounds.size.height
#define NAV_BAR_HEIGHT 64
#define TXNotificationCenter [NSNotificationCenter defaultCenter]

extern NSString *const TXPhotoDeleteNotification;

#define Cell_MARAGIN 8
#define ColumnCount 4

@end
