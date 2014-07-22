//
//  GIFCollectionViewController.m
//  GIFTool
//
//  Created by Haris on 6/26/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "GIFCollectionViewController.h"
#import "Utils.h"
#import "ShowGIFViewController.h"
#import "CreateGIF.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "CreateGIF.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

#import "HJImagesToGIF.h"
#import <MessageUI/MessageUI.h>

#import "SVProgressHUD.h"

#import "GIFManager.h"

@interface GIFCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, CreateGIFProtocol, GIFManagerProtocol> {
    CreateGIF *create;
}


@end

@implementation GIFCollectionViewController 

@synthesize gifArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"icon_01"];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    create = [[CreateGIF alloc] init];
    create.delegate = self;
    
    [GIFManager shared].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.titleLabel.text = (self.isMySnaps) ? @"My GIFs" : @"All GIFs";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isMySnaps) {
        gifArray = [[Utils NSDocumentDirfiles] mutableCopy];
    }
}

- (IBAction)createGIF:(id)sender {
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return gifArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:1];
    recipeImageView.image = [UIImage imageWithContentsOfFile:[gifArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        // Determine the selected items by using the indexPath
        NSString *selectedImage = gifArray[indexPath.row];
        // Add the selected item into the array
    [self performSegueWithIdentifier:@"showGIF" sender:selectedImage];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showGIF"]) {
        ShowGIFViewController *con = segue.destinationViewController;
        con.imagePath = sender;
        con.isMySnaps = self.isMySnaps;
    }
}

#pragma mark - GIFCreationProtocol

- (void)GIFCreationComplete:(NSString *)path {
    
    [[GIFManager shared] checkLocalFiles];
    
    if (self.isMySnaps) {
        [gifArray addObject:path];
        [self.collectionView reloadData];
    }
}

#pragma mark - Record Video

-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate {
    // 1 - Validattions
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    
    // 2 - Get image picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    [cameraUI setVideoMaximumDuration:5.0f];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    // 3 - Display image picker
    [controller presentViewController:cameraUI animated:YES completion:^{
        
    }];
    return YES;
}

- (IBAction)logout:(id)sender {
    
    [Utils clearUserData];
    
    [self performSegueWithIdentifier:@"register" sender:nil];
}

#pragma UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = NSTemporaryDirectory();
    NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/video.mp4"];
    
    [Utils removeAllFilesFromNSTemporaryDirectory];

    
    if ([videoData writeToFile:tempPath atomically:NO]) {
        NSLog(@"Video Written Successfully at: %@", tempPath);
        [create convertVideoToImages:tempPath];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath = (NSString*)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self,
                                                @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - GIF Manager Protocol 

- (void)fileDownloaded {
    if (self.isMySnaps) {
        self.gifArray = [[Utils NSDocumentDirfiles] mutableCopy];
        [self.collectionView reloadData];
    }
}

@end
