//
//  RecordVideoViewController.h
//  GIFTool
//
//  Created by Haris on 5/12/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "Utils.h"

@interface RecordVideoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *playVideo;
@property (nonatomic, retain) AVAssetImageGenerator *generator;
@property (nonatomic, retain) AVVideoComposition *composition;

- (IBAction)playVideo:(id)sender;

#pragma mark - Record Video
-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate;
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo;

#pragma mark - Play Video
// For opening UIImagePickerController
//-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id )delegate;

@end
