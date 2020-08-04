//
//  ViewController.m
//  imagecroper
//
//  Created by Administrator on 10/12/18.
//  Copyright © 2018 Emudhra. All rights reserved.
//

#import "UploadDocuments.h"
#import "ImagelistCell.h"
#import "ShowEditImagesFromImageList.h"
#import "AppDelegate.h"
#import "PreviewerController.h"
#import <PDFKit/PDFKit.h>
#import "ShowPdfForImages.h"
#import "emSigner-Swift.h"

@interface UploadDocuments ()
{
    NSString* meta;
    NSMutableArray *countArray;
    UILabel*  noDataLabel;
    PDFDocument *pdfDocument;

}

@property(retain,nonatomic)AppDelegate *appDelegate;
@property(strong,nonatomic) WorkflowScannerController *cntroller;
@end

@implementation UploadDocuments
//@synthesize addButton;
- (void)viewDidLoad {
    [super viewDidLoad];
  //  NSLog(@"%@",_sendarray);
    
    // Do any additional setup after loading the view, typically from a nib.
    _pickImagesandDate = [[NSMutableArray alloc]init];
    _fileSize = [[NSMutableArray alloc]init];
    // _arrayForDelegate = [[NSMutableArray alloc]init];
   // _SelectedArray = [[NSMutableArray alloc]init];
    _listTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    countArray = [[NSMutableArray alloc]init];
    [self.listTable registerNib:[UINib nibWithNibName:@"ImagelistCell" bundle:nil] forCellReuseIdentifier:@"ImagelistCell"];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:96.0/255.0 blue:192.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (self.navigationTitle == nil) {
        self.title = @"Attachment Upload";
    } else {
        self.title =self.navigationTitle;
    }
    
   // self.title = self.navigationTitle;
    
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissViewController)];
    
    self.navigationItem.leftBarButtonItem = customBarButtonItem;
    
    UIBarButtonItem* addBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDocuments)];
       
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeleteNotification:)
                                                 name:@"DeleteNotification"
                                               object:nil];
 
    
//    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 20, [UIScreenƒ mainScreen].bounds.size.height - 44 - 75, 54, 54);
//
//    addButton = [[VCFloatingActionButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"plus"] andPressedImage:[UIImage imageNamed:@"cross"] withScrollview:_listTable];
//
//
//
//      addButton.imageArray = @[@"documentpotline",@"library",@"Camera"];
//      addButton.labelArray = @[@"Document",@"Library",@"Camera"];
//
//    addButton.hideWhileScrolling = YES;
//    addButton.delegate = self;
//
//    [self.view addSubview:addButton];
    
}

-(void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) addDocuments{
    UIAlertController * view=   [[UIAlertController
                                     alloc]init];
       UIAlertAction* Camera = [UIAlertAction
                                actionWithTitle:@"Camera"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Do some thing here

                                    //[self getDocumentInfo:[[_searchResults objectAtIndex:sender.tag] valueForKey:@"WorkFlowId"]];
           
                                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                    {
                                        
//                                        _cntroller = [[WorkflowScannerController alloc]init];
//                                        [self presentViewController:_cntroller animated:YES completion:nil];

                                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                                        [imagePicker setDelegate:self];
                                        [self presentViewController:imagePicker animated:YES completion:nil];

                                    }
                                    else
                                    {
                                        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                                    }

                                }];
    UIAlertAction* Gallery = [UIAlertAction
                                   actionWithTitle:@"Gallery"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Do some thing here

                                              UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                              imagePickerController.delegate = self;
                                              imagePickerController.navigationBar.translucent = false;
                                              imagePickerController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:96.0/255.0 blue:192.0/255.0 alpha:1.0];
                                              imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
                                              imagePickerController.navigationBar.tintColor = [UIColor whiteColor]; // Cancel button ~ any UITabBarButton items
                                              
                                              [self presentViewController:imagePickerController animated:YES completion:nil];

                                   }];
    UIAlertAction* Document = [UIAlertAction
                                   actionWithTitle:@"Document"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Do some thing here

                                       //[self getDocumentInfo:[[_searchResults objectAtIndex:sender.tag] valueForKey:@"WorkFlowId"]];
                                            [self showDocumentPickerInMode:UIDocumentPickerModeOpen];
        
                                   }];
    UIAlertAction* cancel = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction * action)
                                {

                                }];
    view.view.tintColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    [view addAction:Camera];
    [view addAction:Gallery];
    [view addAction:Document];
    [view addAction:cancel];


    [self presentViewController:view animated:YES completion:nil];
}

