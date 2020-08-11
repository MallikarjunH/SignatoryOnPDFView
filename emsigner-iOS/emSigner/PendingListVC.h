//
//  PendingListVC.h
//  emSigner
//
//  Created by Administrator on 12/2/16.
//  Copyright © 2016 Emudhra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ShareVC.h"
#import "DocumentLogVC.h"
#import "GetOTPVC.h"
#import "DeclineVC.h"
#import "CaptureSignatureView.h"
#import "SingletonAPI.h"
#import <QuickLook/QuickLook.h>
#import "MultiplePdfViewerVC.h"
#import "AttachedVC.h"
#import "CustomPopOverVC.h"
#import "CustomSignVC.h"

#import "SPUserResizableView.h"
#import "MPBCustomStyleSignatureViewController.h"
#import <PDFKit/PDFKit.h>

@interface PendingListVC : UIViewController<CaptureSignatureViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UITextFieldDelegate,UIWebViewDelegate,SecondViewControllerDelegate,UINavigationControllerDelegate,SecondViewControllerDelegate,UIPopoverPresentationControllerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate, SPUserResizableViewDelegate,UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *signatorylbl;
@property (weak, nonatomic) IBOutlet UILabel *pgNumberLbl;

//@property (weak, nonatomic) IBOutlet UIView *pdfView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *declineView;
@property(nonatomic,strong) NSMutableArray *addFile;
@property (weak, nonatomic) IBOutlet UIImageView *signatureImageView;
//@property (weak,nonatomic)  UIButton *customButton;

@property (nonatomic, strong) NSString *myTitle;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) BOOL isPasswordProtected;
@property (nonatomic, assign) BOOL isSignatory;
@property (nonatomic, assign) BOOL isReviewer;
@property(assign)  BOOL isAdmin;
//pendingvc

@property (nonatomic,strong) NSString *pendingvc;
@property(nonatomic,strong) NSDictionary *aps;

@property (nonatomic,strong) NSString *signatoryString;

@property (strong, nonatomic) NSString *strExcutedFrom;
@property (strong, nonatomic) NSString *pdfImagedetail;
@property (strong, nonatomic) NSString *multiplePdfImagedetail;
@property (strong, nonatomic) NSArray *detailArray;
@property (strong, nonatomic) NSArray *otpArray;
@property (strong, nonatomic) NSArray *signArray;
@property (strong, nonatomic) NSArray *declineArray;
@property (strong, nonatomic) NSArray *shareArray;
@property (strong,nonatomic) NSMutableArray *pdfImageArray;
@property (strong, nonatomic) NSString *workFlowID;
@property (assign, nonatomic) NSString *documentID;
@property (strong,nonatomic) NSString *documentCount;
@property (strong,nonatomic) NSString *attachmentCount;
@property (strong,nonatomic) NSString *pdfFileName;
@property (strong,nonatomic) NSString *pdfFiledata;
@property (nonatomic, strong) UIPopoverPresentationController *popover;
@property(nonatomic, readonly) BOOL hasOnlySecureContent;
@property (strong,nonatomic) NSArray *signatoryHolderArray;
@property(assign)BOOL isDocStore;
//@property (strong,nonatomic) NSArray *signatoryHolderArray;
@property (strong,nonatomic) NSArray *placeholderArray;

@property (nonatomic, assign) const char *passwordForPDF;


@property(strong,nonatomic)UIImage *signatureImage;

//@property ( strong,nonatomic) NSInteger* statusId;
@property (assign,nonatomic) NSInteger* statusId;

@property (strong,nonatomic) NSString *workFlowType;

@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet UIView *customViewForSiri;


//- (IBAction)signBtn:(id)sender;
//- (IBAction)shareBtn:(id)sender;
- (IBAction)SignBtnClicked:(id)sender;
- (IBAction)declineBtnClicked:(id)sender;
- (IBAction)moreBtnClicked:(id)sender;

- (void)preparePDFViewWithPageMode:(PDFDisplayMode) displayMode;
- (void)showPopForSign;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIButton *Sign;

//pdf kit
//@property (strong, nonatomic) PDFView *MainpdfView;
@property (strong, nonatomic) PDFDocument *pdfDocument;

@property (weak, nonatomic) IBOutlet UIButton *micButtonOutlet;




@end
