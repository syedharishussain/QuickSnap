//
//  SettingsViewController.m
//  QuickSnap
//
//  Created by Haris on 20/07/2014.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "SettingsViewController.h"
#import "Utils.h"
#import "CreateGIF.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"icon_01"];
    [self.navigationController.navigationBar.topItem setTitleView:[[UIImageView alloc] initWithImage:image]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sliderValueChange:(id)sender {
    self.fpsLabel.text = [NSString stringWithFormat:@"%d FPS", (int)self.slider.value];
}

- (IBAction)logout:(id)sender {
    [Utils clearUserData];
    
    [self performSegueWithIdentifier:@"register" sender:nil];
}
@end
