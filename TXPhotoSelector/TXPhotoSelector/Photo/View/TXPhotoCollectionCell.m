//
//  TXPhotoCollectionCell.m
//  TXPhotoSelector
//
//  Created by 秦田新 on 2017/6/9.
//  Copyright © 2017年 秦田新. All rights reserved.
//

#import "TXPhotoCollectionCell.h"
#import "TXPhoto.h"

@interface TXPhotoCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageV;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@end

@implementation TXPhotoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setPhoto:(TXPhoto *)photo{
    _photo = photo;
    self.photoImageV.image = photo.thumbnailImage;
    self.selectedButton.selected = photo.isSelected;
    self.coverView.hidden = photo.canSelected;
}

- (IBAction)selectButtonClicked:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCollectionCellSelectedWithQJPhoto:)]) {
        button.selected = !button.isSelected;
        self.photo.isSelected = button.isSelected;
        [self.delegate photoCollectionCellSelectedWithQJPhoto:self.photo];
    }
}


@end