- (void)receiveDeleteNotification: (NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"DeleteNotification"])
    {
        _pickImagesandDate = [NSMutableArray array];
        [self.listTable reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
//    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSFetchRequest *fetchRequest =
//    [[NSFetchRequest alloc] initWithEntityName:@"Documents"];
//    self.arrayForDelegate = [[_appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    fetchRequest.returnsObjectsAsFaults = NO;
//    NSLog(@"count=%ld", (unsigned long)self.sendarray.count);
//    //[self.listTable reloadData];
//    if (self.arrayForDelegate.count != 0) {
//        [self.listTable reloadData];
//    }
    [self.listTable reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

//-(void) didSelectMenuOptionAtIndex:(NSInteger)row
//{
//    NSLog(@"Floating action tapped index %tu",row);
//    if (row == 2) {
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//        {
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//            [imagePicker setDelegate:self];
//            [self presentViewController:imagePicker animated:YES completion:nil];
//
//        }
//        else
//        {
//            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        }
//
//    }
//    else if (row == 1)
//    {
//        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate = self;
//        imagePickerController.navigationBar.translucent = false;
//        imagePickerController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:96.0/255.0 blue:192.0/255.0 alpha:1.0];
//        imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
//        imagePickerController.navigationBar.tintColor = [UIColor whiteColor]; // Cancel button ~ any UITabBarButton items
//
//        [self presentViewController:imagePickerController animated:YES completion:nil];
//    }
//    else if (row == 0)
//    {
//
//        [self showDocumentPickerInMode:UIDocumentPickerModeOpen];
//    }
//
//}


//- (IBAction)ControllerAction:(UIBarButtonItem *)sender {
//
//    if (sender.tag == 1) {
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//        {
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//            [imagePicker setDelegate:self];
//            imagePicker.allowsEditing = NO;
//            imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
//
//            [self presentViewController:imagePicker animated:YES completion:nil];
//
//        }
//        else
//        {
//            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        }
//
//    }
//    else if (sender.tag == 2)
//    {
//        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate = self;
//        imagePickerController.navigationBar.translucent = false;
//        imagePickerController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:96.0/255.0 blue:192.0/255.0 alpha:1.0];
//        imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
//        imagePickerController.navigationBar.tintColor = [UIColor whiteColor]; // Cancel button ~ any UITabBarButton items
//
//        [self presentViewController:imagePickerController animated:YES completion:nil];
//    }
//    else if (sender.tag == 3)
//    {
//        [self showDocumentPickerInMode:UIDocumentPickerModeOpen];
//    }
//
//}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *url  = info[UIImagePickerControllerImageURL];
    _documentName = url.lastPathComponent;
    NSString *imageName = url.lastPathComponent;
    if (imageName) {
      
    } else {
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
              form.dateFormat = @"yyyy:MM:dd HH:mm:ss";
              NSString* date = [form stringFromDate:[NSDate date]];
              imageName = [NSString stringWithFormat:@"CamImg-%@",date];
    }
    
    image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //self.imgForDisplay.image=[self scaleAndRotateImage:image];
    image = [self scaleAndRotateImage:image];
    imageView.image = image;
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
          
         
          NSString  *mb = [NSString stringWithFormat:@"%lu",[imageData length]/(1024*1000)];
          
    [_fileSize addObject:@{@"imageName":imageName,@"imageSize":mb}];
    meta = [[[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:@"{TIFF}"] objectForKey:@"DateTime"];


    if (meta == nil) {
            NSDateFormatter *form = [[NSDateFormatter alloc] init];
            form.dateFormat = @"yyyy:MM:dd HH:mm:ss";
            NSString* date = [form stringFromDate:[NSDate date]];
        [_pickImagesandDate addObject:@{@"Image":image,@"Date":date}];
    }
    else
    {
        [_pickImagesandDate addObject:@{@"Image":image,@"Date":meta}];

    }
  
    
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
   // [_listTable reloadData]; // tell table to refresh now

    if(image != nil){

        PreviewerController * previewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewerController"];
        previewVC.sourceImageArray = _pickImagesandDate;
        previewVC.Previewimg = image;
        previewVC.isDocStore = true;
        previewVC.imageupdateDelegate = self;
        previewVC.categoryname = self.categoryname;
        previewVC.documentName = self.documentName;
        previewVC.documentId = self.documentId;
        previewVC.workflowId = self.workflowId;
        previewVC.uploadAttachment = self.uploadAttachment;
        previewVC.post = self.post;
        UINavigationController *objNavigationController = [[UINavigationController alloc]initWithRootViewController:previewVC];
        objNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
       // [self presentViewController:objNavigationController animated:true completion:nil];
       [self.navigationController pushViewController:previewVC animated:true];
        
    }
    
}


//-(void)imageFromScanner:(UIImage *)image
//{

//    image = [info valueForKey:UIImagePickerControllerOriginalImage];
//    //self.imgForDisplay.image=[self scaleAndRotateImage:image];
//    image = [self scaleAndRotateImage:image];
//    imageView.image = image;
//
//    meta = [[[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:@"{TIFF}"] objectForKey:@"DateTime"];
//
//    if (meta == nil) {
//            NSDateFormatter *form = [[NSDateFormatter alloc] init];
//            form.dateFormat = @"yyyy:MM:dd HH:mm:ss";
//            NSString* date = [form stringFromDate:[NSDate date]];
//        [_pickImagesandDate addObject:@{@"Image":image,@"Date":date}];
//    }
//    else
//    {
//        [_pickImagesandDate addObject:@{@"Image":image,@"Date":meta}];
//
//    }
//
//    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
//   // [_listTable reloadData]; // tell table to refresh now
//
//    if(image != nil){
//
//        PreviewerController * previewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewerController"];
//        previewVC.sourceImageArray = _pickImagesandDate;
//        previewVC.Previewimg = image;
//        previewVC.imageupdateDelegate = self;
//        previewVC.categoryname = self.categoryname;
//        previewVC.documentName = self.documentName;
//        UINavigationController *objNavigationController = [[UINavigationController alloc]initWithRootViewController:previewVC];
//       // [self presentViewController:objNavigationController animated:true completion:nil];
//       [self.navigationController pushViewController:previewVC animated:true];
//
//    }
//
//}


- (UIImage *) scaleAndRotateImage: (UIImage *)image
{
    int kMaxResolution = 3000; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef),      CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    image = croppedImage;
    imageView.image = croppedImage;
  //  UIImageView *pick;
    
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
   // self.pick.image = image;
    
    CGRect cropArea = controller.cropArea;
    PreviewerController * previewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewerController"];
    previewVC.previewimage.image = image;
    previewVC.imageupdateDelegate = self;
    previewVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:previewVC animated:true];
    
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller
{
    imageView.image = image;
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail!"
                                                        message:[NSString stringWithFormat:@"Saved with error %@", error.description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succes!"
                                                        message:@"Saved to camera roll"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}



#pragma mark- Open Document Picker(Delegate) for PDF, DOC Slection from iCloud


- (void)showDocumentPickerInMode:(UIDocumentPickerMode)mode
{
    
    UIDocumentPickerViewController *picker =  [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"com.adobe.pdf"] inMode:UIDocumentPickerModeImport];
    
    picker.delegate = self;
    
    //picker.allowsMultipleSelection = YES;
    picker.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
//    [self presentViewController:picker animated:YES completion:^{
//        if (@available(iOS 11.0, *)) {
//            picker.allowsMultipleSelection = YES;
//        }
//    }];
    
}


-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker
{
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller
  didPickDocumentAtURL:(NSURL *)url
{
    PDFUrl= url;
    UploadType=@"PDF";
    [arrimg removeAllObjects];
    [arrimg addObject:url];
   
    NSLog(@"%@",url.lastPathComponent);

    NSData *data2 = [NSData dataWithContentsOfURL:url];
    NSString *path = [url path];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    NSData *dataPdf = [[NSData alloc]initWithBase64EncodedString:base64Encoded options:0];

    pdfDocument = [[PDFDocument alloc] initWithData:dataPdf];
    NSLog(@"%lu%@",(unsigned long)pdfDocument.pageCount,pdfDocument.documentAttributes);
    
    UIStoryboard *newStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowPdfForImages *sendPdfData = [[ShowPdfForImages alloc]init];
    sendPdfData.documentName = url.lastPathComponent;
    sendPdfData.categoryname = _categoryname;
    sendPdfData.imgPdfString = base64Encoded;
    [self.navigationController pushViewController: sendPdfData animated:YES];
    
    
    //[self dismissViewControllerAnimated:YES completion:^{
        
        // UploadDocuments *objTrackOrderVC= [newStoryBoard instantiateViewControllerWithIdentifier:@"UploadDocuments"];
        ////UINavigationController *objNavigationController = [[UINavigationController alloc]initWithRootViewController:sendPdfData];
       // [self presentViewController:objNavigationController animated:true completion:nil];

   // }];
   
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"parametersNotification" object:senddict];
    //[self.navigationController popViewControllerAnimated:true];
    
}

#pragma mark- Open Image Picker Delegate to select image from Gallery or Camera
//- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//
//    UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//
//    UploadType=@"Image";
//    [arrimg removeAllObjects];
//    [arrimg addObject:myImage];
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//
//
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - tableview data source and delegates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_pickImagesandDate.count == 0) {
        _isSelctd = true;
    } else {
        _isSelctd = false;
    }

    
    if (_pickImagesandDate.count == 0) {
        
      noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.listTable.bounds.size.width, self.listTable.bounds.size.height)];
        noDataLabel.text             = @"Upload a document using + button to get started.";
        noDataLabel.numberOfLines = 2;
        noDataLabel.textColor        = [UIColor grayColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.listTable.backgroundView = noDataLabel;
        self.listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        noDataLabel.hidden = true;
        return _pickImagesandDate.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ImagelistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImagelistCell" forIndexPath:indexPath];
   // Documents *beverage = _arrayForDelegate[indexPath.row];
   // NSArray * arr  = beverage.document;
    
    if (_pickImagesandDate == nil)
     {
        cell.ImageList.image = _blurredImageView.image;//[[_catureImagesForListView objectAtIndex:indexPath.row]valueForKey:@"Image"];
    }
    else
    {
        //cell.ImageList.image = [[arr objectAtIndex:indexPath.row]valueForKey:@"Image"];
        cell.ImageList.image =  [_pickImagesandDate[indexPath.row] valueForKey:@"Image"];
       // cell.ImageList.image = [[arr objectAtIndex:indexPath.row] valueForKey:@"Image"];
    }

    NSString *sizeInMB = [NSString stringWithFormat:@"%@",[[_fileSize objectAtIndex:indexPath.row] valueForKey:@"imageSize"]];
    
    cell.DocumentName.text = [NSString stringWithFormat:@"%@ (%@ MB)",[[_fileSize objectAtIndex:indexPath.row] valueForKey:@"imageName"],sizeInMB];
  
    cell.DateAndTime.text  = [NSString stringWithFormat:@"Page %ld",indexPath.row + 1];
  //cell.DateAndTime.text  =  [[arr objectAtIndex:indexPath.row] valueForKey:@"Date"];
    NSInteger  indexCount = [[[NSUserDefaults standardUserDefaults]valueForKey:@"indexCount"]integerValue];
  //  cell.countLabel.text =[NSString stringWithFormat:@"%lu",(unsigned long)indexPath.row + 1];
    if (indexPath.row == indexCount) {
        cell.countLabel.text =[NSString stringWithFormat:@"%lu",(unsigned long)indexPath.row + 1];

    }

    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_pickImagesandDate removeObjectAtIndex:indexPath.row];
