//
//  LoginViewController.h
//  GIFTool
//
//  Created by Haris on 7/11/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *loginTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

- (IBAction)login:(id)sender;
- (IBAction)forgetPassword:(id)sender;

@end
