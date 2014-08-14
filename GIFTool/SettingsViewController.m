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
#import "ViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize segmentedController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"icon_01"];
    [self.navigationController.navigationBar.topItem setTitleView:[[UIImageView alloc] initWithImage:image]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLoginNotification:)
                                                 name:@"loginNotification"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([Utils FPS][KEY_SEGMENT])
        segmentedController.selectedSegmentIndex = ((NSNumber*)[Utils FPS][KEY_SEGMENT]).integerValue;
    
    [self.saveGIFSwitch setOn:[Utils shouldSaveToPhotoAlbum]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if ([Utils FPS][KEY_SEGMENT])
//        segmentedController.selectedSegmentIndex = ((NSNumber*)[Utils FPS][KEY_SEGMENT]).integerValue;
//    
//    [self.saveGIFSwitch setOn:[Utils shouldSaveToPhotoAlbum]];
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

- (IBAction)segmentedControllerValueChange:(id)sender {
    self.fpsLabel.text = [NSString stringWithFormat:@"%@", [segmentedController titleForSegmentAtIndex:segmentedController.selectedSegmentIndex]];
    NSDictionary *dic = [NSDictionary new];
    switch (segmentedController.selectedSegmentIndex) {
        case 0:{
            dic = @{
                    KEY_FPS         : @5,
                    KEY_SEGMENT     : @0,
                    KEY_INCREMENT   : @6
                    };
            break;
        }
        case 1:{
            dic = @{
                    KEY_FPS         : @10,
                    KEY_SEGMENT     : @1,
                    KEY_INCREMENT   : @3
                    };
            break;
        }
        case 2:{
            dic = @{
                    KEY_FPS         : @15,
                    KEY_SEGMENT     : @2,
                    KEY_INCREMENT   : @2
                    };
            break;
        }
            
        default:
            break;
    }
    
    [Utils setFPS:dic];
}

- (IBAction)switchValueChanged:(id)sender {
    [Utils setSaveToPhotoAlbum:self.saveGIFSwitch.isOn];
}

#pragma mark - notification 

- (void) receiveLoginNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"loginNotification"]){
        NSLog (@"Successfully received the test notification!");
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[ViewController class]]) {
                [self.navigationController popToViewController:obj animated:YES];
            }
        }];
    }
}

#pragma mark - dealloc

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
