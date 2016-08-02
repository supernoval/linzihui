//
//  PulishTieZiTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/6/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "PulishTieZiTVC.h"
#import "QunBaTypeSelectedTVC.h"


@interface PulishTieZiTVC ()<UITextFieldDelegate,UITextViewDelegate,AddPhotoViewDelegate>
{
    NSArray *_photos;
    
    NSString *type;
    
    NSMutableArray  *_types;
    
    
    
}
@end

@implementation PulishTieZiTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"发表帖子";
    
    _addphotoView.delegate = self;
    _contentTV.delegate = self;
    
    [self requestQunBa];
    
    
}

-(void)requestQunBa
{
    BmobQuery *query = [BmobQuery queryWithClassName:kQunBa];
    
    [query whereKey:@"groupId" equalTo:_groupId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (array.count >0) {
            
            _types = [[NSMutableArray alloc]init];
            
            BmobObject *ob= [array firstObject];
            
            NSArray *types = [ob objectForKey:@"types"];
            
            for (int i = 0; i < types.count; i++) {
                
                NSString *typesting = [types objectAtIndex:i];
                
                NSDictionary *dict = @{@"selected":@(NO),@"text":typesting};
                
                [_types addObject:dict];
                
                
                
            }
            
//            [self setButtonsView];
            
            
            
            
        }
    }];
}

-(void)setButtonsView
{
    if (_types.count >0) {
        
        CGFloat buttonwith = 50;
        CGFloat buttonheight = 20;
        
        CGFloat originX = 10;
        
        int row = 0;
        
        for (int i = 0; i < _types.count; i++) {
            
            NSDictionary *dict = [_types objectAtIndex:i];
            
            BOOL selected = [[dict objectForKey:@"selected"]boolValue];
            NSString *str = [dict objectForKey:@"text"];
            
           buttonwith = [StringHeight heightWithText:str font:FONT_15 constrainedToWidth:20];
            
           
            
            UIButton *selectedButton = [[UIButton alloc]initWithFrame:CGRectMake(originX, 10, buttonwith, buttonheight * row +buttonheight)];
            selectedButton.tag = i;
            
            
            [selectedButton setTitle:str forState:UIControlStateNormal];
            
              [selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [selectedButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
            [selectedButton addTarget:self action:@selector(selectedtype:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if (selected) {
                
                selectedButton.backgroundColor = kOrangeTextColor;
                
            }
            else
            {
                selectedButton.backgroundColor = kBlueBackColor;
                
            }
            
            
            [_buttonsView addSubview:selectedButton];
            
            
            if (originX > ScreenWidth) {
                
                row ++;
                
                originX = 10;
                
                
            }
            
            originX += buttonwith + 10;
            
            
            
        }
        
        
        _heightConstant.constant =(row+1) * (buttonheight + 20);
        
        
        
    }
}


-(void)selectedtype:(UIButton*)sender
{
    
    for (int i = 0; i< _types.count; i++) {
        
        NSDictionary *dict = [_types objectAtIndex:i];
        
        NSMutableDictionary *mudict = [[NSMutableDictionary alloc]initWithDictionary:dict];
        
        if (i == sender.tag) {
            
            [mudict setObject:@(YES) forKey:@"selected"];
        }
        else
        {
            [mudict setObject:@(NO) forKey:@"selected"];
        }
        
        
        
        [_types replaceObjectAtIndex:i withObject:mudict];
    }

    
    [self setButtonsView];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _placelabel.hidden = YES;
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        _placelabel.hidden = NO;
        
        
    }
}
//只是用来隐藏键盘
-(void)showActionSheet
{
    [self.view endEditing:YES];
    
}


-(void)didChangePhotos:(NSArray*)photos
{
    _photos = photos;
    
}

- (IBAction)publish:(id)sender {
    
    
    if (_titleTF.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写帖子标题"];
        return;
    }
    
    if (_contentTV.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写帖子内容"];
        
        return;
    }
    
    if (_photos.count == 0) {
        
        [self saveData:nil];
        
        
    }
    else
    {
            [self uploadPhotos];
    }
    

    
    
    
    
}





- (IBAction)typeAction:(id)sender {
    
    
    
    QunBaTypeSelectedTVC *typeSelectTVC = [[QunBaTypeSelectedTVC alloc]initWithStyle:UITableViewStyleGrouped];
    
    typeSelectTVC.typesArray = _types;
    
    typeSelectTVC.selectedType = type;
    
    [typeSelectTVC setBlock:^(NSString *selectedType) {
       
        type = selectedType;
        
        _typeLabel.text = type;
        
        
    }];
    
    [self.navigationController pushViewController:typeSelectTVC animated:YES];
    
    
    
    
}




-(void)uploadPhotos
{
    [MyProgressHUD showProgress];
    
    
    [CommonMethods upLoadPhotos:_photos resultBlock:^(BOOL success, NSArray *results) {
       
        if (success) {
            
            [self saveData:results];
            
        }
        else
        {
             [MyProgressHUD dismiss];
        }
    }];
    
}

-(void)saveData:(NSArray*)photosURL
{
    
     [MyProgressHUD showProgress];
    for (int i = 0 ; i < _types.count; i++) {
        
        NSDictionary *dict = [_types objectAtIndex:i];
        
        BOOL selected = [[dict objectForKey:@"selected"]boolValue];
        
        if (selected) {
            
            type = [dict objectForKey:@"text"];
            
        }
    }
    BmobObject *OB = [BmobObject objectWithClassName:kTieZi];
    
    [OB setObject:_titleTF.text forKey:@"title"];
    
    [OB setObject:[BmobUser getCurrentUser] forKey:@"publisher"];
    
    
    
    if (type.length > 0) {
        
        [OB setObject:type forKey:@"type"];
        
        
    }
    
    
    [OB setObject:_contentTV.text forKey:@"content"];
    
    [OB setObject:_groupId forKey:@"groupId"];
    
    
    if (photosURL) {
        
            [OB setObject:photosURL forKey:@"photos"];
    }

    
    CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
    CGFloat longitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];

    BmobGeoPoint  *point = [[BmobGeoPoint alloc]init];
    point.latitude = latitude;
    point.longitude = longitude;
    
    [OB setObject:point forKey:@"location"];
    
    
    [OB saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        if (isSuccessful) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
    }];
    
}
@end
