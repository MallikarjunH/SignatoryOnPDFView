//
//  RecallVC.m
//  emSigner
//
//  Created by Administrator on 8/23/16.
//  Copyright © 2016 Emudhra. All rights reserved.
//

#import "RecallVC.h"
#import "WebserviceManager.h"
#import "HoursConstants.h"
#import "NSObject+Activity.h"
#import "MBProgressHUD.h"
#import "LMNavigationController.h"
#import "UITextView+Placeholder.h"
#import "HomeNewDashBoardVC.h"
#import "PendingVC.h"

@interface RecallVC ()

@end

@implementation RecallVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customView.layer.cornerRadius = 10;
    self.remarkText.layer.cornerRadius = 10;
    self.mCancelBtn.layer.cornerRadius = 10;
    self.mOkBtn.layer.cornerRadius = 10;
    _mOkBtn.enabled = NO;
    self.customView.hidden = false;

    [_mOkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.view.bounds;
    [_imageView addSubview:visualEffectView];
    
    /*****************************Card View*********************************/
    
    [self.customView setAlpha:1];
    self.customView.layer.masksToBounds = NO;
    self.customView.layer.cornerRadius = 10;
    self.customView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.customView.layer.shadowRadius = 25;
    self.customView.layer.shadowOpacity = 0.5;
    
    _remarkText.layer.borderWidth = 0.1;
    _remarkText.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0].CGColor;
    _remarkText.delegate = self;
    _remarkText.placeholder = @"Remarks";
    _remarkText.textColor = [UIColor blackColor];
    
    //LeftBorderBtn1
    CGRect rect = _mCancelBtn.frame;
    
    UIBezierPath * linePath = [UIBezierPath bezierPath];
    
    // start at top left corner
    [linePath moveToPoint:CGPointMake(0,0)];
    // draw left vertical side
    [linePath addLineToPoint:CGPointMake(0, rect.size.height)];
    
    // create a layer that uses your defined path
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 1.0;
    lineLayer.strokeColor = ([UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor);
    
    lineLayer.fillColor = nil;
    lineLayer.path = linePath.CGPath;
    
    [_mCancelBtn.layer addSublayer:lineLayer];
    
    //Top Border
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _mCancelBtn.frame.size.width, 1.0f);
    TopBorder.backgroundColor = ([UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor);
    [_mCancelBtn.layer addSublayer:TopBorder];
    
    //Top Border
    CALayer *TopBorder1 = [CALayer layer];
    TopBorder1.frame = CGRectMake(0.0f, 0.0f, _mOkBtn.frame.size.width, 1.0f);
    TopBorder1.backgroundColor = ([UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor);
    [_mOkBtn.layer addSublayer:TopBorder1];
    
    _remarkText.placeholder = @"Remarks";
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)mCancelBtn:(id)sender
{
   [self dismissViewControllerAnimated:YES completion:Nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger length = _remarkText.text.length - range.length + text.length;
    if([text isEqualToString:@"\n"])
    {
        return NO;
    }
    else
    {
        if (range.location == 0 && ([text isEqualToString:@" "]))
        {
            return NO;
        }
        if (length > 0 && [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound) {
            _mOkBtn.enabled = YES;
            [_mOkBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            _mOkBtn.enabled = NO;
            [_mOkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        
    }
    
    return YES;
}

- (BOOL) validateSpecialCharactor: (NSString *) text {
//    NSString *Regex = @"[A-Za-z0-9^]*";
//    NSPredicate *TestResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
//    return [TestResult evaluateWithObject:text];
    NSString *specialCharacterString = @"!~`@#$%^&*-+();:={}[],<>?\\/\"\'";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet
                                           characterSetWithCharactersInString:specialCharacterString];
    
    if ([text.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length) {
        NSLog(@"contains special characters");
        return  false;
    }
    else{
        return true;
    }
}


- (IBAction)mOKBtn:(id)sender
{
    NSString *isValid = self.remarkText.text;
    BOOL valid = [self validateSpecialCharactor:isValid];
    
    if (valid){
        [self recallApi];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Special Characters are not allowed.";//[NSString stringWithFormat:@"Page %@ of %lu", self.view.currentPage.label, (unsigned long)self.pdfDocument.pageCount];
        hud.margin = 10.f;
        hud.yOffset = 170;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:2];
    }
    
}


-(void)recallApi{
    [self startActivity:@"Processing..."];
    NSString *post = [NSString stringWithFormat:@"WorkflowId=%@&Remarks=%@",_workflowID,[self.remarkText text]];
    [WebserviceManager sendSyncRequestWithURL:kRecall method:SAServiceReqestHTTPMethodPOST body:post completionBlock:^(BOOL status, id responseValue)
     {
         
         // if(status)
         if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
             
         {
             dispatch_async(dispatch_get_main_queue(),
                            ^{
                                
                                _recallArray = responseValue;
                                if (_recallArray != (id)[NSNull null])
                                {
                                    
                                    NSNumber * isSuccessNumber = (NSNumber *)[responseValue valueForKey:@"IsSuccess"];
                                    if([isSuccessNumber boolValue] == YES)
                                    {
                                        
                                        UIAlertController * alert = [UIAlertController
                                                                     alertControllerWithTitle:@""
                                                                     message:[[responseValue valueForKey:@"Messages"] objectAtIndex:0]
                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        //Add Buttons
                                        
                                        UIAlertAction* yesButton = [UIAlertAction
                                                                    actionWithTitle:@"Ok"
                                                                    style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * action) {
                                                                        //Handle your yes please button action here
                                                                        
                                                                        
                                                                        UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                        
                                                                        LMNavigationController *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"HomeNavController"];
                                                                        [self presentViewController:objTrackOrderVC animated:YES completion:nil];
                                                                        
                                                                    }];
                                        
                                        
                                        //Add your buttons to alert controller
                                        self.customView.hidden = true;
                                        [alert addAction:yesButton];
                                        //[alert addAction:noButton];
                                        
                                        [self presentViewController:alert animated:YES completion:nil];
                                        [self stopActivity];
                                        
                                    }
                                    
                                }
                                else{
                                    return ;
                                }
                            });
         }
         else{
         }
     }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self customView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end