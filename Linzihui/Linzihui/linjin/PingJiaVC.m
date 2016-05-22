//
//  PingJiaVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/7.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "PingJiaVC.h"
#import "ShangJiaCommentTVC.h"


@interface PingJiaVC ()<UIGestureRecognizerDelegate>
{
    UIControl *control;
    
    int  starNum;
    
    UIGestureRecognizer *_starGestureRecognizer;
    
    UITapGestureRecognizer *_tap;
    
    
}
@end

@implementation PingJiaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"评价";
    
    starNum = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    _starView.clipsToBounds = YES;

    _starView.layer.masksToBounds = YES;
    
    self.touchView = [[UIView alloc]initWithFrame:_startImageView.frame];
    
    self.touchView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.touchView];
    
    
    _starGestureRecognizer = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(change)];
    
    _starGestureRecognizer.delegate = self;
    
//    [self.touchView addGestureRecognizer:_starGestureRecognizer];
    
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(change)];
    
    _tap.delegate = self;
    
    
    [_touchView addGestureRecognizer:_tap];
    
  
    
    _starView.hidden = YES;
    
    
    
    

    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//      _starView.frame = CGRectMake(self.starView.frame.origin.x, self.starView.frame.origin.y, 0, 30);
    
    
}

-(void)change
{
    
}


#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
   
//    if (gestureRecognizer == _tap) {
//        
//        
//  
//    
//    CGPoint point = [touch locationInView:self.touchView];
//    
//    if (CGRectContainsPoint(self.touchView.frame, point)) {
//        
//        
//        starNum = fabs(((NSInteger)(point.x - self.starView.frame.origin.x)/30.0) +1);
//        
//        if (starNum > 5) {
//            
//            starNum = 5;
//            
//        }
//        
//        _starView.hidden = NO;
//        
//        _starView.clipsToBounds = YES;
//        
//        _starView.frame = CGRectMake(self.starView.frame.origin.x, self.starView.frame.origin.y, starNum*30, 30);
//        
//        NSLog(@"%.2f,y:%.2f,%ld",point.x,point.y,(long)starNum);
//        
//    }
//        
//     }
    
    return YES;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.touchView];
    
    if (CGRectContainsPoint(self.touchView.frame, point)) {
        
        
        starNum = fabs(((NSInteger)(point.x - self.startImageView.frame.origin.x)/30.0) +1);
        
        if (starNum > 5) {
            
            starNum = 5;
            
        }
    
  
        _startImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"star_rank_%d",starNum]];
            
        
      
 
        
        
    
        
        NSLog(@"%.2f,y:%.2f,%ld",point.x,point.y,(long)starNum);
        
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

   
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{


    
    
}


-(void)touchcontrol
{
    
}



- (IBAction)summit:(id)sender {
    
    
    [MyProgressHUD showProgress];
    
    NSString *commentStr = _commentTextView.text;
    
    if (commentStr.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写评论内容"];
        
        
        return;
    }
    
    BmobObject *ob = [BmobObject objectWithClassName:kShangJiaComment];
    
    [ob setObject:commentStr forKey:@"content"];
    
    [ob setObject:[BmobUser getCurrentUser] forKey:@"publisher"];
    
    [ob setObject:_shangjiausername forKey:@"shangjia_username"];
    
    [ob setObject:[NSNumber numberWithInt:starNum] forKey:@"star_num"];
    
    [ob saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       

        
        if (isSuccessful) {
            
            NSLog(@"comment success");
//            
//            [CommonMethods showDefaultErrorString:@"评价成功"];
            
            
            BmobQuery *commentQuery = [BmobQuery queryWithClassName:kShangJiaComment];
            
            [commentQuery whereKey:@"shangjia_username" equalTo:_shangjiausername];
            
            [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
               
                if (!error) {
                    
                    NSInteger num = array.count;
                    
                    NSInteger star_num = 5;
                    
                    NSInteger totalNum = 0;
                    
                    for (BmobObject *ob in array) {
                        
                        NSInteger temNum = [[ob objectForKey:@"star_num"]integerValue];
                        
                        totalNum +=temNum;
                        
                    }
                    
                    star_num = totalNum/num;
                    
                    
                    BmobQuery *qury = [BmobQuery queryWithClassName:kShangJia];
                    
                    [qury whereKey:@"username" equalTo:_shangjiausername];
                    
                    
                    [qury findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        
                                [MyProgressHUD dismiss];
                        
                        if (array.count > 0) {
                            
                            BmobObject *shangjiaOB = [array firstObject];
                            
                            [shangjiaOB setObject:[NSNumber numberWithInteger:star_num] forKey:@"star"];
                            
                            [shangjiaOB updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                               
                                if (isSuccessful) {
                                    
                                    ShangJiaModel *temModel = [[ShangJiaModel alloc]init];
                                    temModel.username = _model.username;
                                    
                                    ShangJiaCommentTVC *_commentTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShangJiaCommentTVC"];
                                    
                                    _commentTVC.model = temModel;
                                    
                                    [self.navigationController pushViewController:_commentTVC animated:YES];
                                    NSLog(@"update success");
                                    
//                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                    
                                }
                                
                            }];
                            
                            
                            
                        }
                        
                    }];
                }
                
            }];
            
      
            
            
            
        }
        
        else
        {
            NSLog(@"error:%@",error);
            
        }
        
    }];
    
    
    
    
    
    
    
}
@end
