//
//  SignersInformation.m
//  emSigner
//
//  Created by EMUDHRA on 29/10/18.
//  Copyright © 2018 Emudhra. All rights reserved.
//

#import "SignersInformation.h"
#import "SignersCellTableViewCell.h"
#import "WebserviceManager.h"
#import "DocumentInfoCollectionCell.h"
#import "SignersCollectionCell.h"
#import "MBProgressHUD.h"
#import "NSObject+Activity.h"
#import "SignersDisplay.h"
#import "UploadDocuments.h"
#import "MPBSignatureViewController.h"
#import "ShowEditImagesFromImageList.h"
#import "HoursConstants.h"
#import "ReviewerController.h"
#import "LMNavigationController.h"
#import "UploadHeader.h"

@interface SignersInformation ()<uploadDocumentsDelegate,senddattaProtocol,UIGestureRecognizerDelegate>
{
    NSString *appendcategory;
    NSIndexPath *indexPather;
    NSIndexPath *signindexPather;
    BOOL signatoriesimg;
    NSInteger DocumentID;
    NSString * documentseries;
    NSMutableArray * DocumentIDArray;
    BOOL tick;
    int Documentindex;
    BOOL IsReviewer;
    BOOL IsSign;
    BOOL  isInfo;
    NSMutableArray *SignTypeArray;
    NSMutableArray* getSigners;
    NSMutableArray * SignType;
}

@end

@implementation SignersInformation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrayCount = [[NSMutableArray alloc] init];
    _arrayC = [[NSMutableArray alloc] init];
    //NSString *foruploadApiDocumentId = [NSString stringWithFormat:@"%ld",(long)self.DocumentIDFromUploadApi];
    //[[_signersArray[indexPath.row]valueForKey:@"DocumentID"]integerValue]
    //DocumentIDArray[indexPath.row]
    self.navigationController.navigationBar.topItem.title = @" ";
    
    // [_SignerActionInfo setTitle:@"Upload and Add Signatories" forState:UIControlStateNormal];
    UINib *nib  = [UINib nibWithNibName:@"UploadHeader" bundle:nil];
    
    [_signersInfoTable registerNib:nib forHeaderFooterViewReuseIdentifier:@"UploadHeader"];
    
    SignTypeArray = [[NSMutableArray alloc]init];
    
    [[NSUserDefaults standardUserDefaults]setValue:_categoryId forKey:@"WorkflowId"];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.copydataForNameAndEmailId = [[NSMutableArray alloc]init];
    _SignatoriesList= [[NSMutableArray alloc]init];
    _finalarray = [[NSMutableArray alloc]init];
    DocumentIDArray = [[NSMutableArray alloc]init];
    self.post =[[NSMutableArray alloc]init];
    signatoriesimg = false;
    // signatoriesimg = true;
    _signersArray = [[NSMutableArray alloc]init];
    self.signersInfoTable.delegate = self;
    self.signersInfoTable.dataSource = self;
    _getAllSigners = [[NSMutableArray alloc]init];
    _getAllSign = [[NSMutableArray alloc]init];
    getSigners = [[NSMutableArray alloc]init];
    _subscriberidarray = [[NSMutableArray alloc]init];
    _PageIdList = [[NSMutableArray alloc]init];
    SignType =  [[NSMutableArray alloc]init];
    self.resultsFromUploadApi = [[NSMutableArray alloc]init];
    self.SignerActionInfo.hidden = YES;
    self.sendDocuments.hidden = YES;
    [_sendDocuments setTitle:@"Upload and Add Documents" forState:UIControlStateNormal];
    [self setUpLeftSwipe];
    [self.signersInfoTable registerNib:[UINib nibWithNibName:@"SignersCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"SignersCellTableViewCell"];
    
    self.signersInfoTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getWorkFlow:self.categoryId];
    // Do any additional setup after loading the view from its nib.
    
    appendcategory = [NSString stringWithFormat:@"%@",_categoryname];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeleteNotification:)
                                                 name:@"parametersNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeleteNotification:)
                                                 name:@"signersParameters"
                                               object:nil];
    //self.title = @"Employee Onboarding";
    self.title = _navigationTitle;
    tick = false;
    
}
- (void)receiveDeleteNotification: (NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"parametersNotification"])
    {
        NSMutableDictionary *myDictionary = (NSMutableDictionary *)notification.object;
        
        [myDictionary setObject: [myDictionary objectForKey: @"CategoryID"] forKey: @"TemplateId"];
        [myDictionary removeObjectForKey: @"CategoryID"];
        
        [self.finalarray addObject:myDictionary];
       
        tick = true;
        
        if (_uniquearray.count ==  _signersArray.count)  {
            _sendDocuments.hidden = false;
            
        } else {
            _sendDocuments.hidden = true;
        }
        [self.signersInfoTable beginUpdates];
        [self.signersInfoTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPather, nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.signersInfoTable endUpdates];
    }
    
    else if  ([[notification name] isEqualToString:@"signersParameters"]){
        
        NSArray *myarray = (NSArray *)notification.object;
        NSLog(@"%@", myarray);
        _post = [myarray mutableCopy];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    // [_signersInfoTable reloadData];
    SignType =  [[NSMutableArray alloc]init];
    
    if (_SelectedArray.count != 0) {
        
        NSLog(@"%@", self.imagesDictionary);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //            for (int i= 0; i<_signersArray.count; i++) {
            //              // NSString*config =  [_signersArray[i]valueForKey:@"ConfigId"];
            //
            //
            //            if ([[_signersArray[i]valueForKey:@"ConfigId"] isEqual: [[NSUserDefaults standardUserDefaults] valueForKey:@"ConfigId"]]) {
            //
            //                NSArray *dictKeys=[self.imagesDictionary allKeys];
            //
            ////                for ( NSArray * arr   in self.imagesDictionary) {
            ////                    [finalarray addObject:arr];
            ////                     NSLog(@"%@",finalarray);
            ////                }
            //                //[finalarray addObject:self.imagesDictionary];
            //                NSString *stringpp = [self saveData:self.imagesDictionary];
            //                NSArray *a1 = [self loadData:stringpp];
            //                NSLog(@"%@",a1);
            //
            //            }
            //            }
            [self.finalarray replaceObjectAtIndex:indexPather.row withObject:self.imagesDictionary];//    self.imagesDictionary
            
            
        });
        
    }
}