//
//        [tableView reloadData]; // tell table to refresh now
//    }
    if (editingStyle ==
        UITableViewCellEditingStyleDelete) {
        [_pickImagesandDate removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle ==
               UITableViewCellEditingStyleInsert) {
        // Create a new
       // instance of the appropriate class, insert it into the array, and add a new rowto the table view.
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger indexCount = indexPath.row;
    [[NSUserDefaults standardUserDefaults] setInteger:indexCount forKey:@"indexCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   // UIImage *carImage =  [[_pickImagesandDate objectAtIndex:indexPath.row]valueForKey:@"Image"];
   
   
    ShowEditImagesFromImageList *carDetailViewController = [[ShowEditImagesFromImageList alloc] initWithNibName:@"ShowEditImagesFromImageList" bundle:nil];
    carDetailViewController.delegate=self; // protocol listener
    carDetailViewController.sendarray = _sendarray;
    carDetailViewController.showMultImages=[NSMutableArray arrayWithObject:_pickImagesandDate[indexPath.row]] ;
    carDetailViewController.documentName = self.documentName;
    carDetailViewController.categoryname = _categoryname;
    carDetailViewController.uploadAttachment = self.uploadAttachment;
    carDetailViewController.documentId = self.documentId;
    carDetailViewController.workFlowId = _workflowId;
    carDetailViewController.isDocStore = true;
    carDetailViewController.isSelected = true;
    carDetailViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController: carDetailViewController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
    
}

-(void)sendDataToA:(NSMutableDictionary *)dict
{
    // data will come here inside of ViewControllerA
    //[_pickImagesandDate addObject:array];
    NSInteger  indexCount = [[[NSUserDefaults standardUserDefaults]valueForKey:@"indexCount"]integerValue];
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:indexCount inSection:0];
   // [[_pickImagesandDate objectAtIndex:indexPath.row]valueForKey:@"Image"];
   // [_pickImagesandDate replaceObjectAtIndex:rowToReload.row withObject:countArray];
//    Documents * document = [NSEntityDescription insertNewObjectForEntityForName:@"Documents"
//                                                         inManagedObjectContext:_appDelegate.managedObjectContext];
//    document.document = _arrayForDelegate;
    [self.listTable beginUpdates];
    [self.listTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:rowToReload, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.listTable endUpdates];

    [self.delegate sendData:dict];
}
-(void)imageupdater:(NSMutableArray *)ImageArray
{
    _pickImagesandDate = [ImageArray mutableCopy];
    [self.listTable reloadData];
    
}
-(void) sendDataToShowEdit:(NSMutableArray *)addImages
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end