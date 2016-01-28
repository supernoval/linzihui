//
//  TongXunLuTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"
#import <AddressBook/AddressBook.h>
#import <ContactsUI/ContactsUI.h>
#import <MessageUI/MessageUI.h>
#import "ConstantsHeaders.h"


@interface TongXunLuTVC : UITableViewController<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UISearchDisplayDelegate,UISearchBarDelegate>

@property (nonatomic) BOOL isFromNewFriend;

@end
