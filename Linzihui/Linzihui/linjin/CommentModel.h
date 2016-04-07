//
//  CommentModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/21.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"

@interface CommentModel : JSONModel

@property (nonatomic,strong) NSString *username;  //评论者 username
@property (nonatomic,strong) NSString *nick;      //评论者 nick
@property (nonatomic,strong) NSString *content;    //评论内容
@property (nonatomic,strong) NSString *headImageURL;   //评论者头像URL
@property (nonatomic,strong) NSString *replayToNick;   //回复谁
@property (nonatomic,strong) NSArray *imageURLs;  //评论图片
@property (nonatomic,strong) NSString *createdAt; //创建
@property (nonatomic,strong) NSString *updatedAt; //更新

@end
