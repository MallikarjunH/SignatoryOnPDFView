//
//  DeclineStatusVC.h
//  emSigner
//
//  Created by Administrator on 11/15/16.
//  Copyright © 2016 Emudhra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeclineTableViewCell.h"
#import "DeclineNextVC.h"
@interface DeclineStatusVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarItem;

@property (nonatomic,strong) NSMutableArray *filterArray;
@property (nonatomic,strong) NSMutableArray *filterSecArrayDeclined;

@property (nonatomic,strong) NSMutableArray *docInfoArray;

@property (nonatomic,strong) NSMutableArray *declineArray;
@property (nonatomic, strong) NSMutableArray *pdfImageArray;
@property (assign, nonatomic) NSUInteger currentPage;
@property (assign, nonatomic) NSUInteger totalRow;

@end
