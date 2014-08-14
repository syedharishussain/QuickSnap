//
//  ViewController.m
//  GIFTool
//
//  Created by Haris on 5/11/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"
#import "GIFCollectionViewController.h"
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
#import "RegisterViewController.h"

#import "AFNetworking.h"

#import "GIFManager.h"

@interface ViewController () <CreateGIFProtocol> {
    CreateGIF *create;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    create = [[CreateGIF alloc] init];
    create.delegate = self;
    
    if (![Utils FPS]) {
        [Utils setFPS:@{
                        KEY_FPS         : @10,
                        KEY_SEGMENT     : @1,
                        KEY_INCREMENT   : @3
                        }];
    }
    
    UIImage *image = [UIImage imageNamed:@"icon_01"];
    [self.navigationController.navigationBar.topItem setTitleView:[[UIImageView alloc] initWithImage:image]];
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status != ALAuthorizationStatusAuthorized) {
        //show alert for asking the user to give permission
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        
        [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                               NSLog(@"%li",(long)[group numberOfAssets]);                               
                           } failureBlock:^(NSError *error) {
                               if (error.code == ALAssetsLibraryAccessUserDeniedError) {
                                   NSLog(@"user denied access, code: %li",(long)error.code);
                               }else{
                                   NSLog(@"Other error code: %li",(long)error.code);
                               }
                           }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (![Utils isLoggedIn]) {
        [self performSegueWithIdentifier:@"register" sender:nil];
    } else {
        //        [[GIFManager shared] checkLocalFiles];
    }
}

- (IBAction)mySnap:(id)sender {
    [self performSegueWithIdentifier:@"collection" sender:@YES];
}

- (IBAction)allSnap:(id)sender {
    [self performSegueWithIdentifier:@"collection" sender:@NO];
}

- (IBAction)create:(id)sender {
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"collection"]) {
        GIFCollectionViewController *con = segue.destinationViewController;
        BOOL isMySnap = ((NSNumber*)sender).boolValue;
        con.isMySnaps = isMySnap;
        if (isMySnap) {
            con.gifArray = [[Utils NSDocumentDirfiles] mutableCopy];
        } else {
            NSArray *array = @ [[[NSBundle mainBundle] pathForResource:@"1.gif" ofType:nil],
                                [[NSBundle mainBundle] pathForResource:@"2.gif" ofType:nil]];
            con.gifArray = [array mutableCopy];
        }
    }
}


#pragma mark - GIFCreationProtocol

- (void)GIFCreationComplete:(NSString *)path {
    [[GIFManager shared] checkLocalFiles];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = (NSProgress *)object;
        NSLog(@"Progress… %f", progress.fractionCompleted);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
    [cameraUI setVideoQuality:UIImagePickerControllerQualityType640x480];
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
    
}

#pragma UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = NSTemporaryDirectory();
    NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"video.mp4"];
    
    [Utils removeAllFilesFromNSTemporaryDirectory];
    
    if ([videoData writeToFile:tempPath atomically:NO]) {
        NSLog(@"Video Written Successfully at: %@", tempPath);
        [create convertVideoToImages:tempPath];
//        [self performSelectorInBackground:@selector(createWithDelay:) withObject:tempPath];
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

//- (void)createWithDelay:(NSString *)tempPath {
//    [create convertVideoToImages:tempPath];
//}

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

@end
