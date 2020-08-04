//
//  InprogressMultiplePdf.h
//  emSigner
//
//  Created by Administrator on 6/1/17.
//  Copyright © 2017 Emudhra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiplePdfTableViewCell.h"
#import <PDFKit/PDFKit.h>

@protocol PreviousViewcontrollerDelegate<NSObject>
@required
-(void)dataFromControllerOne:(NSString *)data;
-(void)documentnameControllerOne:(NSString *)dname;
-(void)dataForWorkflowId:(NSString *)dWorkflowid;
-(void)selectedCellIndexOne:(int)iIndex;
@end

@interface InprogressMultiplePdf : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<PreviousViewcontrollerDelegate> delegate;
@property (strong, nonatomic) PDFDocument *pdfDocument;

@property (strong,nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) NSString *workFlowId;
@property (strong,nonatomic) NSString *workFlowType;
@property (strong,nonatomic) NSString *document;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) int currentSelectedRow;
@property (strong, nonatomic) NSString *strExcutedFrom;

@property (nonatomic, strong) NSMutableDictionary *documentInfoArray;

@end