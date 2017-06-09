//
//  TXPublishViewController.m
//  TXPhotoSelector
//
//  Created by 秦田新 on 2017/6/9.
//  Copyright © 2017年 秦田新. All rights reserved.
//

#define PICTURE_CELL_ID @"picturecell"
#define PICTURECELL_WIDTH (g_screenWidth - (ColumnCount+1)*Cell_MARAGIN)/ColumnCount

#import "TXPublishViewController.h"
#import "TXPictureCollectionCell.h"
#import "TXShowPictureController.h"
#import "TXPhoto.h"
#import "TXPhotosViewController.h"
#import "TXConst.h"

@interface TXPublishViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *pictureCollectionView;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)UICollectionViewFlowLayout *layOut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictCollectHeightCon;

@end

@implementation TXPublishViewController

-(NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

-(UICollectionViewFlowLayout *)layOut{
    if (_layOut == nil) {
        _layOut = [[UICollectionViewFlowLayout alloc]init];
        _layOut.itemSize = CGSizeMake(PICTURECELL_WIDTH, PICTURECELL_WIDTH);
        _layOut.minimumLineSpacing = Cell_MARAGIN;
        _layOut.minimumInteritemSpacing = Cell_MARAGIN;
        _layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layOut.sectionInset = UIEdgeInsetsMake(0, Cell_MARAGIN, 0, Cell_MARAGIN);
    }
    return _layOut;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pictureCollectionView.collectionViewLayout = self.layOut;
    [self.pictureCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TXPictureCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:PICTURE_CELL_ID];
    
    [TXNotificationCenter addObserver:self selector:@selector(photoDidChange) name:TXPhotoDeleteNotification object:nil];
}

-(void)photoDidChange{
    self.pictCollectHeightCon.constant = ((self.imageArray.count)/ColumnCount+1) *(PICTURECELL_WIDTH+Cell_MARAGIN);
    [self.pictureCollectionView reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TXPictureCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PICTURE_CELL_ID forIndexPath:indexPath];
    if (indexPath.item<self.imageArray.count) {
        TXPhoto *photo = self.imageArray[indexPath.item];
        cell.pictureImageV.image = photo.thumbnailImage;
    }else{
        cell.pictureImageV.image = [UIImage imageNamed:@"addImage"];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item > self.imageArray.count) {
        TXShowPictureController *pictureCtr = [[TXShowPictureController alloc]init];
        pictureCtr.photoArray = self.imageArray;
        pictureCtr.currentIndex = indexPath.item;
        pictureCtr.deleButtonHidden = NO;
        pictureCtr.navBarHidden = YES;
        [self.navigationController pushViewController:pictureCtr animated:YES];
    }else{
            [self creatAlertController];
    }
}

-(void)creatAlertController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __weak typeof(self) weakself = self;
        TXPhotosViewController *photoCtr = [[TXPhotosViewController alloc]init];
        [photoCtr photoArrayBlock:^(NSArray *photoArray) {
            [weakself.imageArray removeAllObjects];
            [weakself.imageArray addObjectsFromArray:photoArray];
            NSInteger rowCount = (weakself.imageArray.count)/ColumnCount+1;
            weakself.pictCollectHeightCon.constant = rowCount *(PICTURECELL_WIDTH+Cell_MARAGIN);
            [weakself.pictureCollectionView reloadData];
        }];
        photoCtr.selectedArray = [NSArray arrayWithArray:self.imageArray];
        [self.navigationController pushViewController:photoCtr animated:YES];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    TXPhoto *photo = [[TXPhoto alloc]init];
    photo.thumbnailImage = (UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.imageArray addObject:photo];
    [self photoDidChange];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)dealloc{
    [TXNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