- (void)viewWillLayoutSubviews
{
    
    //    self.Captcha_field.layer.cornerRadius = 5;
    //    self.emailText.layer.cornerRadius = 5;
    //
    //    CALayer *border = [CALayer layer];
    //    CGFloat borderWidth = 1;
    //    border.borderColor = ([UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor);
    //    border.frame = CGRectMake(0, _emailText.frame.size.height - borderWidth, _emailText.frame.size.width, _emailText.frame.size.height);
    //    border.borderWidth = borderWidth;
    //    [_emailText.layer addSublayer:border];
    //    _emailText.layer.masksToBounds = YES;
    //    //
    //    CALayer *border1 = [CALayer layer];
    //    CGFloat borderWidth1 = 1;
    //    border1.borderColor =  ([UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor);
    //    border1.frame = CGRectMake(0, _Captcha_field.frame.size.height - borderWidth1, _Captcha_field.frame.size.width, _Captcha_field.frame.size.height);
    //    border1.borderWidth = borderWidth1;
    //    [_Captcha_field.layer addSublayer:border1];
    //    _Captcha_field.layer.masksToBounds = YES;
}

-(NSString*)saveData :(id )dataArray
{
    NSFileManager *filemgr;
    NSString *docsDir;
    NSArray *dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the data file
    NSString *dataFilePath = [[NSString alloc] initWithString: [docsDir
                                                                stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.archive",[[NSUserDefaults standardUserDefaults]valueForKey:@"ConfigId"]]]];
    
    [NSKeyedArchiver archiveRootObject:dataArray toFile:dataFilePath];
    return dataFilePath;
}


-(NSMutableArray *)loadData:(NSString*)pathForArray
{
    NSFileManager *filemgr;
    NSString *docsDir;
    NSArray *dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the data file
    //NSString *dataFilePath = [[NSString alloc] initWithString: [docsDir
    //  stringByAppendingPathComponent: @"data.archive"]];
    
    // Check if the file already exists
    if ([filemgr fileExistsAtPath: pathForArray])
    {
        NSMutableArray *dataArray;
        
        dataArray = [NSKeyedUnarchiver
                     unarchiveObjectWithFile: pathForArray];
        
        return dataArray;
    }
    return NULL;
}

-(void)signatoryList
{
    //    NSString *requestURL = [NSString stringWithFormat:@"https://sandboxapi.emsigner.com/api/GetAllSigners"];
    //
    //    [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
    //        if(status)
    //        {
    //            dispatch_async(dispatch_get_main_queue(),
    //                           ^{
    //
    //
    //                               _getAllSigners = [responseValue valueForKey:@"Response"];
    //                               // [self.signersInfoTable reloadData];
    //
    //                           });
    //        }
    //        else{
    //
    //
    //            UIAlertController * alert = [UIAlertController
    //                                         alertControllerWithTitle:nil
    //                                         message:@"Your emsigner account is no longer active.Please login again"
    //                                         preferredStyle:UIAlertControllerStyleAlert];
    //
    //            //Add Buttons
    //
    //            UIAlertAction* yesButton = [UIAlertAction
    //                                        actionWithTitle:@"Ok"
    //                                        style:UIAlertActionStyleDefault
    //                                        handler:nil ];
    //
    //            [alert addAction:yesButton];
    //
    //            [self presentViewController:alert animated:YES completion:nil];
    //
    //            return;
    //        }
    //
    //
    //    }];
    //
}

-(void)getWorkFlow:(NSString*)categoryId
{
    [self startActivity:@""];
    //GetConfigDetails?
    NSString *requestURL = [NSString stringWithFormat:@"%@GetFlexiformTemplateDetails?categoryId=%@",kGetFlexiformTemplateDetails,categoryId];
    
    [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
        //if(status)
        if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                _signersArray = [responseValue valueForKey:@"Response"];
                NSMutableDictionary *empty = [[NSMutableDictionary alloc]init];
                
                for (int i = 0; i<_signersArray.count; i++) {
                    // [_finalarray addObject:empty];
                    
                    // _post = _signersArray;
                    
                    if (_uniqueA.count < 1) {
                        
                    } else {
                        [_post addObject:empty];
                    }
                    
                    
                    
                    // [getSigners addObject:[[responseValue valueForKey:@"Response"][i]valueForKey:@"SignatoriesList"]];
                    // [SignTypeArray addObject:[[responseValue valueForKey:@"Response"][i]valueForKey:@"SignatoriesList"]];
                    //
                    //                                   [getSigners addObject:empty];
                    [SignTypeArray addObject:@""];
                    //                                 [_SignatoriesList addObject:[[responseValue valueForKey:@"Response"][i]valueForKey:@"SignatoriesList"]];
                    //
                    //                                   [_PageIdList addObject:[[responseValue valueForKey:@"Response"][i]valueForKey:@"PageIds"]];
                }
                
                
                [self stopActivity];
                if ([[responseValue valueForKey:@"IsSuccess"]boolValue] == 1) {
                    [self.signersInfoTable reloadData];
                }
                else{
                    //[self.navigationController popViewControllerAnimated:true];
                }
            });
        }
        else{
            
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:nil
                                         message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            //Add Buttons
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:nil ];
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            [self stopActivity];
            return;
        }
        
        
    }];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 68;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UploadHeader *header = [_signersInfoTable dequeueReusableHeaderFooterViewWithIdentifier:@"UploadHeader"];
    
    
    return header;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _signersArray.count;
    
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignersCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignersCellTableViewCell" forIndexPath:indexPath];
    
    [cell.signerslbl sizeToFit];
    
    cell.signerslbl.text = [[_signersArray objectAtIndex:indexPath.row]valueForKey:@"DocumentName"];
    [cell.SignerInfo addTarget:self action:@selector(SignerActionInfo:) forControlEvents:UIControlEventTouchUpInside];
    cell.pageCount.text = [NSString stringWithFormat:@"%@",[[_signersArray objectAtIndex:indexPath.row]valueForKey:@"PageSize"] ];
    
    if (signatoriesimg == false) {
        cell.SignerInfo.hidden = true;
        cell.uploaddocument.hidden = false;
        // cell.dateSelected.hidden = false;
        //cell.SignerInfo.translatesAutoresizingMaskIntoConstraints = NO;
        //cell.SignerInfo.frame = CGRectMake(0,0,0,0);ƒ
        
    }
    else
    {
        cell.SignerInfo.hidden = false;
        // cell.dateSelected.hidden = true;
        cell.uploaddocument.hidden = true;
        cell.infoBtn.hidden = true;
    }
    /* if (isInfo == true) {
     cell.dateSelected.hidden = true;
     }*/
    
    
    if (tick == true) {
        //[cell.uploaddocument setTitle:@"  Re-upload  " forState:UIControlStateNormal];
        cell.tickImageView.image = [UIImage imageNamed:@"completed-1x.png"];
    }
    
    
    
    [cell.uploaddocument addTarget:self action:@selector(Uploaddocument:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.infoBtn addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.signersCollectionView  setDataSource:self];
    [cell.signersCollectionView  setDelegate:self];
    [cell.signersCollectionView  setBackgroundColor:[UIColor whiteColor]];
    
    [cell.signersCollectionView registerNib:[UINib nibWithNibName:@"SignersCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"SignersCollectionCell"];
    
    cell.signersCollectionView.tag = indexPath.row;
    [cell.signersCollectionView reloadData];
    
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
}

- (void)setUpLeftSwipe {
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(swipeRight:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.signersInfoTable addGestureRecognizer:recognizer];
    
    
    recognizer.delegate = self;
}

- (void) Uploaddocument:(UIButton*)sender
{
    _sendarray = [[NSMutableArray alloc]initWithArray:_signersArray];
    NSLog(@"Uploaddocument");
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.signersInfoTable];
    indexPather = [self.signersInfoTable indexPathForRowAtPoint:buttonPosition];
    NSInteger index = indexPather.row;
    
    [self.arrayCount addObject:[NSString stringWithFormat:@"%ld",(long)index]];
    _uniquearray = [[NSSet setWithArray:_arrayCount] allObjects];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:[[[_signersArray objectAtIndex:indexPather.row]valueForKey:@"ConfigId"]integerValue] forKey:@"ConfigId"];
    
    UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UploadDocuments *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"UploadDocuments"];
    objTrackOrderVC.sendarray= _sendarray;
    objTrackOrderVC.workflowId = _categoryId;
    objTrackOrderVC.documentName= [_sendarray[indexPather.row]valueForKey:@"DocumentName"];
    objTrackOrderVC.navigationTitle = [NSString stringWithFormat:@"%@/%@",self.navigationTitle,[_sendarray[indexPather.row]valueForKey:@"DocumentName"]];
    objTrackOrderVC.categoryname = _categoryname;
    objTrackOrderVC.delegate = self;
    objTrackOrderVC.modalPresentationStyle = UIModalPresentationFullScreen;
    UINavigationController *objNavigationController = [[UINavigationController alloc]initWithRootViewController:objTrackOrderVC];
    objNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:objNavigationController animated:true completion:nil];
    
    //  [self.navigationController pushViewController:objTrackOrderVC animated:YES];
    
}



- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.signersInfoTable];
    NSIndexPath *indexPath = [self.signersInfoTable indexPathForRowAtPoint:location];
    NSLog(@"Cell swiped %ld",(long)indexPath.row);
    NSString* base64Data = [[_signersArray objectAtIndex:indexPath.row]valueForKey:@"Base64FileData"];
    
    NSData *dataPdf = [[NSData alloc] initWithBase64EncodedString:base64Data options:0];
    
    //Get path directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //Create PDF_Documents directory
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"PDF_Documents"];
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[[_signersArray objectAtIndex:indexPath.row]valueForKey:@"DocumentName"]];
    
    [dataPdf writeToFile:filePath atomically:YES];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (fileExists == true) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle: @"Success"
                                     message:@"Template Downloaded successfully!" preferredStyle:UIAlertControllerStyleAlert];
        //[self.copydataForNameAndEmailId objectAtIndex:indexPath.item]    //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:nil ];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else  {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle: @"Failure!"
                                     message:@"Templet Download Failed!" preferredStyle:UIAlertControllerStyleAlert];
        //[self.copydataForNameAndEmailId objectAtIndex:indexPath.item]    //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:nil ];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    // ... do something with cell now that i have the indexpath, maybe save the world? ...
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

//Sign Button Clicked
-(void)SignerActionInfo:(UIButton*)sender
{
    //Aadu
    NSIndexPath *indexPath = [self.signersInfoTable indexPathForCell:(UITableViewCell *)sender.superview.superview];
    isInfo = true;
    
    NSInteger index = indexPath.row;
    
    [self.arrayC addObject:[NSString stringWithFormat:@"%ld",(long)index]];
    _uniqueA = [[NSSet setWithArray:_arrayC] allObjects];
    
    // long maxNum = DocumentIDArray[indexPath.row];
    NSString* mapX = [_signersArray[indexPath.row]valueForKey:@"DocumentID"];
     [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"indexvalue"];
    _dName = [_signersArray[indexPath.row]valueForKey:@"DocumentName"];
    //_indexCount = indexPath.row;
    
    [self callForGetFlexiformControldetails:mapX:indexPath];
    
}

