//
//  ViewController.h
//  GIFTool
//
//  Created by Haris on 5/11/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *createGIF;
@property (strong, nonatomic) IBOutlet UIButton *logout;

- (IBAction)mySnap:(id)sender;
- (IBAction)allSnap:(id)sender;

- (IBAction)create:(id)sender;

-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate;

@end
