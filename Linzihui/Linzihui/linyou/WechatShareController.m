//
//  WechatShareController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "WechatShareController.h"
#import "WXApi.h"

static NSString *title = @"邻子会";
NSString *description ;
static NSString *kLinkTagName = @"WECHAT_TAG_JUMP_SHOWRANK";

@interface WechatShareController ()
{
    UIImage *thumbImage;
    
}
@end

@implementation WechatShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *yaoqingma = [BmobUser getCurrentUser].objectId;
    
    description =  [NSString stringWithFormat:@"您的好友邀请您加入邻子会，社区邻妈互助众扶App,大量就近免费活动与奖励，邀请码为:%@,下载地址为:%@",yaoqingma,kAppDownloadURL];
    thumbImage = kDefaultHeadImage;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 0) {
        
        
        if (_shareType == 1) {
            
            [self shareWechatPengYouQuan];
        }
        else
        {
            [self shareQQZone];
            
        }
        
    }
    
    
    
    if (indexPath.row == 1) {
        
        if (_shareType == 1) {
            
            [self shareWechatHaoYou];
            
        }
        else
        {
            [self shareQQFriend];
            
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)shareWechatPengYouQuan
{
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = kAppDownloadURL;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = ext;
    
    message.mediaTagName = kLinkTagName;
    [message setThumbImage:thumbImage];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.scene = WXSceneTimeline;
    req.message = message;
    
    [WXApi sendReq:req];
    
    

    
}
-(void)shareWechatHaoYou
{
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = kAppDownloadURL;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = ext;
    
    message.mediaTagName = kLinkTagName;
    [message setThumbImage:thumbImage];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.scene = WXSceneSession;
    req.message = message;
    
    [WXApi sendReq:req];
}

-(void)shareQQZone
{
    
}

-(void)shareQQFriend
{
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
