//
//  MineTableViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/2.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "MineTableViewController.h"
#import "CommonMethods.h"

@interface MineTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@end

@implementation MineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}




#pragma mark -  UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    
    footerView.backgroundColor = [UIColor clearColor];
    
    return footerView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
        {
            return 5;
        }
            break;
        case 1:
        {
            
            return 3;
        }
            
            break;
            
            
        default:
            break;
    }
    
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    


}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadPhotoCell"];
        
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentLabelCell"];
        
        
        return cell;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:  //修改头像
            {
                UIActionSheet *_pickActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                _pickActionSheet.delegate = self;
                
                [_pickActionSheet addButtonWithTitle:@"相册"];
                [_pickActionSheet addButtonWithTitle:@"照相"];
                
                [_pickActionSheet addButtonWithTitle:@"取消"];
                
                _pickActionSheet.cancelButtonIndex = 2;
                
                _pickActionSheet.tag = 99;
                
                [_pickActionSheet showInView:self.view];
            }
                break;
                
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    
    UIImage *editImage          = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    UIImage *cutImage           = [self cutImage:editImage size:CGSizeMake(160, 160)];
    UIImage *cutImage  = [CommonMethods imageWithImage:editImage scaledToSize:CGSizeMake(300, 300)];
    
    
    [CommonMethods upLoadPhotos:@[cutImage] resultBlock:^(BOOL success, NSArray *results) {
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma  mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 99) {
        
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerController *_picker = [[UIImagePickerController alloc]init];
                _picker.editing = NO;
                _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                _picker.delegate = self;
                
                [self presentViewController:_picker animated:YES completion:nil];
                
            }
                break;
            case 1:
            {
                UIImagePickerController *_picker = [[UIImagePickerController alloc]init];
                _picker.editing = NO;
                _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                _picker.delegate = self;
                
                [self presentViewController:_picker animated:YES completion:nil];
            }
                break;
                
                
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
