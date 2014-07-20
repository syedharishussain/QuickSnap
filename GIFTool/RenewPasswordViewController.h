//
//  RenewPasswordViewController.h
//  GIFTool
//
//  Created by Haris on 7/11/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenewPasswordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UITextField *retypePasswordTF;

@property (strong, nonatomic) IBOutlet UIButton *done;

@property (nonatomic, retain) NSString *email;

- (IBAction)done:(id)sender;

@end