-(void)callForGetFlexiformControldetails:(NSString*)documentIDFromUploadApi:(NSIndexPath *) indexPath{
    
    [self startActivity:@"Refreshing"];
    NSString *requestURL = [NSString stringWithFormat:@"%@GetFlexiformControldetails?pfDocumentid=%@",kGetFlexiformControldetails,documentIDFromUploadApi];
    
    [WebserviceManager sendSyncRequestWithURLGet:requestURL method:SAServiceReqestHTTPMethodGET body:requestURL completionBlock:^(BOOL status, id responseValue) {
        
        if(status && ![[responseValue valueForKey:@"Response"] isKindOfClass:[NSNull class]])
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                [_signersInfoTable reloadData];
                //                  _responseArray=[[responseValue valueForKey:@"Response"]valueForKey:@"PfConfigList"];
                self.SignatoriesList = [[responseValue valueForKey:@"Response"]valueForKey:@"SignatoryList"];
                NSMutableDictionary *empty = [[NSMutableDictionary alloc]init];
                
                for (int i = 0; i<self.SignatoriesList.count; i++) {
                    //                                                  [_finalarray addObject:empty];
                    //                                                  [_post addObject:empty];
                    
                    //[getSigners addObject:[[responseValue valueForKey:@"Response"][i]valueForKey:@"SignatoryList"]];
                    //[SignTypeArray addObject:[[responseValue valueForKey:@"Response"]valueForKey:@"SignatoryList"]];
                    
                    //                                                  [getSigners addObject:empty];
                    //[SignTypeArray addObject:@""];
                    // [_SignatoriesList addObject:[[responseValue valueForKey:@"Response"][i]valueForKey:@"SignatoriesList"]];
                    
                    // [_PageIdList addObject:[[responseValue valueForKey:@"Response"][i]valueForKey:@"PageIds"]];
                }
                
                
                
                SignersDisplay *objTrackOrderVC= [[SignersDisplay alloc] initWithNibName:@"SignersDisplay" bundle:nil];
                objTrackOrderVC.delegate = self;
                objTrackOrderVC.signersCount = self.SignatoriesList.count;
                
                objTrackOrderVC.CategoryId = _categoryId;
                objTrackOrderVC.Documentname =  [_signersArray[indexPath.row]valueForKey:@"DocumentName"];
                objTrackOrderVC.CategoryName = _categoryname;
                objTrackOrderVC.SignerssectionArray = _SignatoriesList;
                objTrackOrderVC.DocumentID = [[_signersArray[indexPath.row]valueForKey:@"DocumentID"]integerValue];
                objTrackOrderVC.DocumentIDFromUploadApi = DocumentIDArray[indexPath.row];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Close"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [objTrackOrderVC setModalPresentationStyle:UIModalPresentationFullScreen];
                
                UINavigationController *objNavigationController = [[UINavigationController alloc]initWithRootViewController:objTrackOrderVC];
                [self presentViewController:objNavigationController animated:true completion:nil];
                [self stopActivity];
                
            });
            
        }
        else{
            
        }
        
    }];
}


