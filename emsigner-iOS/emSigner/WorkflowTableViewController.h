//
//  WorkflowTableViewController.h
//  emSigner
//
//  Created by eMudhra on 08/10/18.
//  Copyright © 2018 Emudhra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkflowTableViewController : UIViewController<UITabBarDelegate,UISearchBarDelegate>

    @property (nonatomic, retain) NSArray *arrayOriginal;
    @property (nonatomic, retain) NSMutableArray *arForTable;
    @property (strong) NSArray *responseArray;
    @property (strong,nonatomic) NSMutableArray *subarray;
    @property (strong,nonatomic) NSMutableArray *mainarray;
@property (strong,nonatomic) NSMutableArray *childArray;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (strong,nonatomic)NSString *workFlowId;
    @property (strong, nonatomic) IBOutlet UITableView *workflowsTable;

    -(void)miniMizeThisRows:(NSArray*)ar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchWorkflows;



@end
