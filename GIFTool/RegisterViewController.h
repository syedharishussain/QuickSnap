//
//  RegisterViewController.h
//  GIFTool
//
//  Created by Haris on 7/11/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UITextField *retypePasswordTF;

- (IBAction)registerEmail:(id)sender;
- (IBAction)login:(id)sender;

@end