-(void)sendDataTosigners:(NSMutableArray *)array SubscriberDict:(NSMutableDictionary *)subscriberdict SignType:(NSMutableArray *)SignType DataForNameAndEmailID:(NSMutableArray *)dataForNameAndEmailId {
    NSLog(@"%@%@",array,subscriberdict);
    _getAllSigners = [array mutableCopy];
    [_getAllSign addObject:array];
    NSInteger  indexCount = [[[NSUserDefaults standardUserDefaults]valueForKey:@"indexvalue"]integerValue];
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:indexCount inSection:0];
    getSigners = array;
    SignTypeArray = SignType;
    [_copydataForNameAndEmailId addObject:dataForNameAndEmailId];
    // _post = subscriberdict;
    //  [getSigners replaceObjectAtIndex:indexCount withObject:[array firstObject]];
    //  [SignTypeArray replaceObjectAtIndex:indexCount withObject:[SignType firstObject]];
  
    [_post addObject:subscriberdict];
    
    if (_uniqueA.count == _signersArray.count) {
        self.SignerActionInfo.hidden = false;
    } else {
        self.SignerActionInfo.hidden = true;
    }
    
    self.sendDocuments.hidden = true;
    
    [self.signersInfoTable beginUpdates];
    if ([[_signersArray objectAtIndex:rowToReload.row]valueForKey:@"DocumentName"] == _dName) {
         [self.signersInfoTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:rowToReload, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
   
    [self.signersInfoTable endUpdates];
    
    
}

-(void)sendData:(NSDictionary *)senddict {
    
}



-(void)showInfo:(UIButton*)sender
{
    
    
    //    [self.finalarray replaceObjectAtIndex:indexPather.row withObject:senddict];
    //    [self.navigationController popViewControllerAnimated:true];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (_getAllSigners.count > 0){
    if (_signersArray.count > 1) {
        switch (indexPath.row) {
            case 0:
                
                if (_uniqueA.count >= 1) {
                    
                 return 110;
                    
                } else return 50;
                break;
            case 1:
                if (_uniqueA.count >= 2) {
                     
                    return 110;
                     
                 } else return 50;
                break;
            default:
                return 50;
                break;
        }
    } else {
        return 50;
    }
    } else {
        return 50;
    }
    
}

#pragma mark - collectionView datasources
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return _getAllSigners.count;
   
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    CGSize defaultSize = CGSizeMake(120, 40);
    
    
    return defaultSize;
}



