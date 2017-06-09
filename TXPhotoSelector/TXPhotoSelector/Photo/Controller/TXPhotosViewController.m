//
//  TXPhotosViewController.m
//  TXPhotoSelector
//
//  Created by 秦田新 on 2017/6/9.
//  Copyright © 2017年 秦田新. All rights reserved.
//

#define PHOTOCELL_WIDTH (g_screenWidth - (ColumnCount+1)*Cell_MARAGIN)/ColumnCount
#define MaxCount 9
#define PHOTOCELL_ID @"photocell"

#import "TXPhotosViewController.h"
#import "TXConst.h"
#import "TXPhotoCollectionCell.h"
#import <Photos/Photos.h>
#import "TXPhoto.h"
#import "TXShowPictureController.h"

@interface TXPhotosViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,TXPhotoCollectionCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollection;
@property(nonatomic,strong)UICollectionViewFlowLayout *layout;
@property(nonatomic,strong)NSMutableArray *assetArray;
@property(nonatomic,strong)NSMutableArray *photoArray;
@property(nonatomic,strong)NSMutableArray *selectedPhotos;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property(nonatomic,assign)BOOL haveCover;

@end

@implementation TXPhotosViewController

-(UICollectionViewFlowLayout *)layout{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.itemSize = CGSizeMake(PHOTOCELL_WIDTH, PHOTOCELL_WIDTH);
        _layout.minimumLineSpacing = Cell_MARAGIN;
        _layout.minimumInteritemSpacing = Cell_MARAGIN;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(Cell_MARAGIN, Cell_MARAGIN, Cell_MARAGIN, Cell_MARAGIN);
    }
    return _layout;
}

-(NSMutableArray *)assetArray{
    if (_assetArray == nil) {
        _assetArray = [NSMutableArray array];
    }
    return _assetArray;
}

-(NSMutableArray *)photoArray{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

-(NSMutableArray *)selectedPhotos{
    if (_selectedPhotos == nil) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoCollection.collectionViewLayout = self.layout;
    [self.photoCollection registerNib:[UINib nibWithNibName:NSStringFromClass([TXPhotoCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:PHOTOCELL_ID];
    
    [self getThumbnailImages];
}

- (void)getThumbnailImages{
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original{
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        NSLog(@"localIdentifier = %@",asset.localIdentifier);
        [self.assetArray addObject:asset];
        UIScreen *screen = [UIScreen mainScreen];
        CGFloat scale = screen.scale;
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeMake(PHOTOCELL_WIDTH*scale, PHOTOCELL_WIDTH*scale);
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            TXPhoto *photo = [[TXPhoto alloc]init];
            photo.thumbnailImage = result;
            photo.canSelected = YES;
            photo.localIdentifier = asset.localIdentifier;
            //标记出已经选择的
            for (TXPhoto *selectedPhoto in self.selectedArray) {
                if ([selectedPhoto.localIdentifier isEqualToString:photo.localIdentifier]) {
                    photo.isSelected = YES;
                    [self photoCollectionCellSelectedWithQJPhoto:photo];
                }
            }
            [self.photoArray addObject:photo];
        }];
    }
    
    if (self.selectedPhotos.count) {
        [self.sureButton setTitle:[NSString stringWithFormat:@"完成(%zd)",self.selectedPhotos.count] forState:UIControlStateNormal];
    }
    if (self.selectedPhotos.count>=9) {
        [self showCover];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TXPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PHOTOCELL_ID forIndexPath:indexPath];
    cell.photo = self.photoArray[indexPath.item];
    cell.delegate = self;
    return cell;
}

#pragma mark  选择或取消选择照片
-(void)photoCollectionCellSelectedWithQJPhoto:(TXPhoto *)photo{
    if (photo.isSelected) {
        [self.selectedPhotos addObject:photo];
    }else{
        [self.selectedPhotos removeObject:photo];
        if (self.haveCover) {
            [self hiddenCover];
        }
    }
    self.sureButton.enabled = self.selectedPhotos.count != 0;
    [self.sureButton setTitle:[NSString stringWithFormat:@"完成(%zd)",self.selectedPhotos.count] forState:UIControlStateNormal];
    if (self.selectedPhotos.count >= MaxCount && self.haveCover == NO) {
        [self showCover];
    }
}

#pragma mark 显示遮盖
-(void)showCover{
    for (TXPhoto *photo in self.photoArray) {
        photo.canSelected = photo.isSelected;
    }
    [self.photoCollection reloadData];
    self.haveCover = YES;
}

#pragma mark 隐藏遮盖
-(void)hiddenCover{
    for (TXPhoto *photo in self.photoArray) {
        photo.canSelected = YES;
    }
    [self.photoCollection reloadData];
    self.haveCover = NO;
}

-(void)photoArrayBlock:(PhotoArrayBlock)block;{
    self.block = block;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TXShowPictureController *pictureCtr = [[TXShowPictureController alloc]init];
    pictureCtr.photoArray = [NSMutableArray arrayWithObject:self.photoArray[indexPath.item]];
    pictureCtr.navBarHidden = YES;
    pictureCtr.deleButtonHidden = YES;
    [self.navigationController pushViewController:pictureCtr animated:YES];
}

#pragma mark 选择完成按钮
- (IBAction)sureButtonClicked {
    if (self.block != nil) {
        self.block(self.selectedPhotos);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)previewButtonClicked {
    TXShowPictureController *pictureCtr = [[TXShowPictureController alloc]init];
    pictureCtr.photoArray = self.selectedPhotos;
    pictureCtr.navBarHidden = YES;
    pictureCtr.deleButtonHidden = YES;
    [self.navigationController pushViewController:pictureCtr animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
