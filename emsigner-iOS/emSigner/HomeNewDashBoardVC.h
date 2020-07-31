//
//  HomeNewDashBoardVC.h
//  emSigner
//
//  Created by Administrator on 1/11/17.
//  Copyright © 2017 Emudhra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PendingVC.h"
#import "CoSignPendingVC.h"
#import "RecallStatusVC.h"
#import "DeclineStatusVC.h"
#import "CompleteStatusVC.h"
#import "ShareVC.h"
#import "CoSignPendingListVC.h"
#import "CaptureSignatureView.h"
#import "SingletonAPI.h"
#import <QuickLook/QuickLook.h>
#import "DocumentInfoVC.h"
#import "CustomPopOverVC.h"
#import <PDFKit/PDFKit.h>

static NSString *const kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";
@interface HomeNewDashBoardVC : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate,UITextViewDelegate,CaptureSignatureViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,QLPreviewControllerDelegate,QLPreviewControllerDataSource,UITextFieldDelegate>
{
    NSArray *filenamesArray;
    int currentPreviewIndex;
}
@property (strong,nonatomic)UITextField *aadhaarNumber;
@property (strong,nonatomic)UITextField *otp;
@property (weak, nonatomic) IBOutlet UISearchBar *mySignatureSearchBar;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *pendingTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *pendingSearchBar;
@property (weak, nonatomic) IBOutlet UIToolbar *pendingToolBar;
@property (weak, nonatomic) IBOutlet UIImageView *signatureImageView;
@property (weak, nonatomic) IBOutlet UIView *declineView;

@property (weak, nonatomic) IBOutlet UIButton *declineBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *documentLogBtn;
@property (weak, nonatomic) IBOutlet UIButton *recallBtn;
@property(nonatomic,strong) NSString *_pathForDoc;
@property (nonatomic, strong) NSString *myTitle;
@property(assign) BOOL isAdmin;
@property (strong, nonatomic) PDFDocument *pdfDocument;

@property (assign,nonatomic) BOOL isPasswordProtected;
@property (strong, nonatomic) NSMutableArray *checkNullArray;
@property (strong,nonatomic) NSString *documentName;
@property (strong,nonatomic) NSString *pdfFileName;
@property (strong,nonatomic) NSString *pdfFiledata;
@property (strong,nonatomic) NSArray *pendingArray;
@property (strong,nonatomic) NSMutableArray *docInfoArray;
@property (strong,nonatomic) NSMutableArray *pdfImageArray;
@property (strong,nonatomic) NSMutableArray *pdfImageArraySwipe;
@property (strong,nonatomic) NSMutableArray *docPaasCheckArray;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *filterSecondArray;
@property (nonatomic, strong) NSMutableArray *declineArray;
@property (nonatomic, strong) NSMutableArray *recallArray;
@property (nonatomic, strong) NSMutableArray *downloadArray;
@property (strong, nonatomic) NSArray *otpArray;
@property (strong, nonatomic) NSArray *signArray;
@property (strong, nonatomic) NSArray *pdfDetail;
@property (strong, nonatomic) NSArray *shareArray;
@property (strong, nonatomic) NSString *mySignatureWorkflowID;
@property (strong, nonatomic) NSArray *downloadPDFArray;
@property (strong, nonatomic) NSMutableArray *profileArray;
@property (assign, nonatomic) NSUInteger totalRow;
@property (nonatomic, assign) int currentSelectedRow;
@property (nonatomic,assign) NSString *workflowId;
@property (nonatomic,assign) NSString *pdfFileNameDwn;
@property(nonatomic,strong) NSMutableArray *addFile;
@property (strong,nonatomic) NSString *pdfName;
@property (strong,nonatomic) NSString *filePath;
@property (strong,nonatomic)   NSString *path ;
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSUInteger currentPage;
@property(strong,nonatomic) NSMutableDictionary *signPadDict;

- (IBAction)cancelBtn:(id)sender;
- (IBAction)declineBtn:(id)sender;
- (IBAction)downloadBtn:(id)sender;
- (IBAction)shareBtn:(id)sender;
- (IBAction)recallBtn:(id)sender;

-(void)getWorkflowsForPush:(NSDictionary*)userInfo;


@end
