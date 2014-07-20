//
//  ForgetPasswordViewController.h
//  GIFTool
//
//  Created by Haris on 7/11/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *codeTF;

- (IBAction)submitEmail:(id)sender;
- (IBAction)submitCode:(id)sender;

@end
