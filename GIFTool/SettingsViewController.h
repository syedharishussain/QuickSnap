//
//  SettingsViewController.h
//  QuickSnap
//
//  Created by Haris on 20/07/2014.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *fpsLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UISwitch *saveGIFSwitch;

- (IBAction)sliderValueChange:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)segmentedControllerValueChange:(id)sender;
- (IBAction)switchValueChanged:(id)sender;

@end
