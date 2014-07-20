//
//  PreloadedListViewController.m
//  GIFTool
//
//  Created by Haris on 5/17/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "PreloadedListViewController.h"
#import "PreloadeViewController.h"

@interface PreloadedListViewController ()

@property (nonatomic, retain) NSArray *array;

@end

@implementation PreloadedListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.array = @[@"1.gif", @"2.gif"];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString        *cellIdentifier = @"Cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    label.text = self.array[indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    imageView.image = [UIImage imageNamed:self.array[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showGif" sender:self.array[indexPath.row]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PreloadeViewController  *controller = [segue destinationViewController];
    controller.imageName = sender;
}

@end
