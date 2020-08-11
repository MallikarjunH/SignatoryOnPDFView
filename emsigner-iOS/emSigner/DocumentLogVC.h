//
//  DocumentLogVC.h
//  emSigner
//
//  Created by Administrator on 8/2/16.
//  Copyright © 2016 Emudhra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDocumentLogTableViewCell.h"
#import "DocumentLogTableViewCell.h"

@interface DocumentLogVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    
}
@property (nonatomic) NSDictionary *documentNamesDic;
@property (nonatomic, strong) NSString *workflowID;
@property (nonatomic, strong) NSString *documentName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *docArray;

@property (weak, nonatomic) IBOutlet UILabel *documentNameLabel;

- (IBAction)backBtn:(id)sender;

@end