//-(void)sendDataToA:(NSMutableArray *)array :(NSMutableArray*)signatoryidarray
//{
//    // data will come here inside of ViewControllerA
//    _getAllSigners = [array mutableCopy];
//    _subscriberidarray = [signatoryidarray mutableCopy];
//
//    //[_pickImagesandDate addObject:array];
//    NSInteger  indexCount = [[[NSUserDefaults standardUserDefaults]valueForKey:@"indexvalue"]integerValue];
//    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:indexCount inSection:0];
//
//    [self.signersInfoTable beginUpdates];
//    [self.signersInfoTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:rowToReload, nil] withRowAnimation:UITableViewRowAnimationNone];
//    [self.signersInfoTable endUpdates];
//    // [self.listTable reloadData];
//}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SignersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SignersCollectionCell" forIndexPath:indexPath];
    //NSInteger  indexCount = [[[NSUserDefaults standardUserDefaults]valueForKey:@"indexvalue"]integerValue];
   
    NSString *initals = _getAllSigners[indexPath.item];
    NSMutableArray *initComponents = [initals componentsSeparatedByString:@" "];

    if (initComponents.lastObject == (id)[NSNull null]) {
        cell.signersLbl.text= _getAllSigners[indexPath.item];
    } else {
       cell.signersLbl.text= initComponents.firstObject;
    }

    if ([_getAllSign.firstObject containsObject: @"ME"]) {
        [_SignerActionInfo setTitle:@"Sign and Send" forState:UIControlStateNormal];
    } else {
        [_SignerActionInfo setTitle:@"Send for Signature" forState:UIControlStateNormal];
    }
    if (indexPath.item == 0)  {
        cell.signersLbl.backgroundColor = [UIColor colorWithRed:0.0 green:0.376 blue:0.752 alpha:0.5];
        cell.signersLbl.textColor = UIColor.whiteColor;
        cell.signersLbl.font = [UIFont systemFontOfSize:15];
    }  else {
        cell.signersLbl.backgroundColor = UIColor.lightGrayColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     NSLog(@"%ld",(long)collectionView.tag);

    
        
        if ([[self.copydataForNameAndEmailId[(long)collectionView.tag] objectAtIndex:indexPath.item]valueForKey:@"Email_Id"] == (id)[NSNull null] && [[self.copydataForNameAndEmailId[(long)collectionView.tag] objectAtIndex:indexPath.item]valueForKey:@"Name"] == (id)[NSNull null] ) {
                          NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:@"Email"];
                          UIAlertController * alert = [UIAlertController
                                                       alertControllerWithTitle:[NSString stringWithFormat: @"Name : ME"]
                                                       message:[NSString stringWithFormat: @"Email ID :%@",email]
                                                       preferredStyle:UIAlertControllerStyleAlert];
                          //[self.copydataForNameAndEmailId objectAtIndex:indexPath.item]    //Add Buttons
                          
                          UIAlertAction* yesButton = [UIAlertAction
                                                      actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleDefault
                                                      handler:nil ];
                          
                          [alert addAction:yesButton];
                          
                          [self presentViewController:alert animated:YES completion:nil];
           
                      } else {
                      UIAlertController * alert = [UIAlertController
                                                   alertControllerWithTitle:[NSString stringWithFormat: @"Name :%@ ", [[self.copydataForNameAndEmailId[(long)collectionView.tag] objectAtIndex:indexPath.item] valueForKey:@"Name"]]
                                                   message:[NSString stringWithFormat: @"Email ID :%@",[[self.copydataForNameAndEmailId[(long)collectionView.tag] objectAtIndex:indexPath.item]valueForKey:@"Email_Id"]]
                                                   preferredStyle:UIAlertControllerStyleAlert];
                      //[self.copydataForNameAndEmailId objectAtIndex:indexPath.item]    //Add Buttons
                      
                      UIAlertAction* yesButton = [UIAlertAction
                                                  actionWithTitle:@"Ok"
                                                  style:UIAlertActionStyleDefault
                                                  handler:nil ];
                      
                      [alert addAction:yesButton];
                      
                          [self presentViewController:alert animated:YES completion:nil];
                         
                      }
    
    
  
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
}
- (IBAction)uploadSignatories:(id)sender {
    
    if ([_getAllSign.firstObject containsObject:@"ME"]) {
        //Adarsha Hebbar
        [self showModal:UIModalPresentationFullScreen style:[MPBDefaultStyleSignatureViewController alloc]];
        
        
    } else {
        
        
        Documentindex = 0;
        
        for (int i = 0; i<_post.count; i++) {
            
            if ([_post[i]valueForKey:@"DocumentName"]) {
                NSLog(@"%d", i);
                Documentindex++;
                
            }
            else{
                NSLog(@"%d", i);
            }
        }
        
        //[_post setValue:DocumentIDArray.firstObject forKey:@"DocumentId"];
        if (_post.count == Documentindex) {
            for (int i = 0; i<SignTypeArray.count; i++) {
                //Reviewer
                if([SignTypeArray[i]  isEqual:@"Reviewer"]) {
                    [SignType addObject:@"Reviewer"];
                    
                }
                //SignPad
                else if ([SignTypeArray[i] isEqual:@"Signer"]){
                    [SignType addObject:@"Signer"];
                    //signerIndex = i;
                }
                else{
                    [SignType addObject:@"Internal"];
                }
                
            }
            
            
            if ([SignType containsObject:@"Signer"] && [SignType containsObject:@"Reviewer"]) {
                
                //REviwer contreoller and then signPad
                UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ReviewerController *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"ReviewerController"];
                self.definesPresentationContext = YES; //self is presenting view controller
                objTrackOrderVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                objTrackOrderVC.requestArray = _post;
                objTrackOrderVC.d = getSigners;
                objTrackOrderVC.subscriberIdarray = SignType;
                //  objTrackOrderVC.workflowID = [[_searchResults objectAtIndex:sender.tag] valueForKey:@"WorkFlowId"];;
                objTrackOrderVC.modalPresentationStyle = UIModalPresentationFullScreen;
                [self.navigationController presentViewController:objTrackOrderVC animated:YES completion:nil];
                
            }
            else if ([SignType containsObject:@"Signer"])
            {
                //Signpad
                [self showModal:UIModalPresentationFullScreen style:[MPBDefaultStyleSignatureViewController alloc]];
                
            }
            else if ([SignType containsObject:@"Reviewer"])
            {
                //ReviwerContriollert
                UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ReviewerController *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"ReviewerController"];
                self.definesPresentationContext = YES; //self is presenting view controller
                objTrackOrderVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                objTrackOrderVC.requestArray = _post;
                objTrackOrderVC.d = getSigners;
                objTrackOrderVC.subscriberIdarray = SignType;
                objTrackOrderVC.modalPresentationStyle = UIModalPresentationFullScreen;
                [self.navigationController presentViewController:objTrackOrderVC animated:YES completion:nil];
                
            }
            else{
                
                UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AttachedVC *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"AttachedVC"];
                objTrackOrderVC.documentID = [NSString stringWithFormat:@"%@",[_signersArray[0]valueForKey:@"DocumentID"]];
                objTrackOrderVC.parametersForWorkflow = _post;
             
                objTrackOrderVC.document = @"ListAttachments";
                UINavigationController *objNavigationController = [[UINavigationController alloc]initWithRootViewController:objTrackOrderVC];
                [self presentViewController:objNavigationController animated:true completion:nil];
       
            }
            
        }
        
        //[self callinitWorkFlowApi:_post];
        
        
        else{
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:nil
                                         message:@"Select reqired Signatures!"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            //Add Button
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:nil ];
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
            
        }
        
        
    }
    
}


