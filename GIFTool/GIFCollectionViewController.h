//
//  GIFCollectionViewController.h
//  GIFTool
//
//  Created by Haris on 6/26/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface GIFCollectionViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) NSMutableArray *gifArray;
@property (nonatomic, assign) BOOL isMySnaps;
@property (nonatomic, retain) NSTimer *timer;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;


- (IBAction)createGIF:(id)sender;

- (BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate;

- (IBAction)logout:(id)sender;
@end
