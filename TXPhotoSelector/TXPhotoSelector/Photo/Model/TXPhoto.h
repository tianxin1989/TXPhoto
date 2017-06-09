//
//  TXPhoto.h
//  TXPhotoSelector
//
//  Created by 秦田新 on 2017/6/9.
//  Copyright © 2017年 秦田新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TXPhoto : NSObject

@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,assign)BOOL canSelected;
@property(nonatomic,strong)UIImage *thumbnailImage;
/**
 图片本地标识符
 */
@property(nonatomic,copy)NSString *localIdentifier;


@end
