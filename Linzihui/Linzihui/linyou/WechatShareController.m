//
//  WechatShareController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "WechatShareController.h"
#import "WXApi.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import <TencentOpenAPI/TencentOAuth.h>




static NSString *title = @"邻子会";
NSString *description ;
static NSString *kLinkTagName = @"WECHAT_TAG_JUMP_SHOWRANK";

@interface WechatShareController ()<TencentSessionDelegate>
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
    
  TencentOAuth *_tencentOAuth =  [[TencentOAuth alloc]initWithAppId:kQQAppID andDelegate:self];
    
    if (_shareType == 2) {
        
        _firstImageView.image = [UIImage imageNamed:@"qqzone"];
        _firstTitlelabel.text = @"分享到QQ空间";
        
        _secImageView.image = [UIImage imageNamed:@"qqIcon"];
        _secTitleLabel.text = @"分享给QQ好友";
    }
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
 
    
      QQApiNewsObject *_newsInfo = [QQApiNewsObject objectWithURL:[NSURL URLWithString:kAppDownloadURL] title:@"邻子会" description:description previewImageData:UIImagePNGRepresentation(kDefaultHeadImage)];
    [_newsInfo setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:_newsInfo];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    [self handleSendResult:sent];
}

-(void)shareQQFriend
{
    QQApiNewsObject *_newsInfo = [QQApiNewsObject objectWithURL:[NSURL URLWithString:kAppDownloadURL] title:@"邻子会" description:description previewImageData:UIImagePNGRepresentation(kDefaultHeadImage)];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:_newsInfo];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    [self handleSendResult:sent];
    
    
}
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
      
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
          
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
   
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
           
            
            break;
        }
        default:
        {
            break;
        }
    }
}


#pragma mark -TencentSessionDelegate
-(void)tencentDidLogin
{
    
}
- (void)tencentDidNotNetWork
{
    
}
- (void)tencentDidLogout
{
    
}
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

-(void)tencentOAuth:(TencentOAuth *)tencentOAuth didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite userData:(id)userData
{
    
}

-(void)tencentOAuth:(TencentOAuth *)tencentOAuth doCloseViewController:(UIViewController *)viewController
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
