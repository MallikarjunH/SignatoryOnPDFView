//
//  CustomPopOverVC.m
//  emSigner
//
//  Created by Administrator on 8/2/16.
//  Copyright © 2016 Emudhra. All rights reserved.
//

#import "CustomPopOverVC.h"
#import "WebserviceManager.h"
#import "HoursConstants.h"
#import "NSObject+Activity.h"
#import "MBProgressHUD.h"
#import "MultiplePdfViewerVC.h"
@interface CustomPopOverVC ()

@end

@implementation CustomPopOverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //_tableView.backgroundColor = [UIColor colorWithRed:0.0/210 green:96.0/210 blue:192.0/210 alpha:1.0];
    if ([_documentCount intValue] >= 1){
        _documentInfoArray = [[NSArray alloc]initWithObjects:@"Documents",@"View Attachments", nil];
    }
    else{
         _documentInfoArray = [[NSArray alloc]initWithObjects:@"View Attachments", nil];
    }
    
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    
    
    return _documentInfoArray.count;
    //new scenario
//    if ([_documentCount intValue] >=1){
//        return 2;
//    }else
//    {
//        return 1;
//
//    }
    
    
    //old scenario
   // if ([_documentCount intValue] == 1  && [_attachmentCount intValue] > 0) {
      //  return 1;
   // }
    
//    else{
//        if ([_attachmentCount intValue] > 0) {
//             return [_documentInfoArray count];
//        }
//        else{
//            return 1;
//        }
//
//    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
   // cell.backgroundColor = [UIColor colorWithRed:26.0f/255.0f green:128.0f/255.0f blue:224.0f/255.0f alpha:1.0f];
    cell.textLabel.textColor = [UIColor blackColor];
   // if  ([_documentCount intValue] >= 1 ) {//&& [_attachmentCount intValue] > 0
        cell.textLabel.text = [_documentInfoArray objectAtIndex:indexPath.row];
   // }
    
   // else {
//        if ([_attachmentCount intValue] > 0) {
//            cell.textLabel.text = [_documentInfoArray objectAtIndex:indexPath.row];
//        }
//        else{
//            cell.textLabel.text = [_documentInfoArray objectAtIndex:0];
//        }
//    }
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_documentCount intValue] == 1 && [_attachmentCount intValue] > 0 ) {
        [self.delegate dissmissCellPopup:1];
    }
    
    else{
        if ( [_attachmentCount intValue] > 0) {
            [self.delegate dissmissCellPopup:indexPath.row];
        }
        else{
            
            [self.delegate dissmissCellPopup:0];
        }
        
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
