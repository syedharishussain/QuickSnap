//
//  PreloadeViewController.m
//  GIFTool
//
//  Created by Haris on 5/11/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "PreloadeViewController.h"
#import "OLImage.h"

@interface PreloadeViewController ()

@end

@implementation PreloadeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.imageView1.image = [OLImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.imageName ofType:nil]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
