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
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)sliderValueChange:(id)sender;
- (IBAction)logout:(id)sender;

@end
