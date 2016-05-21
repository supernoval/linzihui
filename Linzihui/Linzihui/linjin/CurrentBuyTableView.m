//
//  CurrentBuyTableView.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/21.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "CurrentBuyTableView.h"
#import "BuyHistoryCell.h"
#import "BuyShangPinModel.h"


@interface CurrentBuyTableView ()
{
    NSMutableArray *_muHistoryArray;
    
}

@end

@implementation CurrentBuyTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最近成交";
    
    _muHistoryArray = [[NSMutableArray alloc]init];
    
    
    [self getCurrentBuy];
    
}


#pragma mark - 获取最近成交
-(void)getCurrentBuy
{
    
    BmobObject *sellOb = [BmobObject objectWithoutDatatWithClassName:kShangJia objectId:_model.objectId];
    
    BmobQuery *queryhist = [BmobQuery queryWithClassName:kBuyShangPin];
    
    [queryhist whereKey:@"shangjia" equalTo:sellOb];
    [queryhist includeKey:@"address"];
    [queryhist whereKey:@"status" greaterThan:[NSNumber numberWithInt:1]];
    
    
    [queryhist findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count > 0) {
            
            for (int i = 0; i< array.count; i++) {
                
                BmobObject *ob = [array objectAtIndex:i];
                
                BuyShangPinModel *model = [[BuyShangPinModel alloc]init];
                
                [model setValuesForKeysWithDictionary:[ob valueForKey:kBmobDataDic]];
                
                model.createdAt = ob.createdAt;
                
                [_muHistoryArray addObject:model];
                
                
                
            }
            
            [self.tableView reloadData];
            
            
        }
        
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _muHistoryArray.count;
    
}

#pragma mark - UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    

    BuyHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"BuyHistoryCell"];

    if (indexPath.row < _muHistoryArray.count) {
    
        BuyShangPinModel *model = [_muHistoryArray objectAtIndex:indexPath.row];
    
        historyCell.timeLabel.text = [CommonMethods getYYYYMMddHHmmssDateStr:model.createdAt];
        historyCell.shangpinnamelabel.text = model.shangpinName;
//        historyCell.addresslabel.text = [model.address objectForKey:@"address"];
        historyCell.priceLabel.text = [NSString stringWithFormat:@"%.2f元",model.price];
    
    
    
        }
    
    historyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return historyCell;
    
}



@end
