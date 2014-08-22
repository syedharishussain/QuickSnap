//
//  ForgetPasswordViewController.m
//  GIFTool
//
//  Created by Haris on 7/11/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "Utils.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "RenewPasswordViewController.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"icon_01"];
    [self.navigationController.navigationBar.topItem setTitleView:[[UIImageView alloc] initWithImage:image]];
}

- (IBAction)submitEmail:(id)sender {
    if (![Utils NSStringIsValidEmail:self.emailTF.text]) {
        [Utils showAlertWithTitle:@"Invalid Email" andMessage:@"Please enter a valid email address!"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Loading.."];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"key": @"123456789",
                                 @"get": @"forget",
                                 @"email": self.emailTF.text};
    
    
    [manager POST:@"http://aceist.com/gifs/api.php"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [SVProgressHUD dismiss];
              
              NSNumber * success = responseObject[@"header"][@"status"];
              
              if (success.boolValue) {
                  [Utils showAlertWithTitle:nil andMessage:responseObject[@"header"][@"message"]];
                  [self dismissViewControllerAnimated:YES completion:nil];
              } else {
                  [Utils showAlertWithTitle:nil andMessage:responseObject[@"header"][@"message"]];
              }
              
//              NSLog(@"JSON: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [SVProgressHUD dismiss];
              [Utils showAlertWithTitle:nil andMessage:error.localizedDescription];
              NSLog(@"Error: %@", error);
          }];
}

- (IBAction)submitCode:(id)sender {
    
    if ([Utils NSStringIsEmpty:self.codeTF.text]) {
        [Utils showAlertWithTitle:@"Invalid Code" andMessage:@"This field can not be empty!"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Checking.."];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"key": @"123456789",
                                 @"get": @"check_code",
                                 @"forgot": self.codeTF.text};
    
    
    [manager POST:@"http://aceist.com/gifs/api.php"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [SVProgressHUD dismiss];
              
              NSNumber * success = responseObject[@"header"][@"status"];
              
              if (success.boolValue) {
                  [Utils showAlertWithTitle:nil andMessage:responseObject[@"header"][@"message"]];
                  [self performSegueWithIdentifier:@"renew" sender:nil];
              } else {
                  [Utils showAlertWithTitle:nil andMessage:responseObject[@"header"][@"message"]];
              }
              
//              NSLog(@"JSON: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [SVProgressHUD dismiss];
              [Utils showAlertWithTitle:nil andMessage:error.localizedDescription];
          }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"renew"]) {
//        RenewPasswordViewController *controller = [segue destinationViewController];
//        controller.email =
//    }
}
@end
