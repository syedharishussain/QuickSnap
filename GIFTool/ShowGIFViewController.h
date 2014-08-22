//
//  ShowGIFViewController.h
//  GIFTool
//
//  Created by Haris on 6/26/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLAnimatedImageView;

@interface ShowGIFViewController : UIViewController

@property (nonatomic, assign) BOOL isMySnaps;
@property (nonatomic, assign) BOOL toolBarHidden;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) NSString *shortURL;

@property (strong, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteOutlet;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)share:(id)sender;

- (IBAction)deleteGIF:(id)sender;

@end
