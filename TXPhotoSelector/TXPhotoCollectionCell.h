//
//  TXPhotoCollectionCell.h
//  TXPhotoSelector
//
//  Created by 秦田新 on 2017/6/9.
//  Copyright © 2017年 秦田新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXPhoto;

@protocol TXPhotoCollectionCellDelegate <NSObject>

-(void)photoCollectionCellSelectedWithQJPhoto:(TXPhoto *)photo;
@end
@interface TXPhotoCollectionCell : UICollectionViewCell

@property(nonatomic,strong)TXPhoto *photo;
@property(nonatomic,weak)id<TXPhotoCollectionCellDelegate> delegate;

@end
