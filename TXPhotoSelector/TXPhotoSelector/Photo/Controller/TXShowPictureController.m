//
//  TXShowPictureController.m
//  TXPhotoSelector
//
//  Created by 秦田新 on 2017/6/9.
//  Copyright © 2017年 秦田新. All rights reserved.
//

#import "TXShowPictureController.h"
#import "TXConst.h"
#import "TXPhoto.h"

@interface TXShowPictureController ()

@property(nonatomic,weak)UIScrollView *scrollView;

@end

@implementation TXShowPictureController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.navBarHidden animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.deleButtonHidden == NO) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonClicked)];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatscrollAndImageViews];
}

-(void)creatscrollAndImageViews{
    self.title = [NSString stringWithFormat:@"%zd/%zd",_currentIndex+1,self.photoArray.count];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, g_screenWidth, g_screenHeight)];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.contentSize = CGSizeMake(self.photoArray.count*g_screenWidth, g_screenHeight);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    for (NSInteger i = 0; i< self.photoArray.count; i++) {
        TXPhoto *photo = self.photoArray[i];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(i*g_screenWidth, 0, g_screenWidth, g_screenHeight);
        imageView.image = photo.thumbnailImage;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap)]];
        [scrollView addSubview:imageView];
    }
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    if (_currentIndex>0) {
        [self.scrollView setContentOffset:CGPointMake(_currentIndex * g_screenWidth, 0) animated:YES];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _currentIndex = self.scrollView.contentOffset.x/g_screenWidth;
    self.title = [NSString stringWithFormat:@"%zd/%zd",_currentIndex + 1,self.photoArray.count];
}

-(void)imageViewTap{
    if (self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

-(void)deleteButtonClicked{
    [self.scrollView removeFromSuperview];
    [self.photoArray removeObjectAtIndex:_currentIndex];
    if (_currentIndex>=self.photoArray.count) {
        _currentIndex = _currentIndex - 1;
    }
    [self creatscrollAndImageViews];
    [TXNotificationCenter postNotificationName:TXPhotoDeleteNotification object:nil];
    if (self.photoArray.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
