//
//  CustomSignVC.m
//  emSigner
//
//  Created by Administrator on 7/27/16.
//  Copyright © 2016 Emudhra. All rights reserved.
//

#import "CustomSignVC.h"
#import "WebserviceManager.h"
#import "HoursConstants.h"
#import "MBProgressHUD.h"
#import "NSObject+Activity.h"
#import "LMNavigationController.h"


@interface CustomSignVC ()

@end

@implementation CustomSignVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _otpText.layer.borderColor=([UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor);
    _otpText.layer.borderWidth= 0.5f;
    
    //
    _customView.layer.cornerRadius = 10;
    _customView.layer.masksToBounds = YES;

    //
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = _imageView.bounds;
    [_imageView addSubview:visualEffectView];

    
    /*****************************Card View*********************************/
    
    [self.customView setAlpha:1];
    self.customView.layer.masksToBounds = NO;
    self.customView.layer.cornerRadius = 5; // if you like rounded corners
    self.customView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f); //%%% this shadow will hang slightly down and to the right
    self.customView.layer.shadowRadius = 25; //%%% I prefer thinner, subtler shadows, but you can play with this
    self.customView.layer.shadowOpacity = 0.5;
    //
    
    
    //
    //LeftBorderBtn1
    // at the top of the file with this code, include:
    
    
    CGRect rect = _customCancelBtn.frame;
    
    UIBezierPath * linePath = [UIBezierPath bezierPath];
    
    // start at top left corner
    [linePath moveToPoint:CGPointMake(0,0)];
    // draw left vertical side
    [linePath addLineToPoint:CGPointMake(0, rect.size.height)];
    
    // create a layer that uses your defined path
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 0.3;
    lineLayer.strokeColor = ([UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor);
    
    lineLayer.fillColor = nil;
    lineLayer.path = linePath.CGPath;
    
    [_customCancelBtn.layer addSublayer:lineLayer];
    
    //Top Border
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _customCancelBtn.frame.size.width, 0.3f);
    TopBorder.backgroundColor = ([UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor);
    [_customCancelBtn.layer addSublayer:TopBorder];
    //
    
    //Top Border
    CALayer *TopBorder1 = [CALayer layer];
    TopBorder1.frame = CGRectMake(0.0f, 0.0f, _customSignBtn.frame.size.width, 0.3f);
    TopBorder1.backgroundColor = ([UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor);
    [_customSignBtn.layer addSublayer:TopBorder1];
    //

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)customSignBtn:(id)sender
{
    
    //Check blank String OTP
    NSString *rawString = [self.otpText text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([trimmed length] == 0)
    {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please Enter OTP"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        
                                    }];
        
        
        //Add your buttons to alert controller
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    
    
    if (_otpText.text.length<6) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please Enter Valid 6 Digit OTP"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        
                                    }];
        
        
        //Add your buttons to alert controller
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
   
    NSString *PendingWorkflowID = [[NSUserDefaults standardUserDefaults]
                                   valueForKey:@"PendingWorkflowID"];
    /*************************Web Service Get OTP*******************************/
    
    [self startActivity:@"Signing..."];
    
    NSString *post = [NSString stringWithFormat:@"AdhaarNumber=%@&OTP=%@&WorkFlowId=%@",_aadhaarString,_otpText.text,PendingWorkflowID];
    [WebserviceManager sendSyncRequestWithURL:keSign method:SAServiceReqestHTTPMethodPOST body:post completionBlock:^(BOOL status, id responseValue)
     {
         
      //   if(status)
        if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])

         {
             dispatch_async(dispatch_get_main_queue(),
                            ^{
                                _signArray =[responseValue valueForKey:@"IsSuccess"];
                                NSNumber * isSuccessNumber = (NSNumber *)_signArray;
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
                                                                    
                                                                    
                                                                    /**********************************************************/
                                                                    UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                    LMNavigationController *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"HomeNavController"];
                                                                    [self presentViewController:objTrackOrderVC animated:YES completion:nil];
                                                                    
                                                                    
                                                                }];
                                    
                                    //Add your buttons to alert controller
                                    
                                    [alert addAction:yesButton];
                                    [self presentViewController:alert animated:YES completion:nil];
                                    
                                    
                                    
                                    //
                                    [self stopActivity];
                                }
                                else{
                                    
                                     if ([[[responseValue valueForKey:@"Messages"] objectAtIndex:0]isEqualToString:@"Your esign limit is exceeded.Please contact your administrator to use this feature."])
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
                                        
                                        [alert addAction:yesButton];
                                        
                                        [self presentViewController:alert animated:YES completion:nil];
                                        
                                        [self stopActivity];

                                    }
                                    else{
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
                                                                      
                                                                                                                    }];
                                        
                                        //Add your buttons to alert controller
                                        
                                        [alert addAction:yesButton];
                                        //[alert addAction:noButton];
                                        
                                        [self presentViewController:alert animated:YES completion:nil];
                                        
                                        [self stopActivity];
                                        
                                    }
                                   
                                }
                                
                                
                            });
         }
         else{
             
         }
         
     }];
    

    

}

- (IBAction)customCancelBtn:(id)sender
{
    UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LMNavigationController *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"HomeNavController"];
    [self presentViewController:objTrackOrderVC animated:YES completion:nil];
}


- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                   withString:string];
    return resultText.length <= 6;
}


- (IBAction)resendOTPBtn:(id)sender
{
    //SavedAadhaarNumber
    _otpText.text = nil;
    [self startActivity:@"Processing..."];
    NSString *requestURL = [NSString stringWithFormat:@"%@GetOTP?AadhaarNumber=%@",kGetOTP,_aadhaarString];
    
    [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
        
        //if(status)
        if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])

        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               NSNumber * isSuccessNumber = (NSNumber *)[responseValue valueForKey:@"IsSuccess"];
                               if([isSuccessNumber boolValue] == YES)
                               {
                                   _otpArray = responseValue;
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

                                                               }];
                                   
                                   //Add your buttons to alert controller
                                   
                                   [alert addAction:yesButton];
                                  
                                   [self presentViewController:alert animated:YES completion:nil];

                                   [self stopActivity];
                               }
                               else{
                                   UIAlertController * alert = [UIAlertController
                                                                alertControllerWithTitle:@""
                                                                message:[[responseValue valueForKey:@"Messages"] objectAtIndex:0]
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                   
                                   UIAlertAction* yesButton = [UIAlertAction
                                                               actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   //Handle your yes please button action here
                                                                   if ([[[responseValue valueForKey:@"Messages"] objectAtIndex:0] isEqualToString:@"Please enter valid Aadhaar number"]) {
                                                                       UIStoryboard *newStoryBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                       LMNavigationController *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"HomeNavController"];
                                                                       [self presentViewController:objTrackOrderVC animated:YES completion:nil];
                                                                   }
                                                               }];
                                   
                                   //Add your buttons to alert controller
                                   
                                   [alert addAction:yesButton];
                                   
                                   [self presentViewController:alert animated:YES completion:nil];
                                   
                                   [self stopActivity];


                               }
                               
                               
                           });
            
        }
        else
        {
            NSError *error = (NSError *)responseValue;
            if (error) {
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Info"
                                             message:@"Error from KSA Server"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                //Add Buttons
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                //Handle your yes please button action here
                                                
                                            }];
                
                
                //Add your buttons to alert controller
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                [self stopActivity];
                return;
            }
            
            
        }
        [self stopActivity];
    }];
 
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