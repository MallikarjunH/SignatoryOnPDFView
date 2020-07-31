//
//  RecallStatusVC.h
//  emSigner
//
//  Created by Administrator on 11/15/16.
//  Copyright © 2016 Emudhra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecallTableViewCell.h"
#import "RecallDeclineVC.h"
@interface RecallStatusVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) NSMutableArray *filterArray;
@property (nonatomic,strong) NSMutableArray *filterSecArray;
@property (nonatomic,strong) NSMutableArray *recalledArray;
@property (nonatomic,strong) NSMutableArray *pdfImageArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarItem;
@property (assign, nonatomic) NSUInteger currentPage;
@property (assign, nonatomic) NSUInteger totalRow;

@property (nonatomic,strong) NSMutableArray *docInfoArray;

@end