-(void)callinitWorkFlowApi:(NSMutableArray*)post
{
    
    [self startActivity:@"Loading"];
    
    // [WebserviceManager sendSyncRequestWithURLDocument:@"https://sandboxapi.emsigner.com/api/InitiateWorkflow" method:SAServiceReqestHTTPMethodPOST body:post completionBlock:^(BOOL status, id responseValue){
    
    [WebserviceManager sendSyncRequestWithURLDocument:kInitiateWorkflow method:SAServiceReqestHTTPMethodPOST body:post completionBlock:^(BOOL status, id responseValue){
        
        if (status) {
            int issucess = [[responseValue valueForKey:@"IsSuccess"]intValue];
            
            if (issucess != 0) {
                
                NSNumber * isSuccessNumber = (NSNumber *)[responseValue valueForKey:@"IsSuccess"];
                if([isSuccessNumber boolValue] == YES)
                {
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                        UIAlertController * alert = [UIAlertController
                                                     alertControllerWithTitle:@""
                                                     message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        
                        //Add Buttons
                        
                        UIAlertAction* yesButton = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                            //Handle your yes please button action here
                            
                            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            LMNavigationController *objTrackOrderVC= [sb  instantiateViewControllerWithIdentifier:@"HomeNavController"];
                            [[[[UIApplication sharedApplication] delegate] window] setRootViewController:objTrackOrderVC];
                        }];
                        
                        //Add your buttons to alert controller
                        
                        [alert addAction:yesButton];
                        [self presentViewController:alert animated:YES completion:nil];
                        [self stopActivity];
                    });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                        UIAlertController * alert = [UIAlertController
                                                     alertControllerWithTitle:@""
                                                     message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        
                        //Add Buttons
                        
                        UIAlertAction* yesButton = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                            //Handle your yes please button action here
                            
                        }];
                        
                        //Add your buttons to alert controller
                        
                        [alert addAction:yesButton];
                        [self presentViewController:alert animated:YES completion:nil];
                        [self stopActivity];
                    });
                    
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@""
                                                 message:[[responseValue valueForKey:@"Messages"]objectAtIndex:0]
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    //Add Buttons
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                        //Handle your yes please button action here
                        
                    }];
                    
                    //Add your buttons to alert controller
                    
                    [alert addAction:yesButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    [self stopActivity];
                });
                
            }
            
        }
        else{
            [self stopActivity];
        }
    }];
    
}

- (IBAction)sendDocuments:(id)sender {
    
    
    NSUserDefaults *savePathForPdf = [NSUserDefaults standardUserDefaults];
    NSString *getPathForPdf = [savePathForPdf valueForKey:@"savedPathForPdf"];
    DocumentIDArray = [NSMutableArray new];
    NSData *convertToByrtes = [NSData dataWithContentsOfFile:getPathForPdf];
    NSString *base64image = [convertToByrtes base64EncodedStringWithOptions:0];
    
    if (base64image == nil && !tick) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please upload images ."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
            //Handle your yes please button action here
            
        }];
        
        //Add your buttons to alert controller
        signatoriesimg = true;
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else  {
        
        Documentindex = 0;
        
        for (int i = 0; i<_finalarray.count; i++) {
            if ([_finalarray[i]valueForKey:@"DocumentName"]) {
                NSLog(@"%d", i);
                Documentindex++;
            }
            else{
                NSLog(@"%d", i);
            }
        }
        
        
        if (_finalarray.count == Documentindex) {
            
            
            
            [self uploadApi:_finalarray];
            
        }
        else{
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:nil
                                         message:@"Upload reqired Documents!"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            //Add Buttons
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:nil ];
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
            
        }
        
    }
    
}

