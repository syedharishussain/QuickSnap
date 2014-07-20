//
//  PreloadeViewController.h
//  GIFTool
//
//  Created by Haris on 5/11/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLImageView.h"

@interface PreloadeViewController : UIViewController

@property (nonatomic, retain) NSString *imageName;

@property (strong, nonatomic) IBOutlet OLImageView *imageView1;
@property (strong, nonatomic) IBOutlet OLImageView *imageView2;
@end
