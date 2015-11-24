//
//  MyPhotosViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/24.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "MyPhotosViewController.h"
#import "SDPhotoBrowser.h"

static NSString *CollectionCellID = @"CollectionCellID";

@interface MyPhotosViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDPhotoBrowserDelegate>
{

    NSMutableArray *_dataSource;
    
}
@end

@implementation MyPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册";
    
    
    _dataSource = [[NSMutableArray alloc]init];
    
    UICollectionViewFlowLayout *_layOut = [[UICollectionViewFlowLayout alloc]init];

    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.collectionViewLayout = _layOut;
    
    
  
    [self getPhotos];
    
    
}

-(void)getPhotos
{
    
    
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    
    BmobQuery *quryPhotos = [BmobQuery queryWithClassName:kShengHuoQuanTableName];
    
    
    [quryPhotos whereKey:@"publisher" equalTo:currentUser];
    
    
    [MyProgressHUD showProgress];
    
    
    [quryPhotos findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        
        [MyProgressHUD dismiss];
        
        if (!error && array.count > 0) {
            
            
            for (BmobObject  *ob in array)
            {
                
                ShengHuoModel *model = [[ShengHuoModel alloc]init];
                
                [BmobHelper setModelWithObject:ob model:model];
                
                
                NSArray *imageURLs = model.image_url;
                
                if (imageURLs.count > 0) {
                    
                    [_dataSource addObjectsFromArray:imageURLs];
                    
                }
                
                
                
                
                
            }
            
            
            [_myCollectionView reloadData];
            
            
            
        }
        
        else
        {
            NSLog(@"error:%@",error);
        }
        
    }];
    
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _dataSource.count;
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellID forIndexPath:indexPath];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        
        UIImageView *button = (UIImageView *)[ cell viewWithTag:100];
        
        NSString *imageURL = [_dataSource objectAtIndex:indexPath.row];
        
        NSLog(@"imageURL:%@",imageURL);
        
        [button sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:kDefaultLoadingImage];
        
        
        
        
        
    });
    
    return cell;
    
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    int fixSize = (int)ScreenWidth%4;
    
    int with = (int)ScreenWidth/4;
    
    if (indexPath.row%4 == 0) {
        
        return CGSizeMake(with + fixSize, with );
        
    }
    
    else
    {
        return CGSizeMake(with, with);
    }
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = cell; // 原图的父控件
    browser.imageCount = _dataSource.count; // 图片总数
    browser.currentImageIndex = indexPath.row;
    browser.delegate = self;
    [browser show];
    
      
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}



- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    return kDefaultLoadingImage;
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    return [NSURL URLWithString:[_dataSource objectAtIndex:index]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