- (void)showModal:(UIModalPresentationStyle) style style:(MPBCustomStyleSignatureViewController*) controller
{
    
    NSInteger cid = [_categoryId integerValue];
    
    NSMutableDictionary* sendingvalues = [[NSMutableDictionary alloc]init];
    [sendingvalues setObject:[NSNumber numberWithInteger:cid] forKey:@"CategoryId"];
    [sendingvalues setObject:_categoryname forKey:@"CategoryName"];
    [sendingvalues setObject:[[_signersArray objectAtIndex:0]valueForKey:@"DocumentName"] forKey:@"DocumentName"];
    [sendingvalues setObject:_subscriberidarray  forKey:@"Signatories"];
    [sendingvalues setObject:@"true" forKey:@"IsSign"];
    [sendingvalues setValue:[NSNumber numberWithInteger:DocumentID] forKey:@"DocumentId"];
    NSMutableArray * post =[[NSMutableArray alloc]init];
    [post addObject:sendingvalues];
    
    MPBCustomStyleSignatureViewController* signatureViewController = [controller initWithConfiguration:[MPBSignatureViewControllerConfiguration configurationWithFormattedAmount:@""]];
    signatureViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    signatureViewController.strExcutedFrom=@"Waiting for Others";
    signatureViewController.isFromSignerView = true;
    signatureViewController.gotParametersForInitiateWorkFlow = _post;
    signatureViewController.d = getSigners;
    signatureViewController.subscriberIdarray = SignType;
    signatureViewController.preferredContentSize = CGSizeMake(800, 500);
    signatureViewController.configuration.scheme = MPBSignatureViewControllerConfigurationSchemeAmex;
    signatureViewController.continueBlock = ^(UIImage *signature) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AttachedVC *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"AttachedVC"];
        objTrackOrderVC.documentID = [NSString stringWithFormat:@"%@",[_signersArray[0]valueForKey:@"DocumentID"]];
        objTrackOrderVC.parametersForWorkflow = _post;
        objTrackOrderVC.document = @"ListAttachments";
        objTrackOrderVC.modalPresentationStyle = UIModalPresentationFullScreen;
        UINavigationController *objNavigationController = [[UINavigationController alloc]initWithRootViewController:objTrackOrderVC];
        objNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:objNavigationController animated:true completion:nil];
        // [self.navigationController pushViewController:objTrackOrderVC animated:YES];
    };
    signatureViewController.cancelBlock = ^ {
        
    };
    [self presentViewController:signatureViewController animated:YES completion:nil];
    
}

-(void) uploadApi:(NSMutableArray *)post
{
    [self startActivity:@""];
http://10.80.102.44:7001/
https://sandboxapi.emsigner.com/api/
    
    
    [WebserviceManager sendSyncRequestWithURLDocument:kDocumentupload method:SAServiceReqestHTTPMethodPOST body:post completionBlock:^(BOOL status, id responseValue){
        if (status) {
            int issucess = [[responseValue valueForKey:@"IsSuccess"]intValue];
            
            if (issucess != 0) {
                NSNumber * isSuccessNumber = (NSNumber *)[responseValue valueForKey:@"IsSuccess"];
                if([isSuccessNumber boolValue] == YES)
                {
                    self.resultsFromUploadApi = [responseValue valueForKey:@"Response"];
                    for(int i = 0; i < self.resultsFromUploadApi.count; i++)
                    {
                        [DocumentIDArray addObject: [[[responseValue valueForKey:@"Response"]objectAtIndex:i]valueForKey:@"DocumentID"]];
                        
                    }
                    
                    [self stopActivity];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@""
                                                 message:[[responseValue valueForKey:@"Messages"] objectAtIndex:0]
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    //Add Buttons
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                        //Handle your yes please button action here
                        
                    }];
                    _sendDocuments.hidden = true;
                    //Add your buttons to alert controller
                    signatoriesimg = true;
                    [alert addAction:yesButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    [self.signersInfoTable reloadData];
                    [self stopActivity];
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@""
                                                 message:[[responseValue valueForKey:@"Messages"] objectAtIndex:0]
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    //Add Buttons
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                        //Handle your yes please button action here
                        
                    }];
                    
                    //Add your buttons to alert controller
                    
                    [alert addAction:yesButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    [self stopActivity];
                });
                
            }
            
        }
        else
        {
            [self stopActivity];
        }
    }];
}
@end