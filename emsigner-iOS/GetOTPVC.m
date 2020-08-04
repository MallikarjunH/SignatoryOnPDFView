//
//  GetOTPVC.m
//  emSigner
//
//  Created by Administrator on 11/22/16.
//  Copyright © 2016 Emudhra. All rights reserved.
//

#import "GetOTPVC.h"
#import "WebserviceManager.h"
#import "HoursConstants.h"
#import "MBProgressHUD.h"
#import "NSObject+Activity.h"
#import "CustomSignVC.h"
#import "LMNavigationController.h"

@interface GetOTPVC ()

@end

@implementation GetOTPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    _adharText.layer.borderColor=([UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor);
    _adharText.layer.borderWidth= 0.5f;

    //
    _customView.layer.cornerRadius = 10;
    _customView.layer.masksToBounds = YES;
    //
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    visualEffectView.frame = _imageView.bounds;
//    [_imageView addSubview:visualEffectView];
    
    
    /*****************************Card View*********************************/
    
    [self.customView setAlpha:1];
    self.customView.layer.masksToBounds = NO;
    self.customView.layer.cornerRadius = 5;
    self.customView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.customView.layer.shadowRadius = 25;
    self.customView.layer.shadowOpacity = 0.5;
    //

    CGRect rect = _getOTPBtn.frame;
    
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
    
    [_getOTPBtn.layer addSublayer:lineLayer];
    
    //Top Border
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _getOTPBtn.frame.size.width, 0.3f);
    TopBorder.backgroundColor = ([UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor);
    [_getOTPBtn.layer addSublayer:TopBorder];
    //
    
    //Top Border
    CALayer *TopBorder1 = [CALayer layer];
    TopBorder1.frame = CGRectMake(0.0f, 0.0f, _cancelBtn.frame.size.width, 0.3f);
    TopBorder1.backgroundColor = ([UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor);
    [_cancelBtn.layer addSublayer:TopBorder1];
    //
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getOTPBtn:(id)sender
{
    
    
    
    //Check blank String AadhaarNumber
    NSString *rawString = [self.adharText text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([trimmed length] == 0)
    {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please Enter Aadhaar Number"
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
    
    if (_adharText.text.length<12) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please Enter Valid 12 Digit Aadhaar Number"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                      _adharText.text = nil;
                                    }];
        
        
        //Add your buttons to alert controller
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    
    //Saving Aadhaar Number
    NSString *aadhaar = _adharText.text;
    [[NSUserDefaults standardUserDefaults] setObject:aadhaar forKey:@"Aadhaar Number"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //
    
    /*************************Web Service Get OTP***************************/
    
    [self startActivity:@"Processing..."];
    NSString *requestURL = [NSString stringWithFormat:@"%@GetOTP?AadhaarNumber=%@",kGetOTP,_adharText.text];
    
    [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
        
       // if(status)
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
                                                                   
                                                                   UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                   CustomSignVC *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"CustomSignVC"];
                                                                   objTrackOrderVC.aadhaarString = _adharText.text;
                                                                   objTrackOrderVC.esignString = @"Esign";
                                                                   self.definesPresentationContext = YES; //self is presenting view controller
                                                                   objTrackOrderVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                                                                   [self presentViewController:objTrackOrderVC animated:YES completion:nil];
                                                                   
                                                               }];
                                
                                   //Add your buttons to alert controller
                                   
                                   [alert addAction:yesButton];
                                   //[alert addAction:noButton];
                                   
                                   [self presentViewController:alert animated:YES completion:nil];
                                   
                                   [self stopActivity];
                               }
                               else
                               {
                                  
                                 UIAlertController * alert = [UIAlertController
                                                                alertControllerWithTitle:@"Info"
                                                                message:[[responseValue valueForKey:@"Messages"] objectAtIndex:0]
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                   
                                   //Add Buttons
                                   
                                   UIAlertAction* yesButton = [UIAlertAction
                                                               actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   //Handle your yes please button action here
                                                                   //[self clearAllData];
                                                                   _adharText.text = nil;
                                                               }];
                                   
                                   
                                   //Add your buttons to alert controller
                                   
                                   [alert addAction:yesButton];
                                   //[alert addAction:noButton];
                                   
                                   [self presentViewController:alert animated:YES completion:nil];
                                   
                                   [self stopActivity];
                               }
                               
                           });
            
        }
        else{
            
            NSError *error = (NSError *)responseValue;
            if (error) {
                
                dispatch_async(dispatch_get_main_queue(),
                               ^{
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
                                                //[self clearAllData];
                                            }];
                
                
                //Add your buttons to alert controller
                
                [alert addAction:yesButton];
                //[alert addAction:noButton];
                
               [self presentViewController:alert animated:YES completion:nil];
               [self stopActivity];
                return;
                               });
            }
        }
        [self stopActivity];
    }];
    
  
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                   withString:string];
    return resultText.length <= 12;
}

- (IBAction)cancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];

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