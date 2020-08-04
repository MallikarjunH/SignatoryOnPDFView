//
//  ShareVC.h
//  emSigner
//
//  Created by Administrator on 11/18/16.
//  Copyright © 2016 Emudhra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingListVC.h"
@interface ShareVC : UIViewController<UITextViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *sharelable;
@property (weak, nonatomic) IBOutlet UILabel *pdfLable;
@property (weak, nonatomic) IBOutlet UITextView *mEmail;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *mCancel;
@property (weak, nonatomic) IBOutlet UISwitch *shareSwitch;
@property (weak, nonatomic) IBOutlet UIButton *mShare;
@property (weak, nonatomic) IBOutlet UITextView *MMessage;
@property (weak, nonatomic) NSMutableArray *shareArray;
@property (weak,nonatomic) NSString *documentName;
@property(nonatomic,assign) BOOL flag;
@property(nonatomic,strong) NSString *flagStr;
@property (nonatomic, strong) NSString *workflowID;
@property (nonatomic, strong) NSString *documentID;
@property (strong, nonatomic) NSString *pendingShare;
@property (strong, nonatomic) NSString *strExcutedFrom;
@property (strong, nonatomic) NSArray *DocumentType;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

- (IBAction)mShare:(id)sender;
- (IBAction)mCancel:(id)sender;
- (IBAction)shareSwitch:(id)sender;

@end