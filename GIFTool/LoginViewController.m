//
//  LoginViewController.m
//  GIFTool
//
//  Created by Haris on 7/11/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPasswordViewController.h"
#import "Utils.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "GIFManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"icon_01"];
    [self.navigationController.navigationBar.topItem setTitleView:[[UIImageView alloc] initWithImage:image]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    
    if (![Utils NSStringIsValidEmail:self.loginTF.text]) {
        [Utils showAlertWithTitle:@"Invalid Email" andMessage:@"Please enter a valid email address!"];
        return;
    }
    
    if ([Utils NSStringIsEmpty:self.passwordTF.text] || self.passwordTF.text.length < 8) {
        [Utils showAlertWithTitle:@"Invalid Password" andMessage:@"Password can not be less then 8 characters!"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Logging In.."];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"key": @"123456789",
                                 @"get": @"login",
                                 @"email": self.loginTF.text,
                                 @"password": self.passwordTF.text};
    
    
    [manager POST:@"http://aceist.com/gifs/api.php"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [SVProgressHUD dismiss];
              
              NSNumber * success = responseObject[@"header"][@"status"];
              
              if (success.boolValue) {
                  [Utils setUserID:responseObject[@"body"][@"user"][@"id"]];
                  [Utils setEmail:responseObject[@"body"][@"user"][@"email"]];
                  [Utils setLoggedIn:YES];
                  
                  [Utils showAlertWithTitle:nil andMessage:responseObject[@"header"][@"message"]];
                  [[GIFManager shared] getList];
                  
                  [self dismissViewControllerAnimated:YES completion:nil];                  
              } else {
                  [Utils showAlertWithTitle:nil andMessage:responseObject[@"header"][@"message"]];
              }
              
              NSLog(@"JSON: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [SVProgressHUD dismiss];
              [Utils showAlertWithTitle:nil andMessage:error.localizedDescription];
              NSLog(@"Error: %@", error);
          }];
}

- (IBAction)forgetPassword:(id)sender {
    [self performSegueWithIdentifier:@"forget" sender:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
