//
//  RecordVideoViewController.m
//  GIFTool
//
//  Created by Haris on 5/12/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "RecordVideoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

#import "HJImagesToGIF.h"
#import <MessageUI/MessageUI.h>

#import "SVProgressHUD.h"

static NSMutableArray *gifs;

@interface RecordVideoViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) NSMutableArray *filePathArray;

@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSString *videoPath;

@end

@implementation RecordVideoViewController

@synthesize generator, composition;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status != ALAuthorizationStatusAuthorized) {
        //show alert for asking the user to give permission
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        
        [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playVideo:(id)sender {
//    [self convertVideoToImages:nil];
    
    [self startCameraControllerFromViewController:self usingDelegate:self];
    
    // For Playing Video
    //    [self startMediaBrowserFromViewController:self usingDelegate:self];
    
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/video.mp4"];
    
    if ([videoData writeToFile:tempPath atomically:NO]) {
        NSLog(@"Video Written Successfully at: %@", tempPath);
        [self convertVideoToImages:tempPath];
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

- (void)convertVideoToImages:(NSString*)path {
    
//    [SVProgressHUD showWithStatus:@"Encoding GIF" maskType:SVProgressHUDMaskTypeGradient];
    
    [Utils removeAllFilesFromNSTemporaryDirectory];
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    
    //setting up generator & compositor
    self.generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    
    //    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    self.generator.requestedTimeToleranceBefore = kCMTimeZero;
    self.generator.requestedTimeToleranceAfter = kCMTimeZero;
    
    generator.appliesPreferredTrackTransform = YES;
    self.composition = [AVVideoComposition videoCompositionWithPropertiesOfAsset:asset];
    
    NSTimeInterval duration = CMTimeGetSeconds(asset.duration);
    NSTimeInterval frameDuration = CMTimeGetSeconds(composition.frameDuration);
    CGFloat totalFrames = round(duration/frameDuration);
    
    NSLog(@"Frames: %@",[NSString stringWithFormat:@"%.2f Frames",totalFrames]);
    NSLog(@"Vdo Duration: %@", [NSString stringWithFormat:@"Video Duration : %f",duration]);
    
    NSMutableArray * times = [[NSMutableArray alloc] init];
    
    // *** Fetch First 200 frames only ***
    for (int i=0; i<totalFrames; i++) {
        NSValue * time = [NSValue valueWithCMTime:CMTimeMakeWithSeconds(i*frameDuration, composition.frameDuration.timescale)];
        [times addObject:time];
        i++;
    }

    self.filePathArray = [NSMutableArray new];
    __block NSInteger count = 0;
    __block int imageCount = 0;
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){

            if (result == AVAssetImageGeneratorSucceeded) {
                imageCount++;
                NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                docDir = NSTemporaryDirectory();
                NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.jpg",CMTimeGetSeconds(requestedTime)]];
                [UIImageJPEGRepresentation([UIImage imageWithCGImage:im], 0.5f) writeToFile:filePath atomically:YES];
                count++;
                [self performSelector:@selector(updateStatusWithFrame:) onThread:[NSThread mainThread] withObject:[NSString stringWithFormat:@"Processing %ld of %.0f",(long)count,totalFrames] waitUntilDone:NO];
                [self.filePathArray addObject:[UIImage imageWithContentsOfFile:filePath]];
                if (imageCount >= times.count) {
                    [self createGIF:path];
                }
            }
            else if(result == AVAssetImageGeneratorFailed)
                NSLog(@"Failed to Extract");
            else if(result == AVAssetImageGeneratorCancelled)
                NSLog(@"Process Cancelled");
    };
    
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    [generator generateCGImagesAsynchronouslyForTimes:times completionHandler:handler];
}

- (void)createGIF:(NSString*)videoPath {
    NSLog(@"---------GIF CREATION STARTED----------");
    [HJImagesToGIF saveGIFToPhotoAlbumFromImages:self.filePathArray success:^(NSString *filePath) {
        self.data = [NSData dataWithContentsOfFile:filePath];
        self.videoPath = videoPath;
        
        [Utils removeFileFromNSDocumentDirectory:self.videoPath];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send QuickSnap to Friends?"
                                                        message:@"How do you want to send the newly recorded GIF to your freinds?"
                                                       delegate:self
                                              cancelButtonTitle:@"Email"
                                              otherButtonTitles:@"iMessage", nil];
        
        
        
        alert.tag = 100;
        [alert show];
    }];
}

- (void)updateStatusWithFrame:(NSString *)msg
{
    NSLog(@"%@", msg);
}

#pragma mark - PlayVideo

-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id )delegate {
    // 1 - Validations
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    // 2 - Get image picker
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    // 3 - Display image picker
    //    [controller presentModalViewController:mediaUI animated:YES];
    [controller presentViewController:mediaUI animated:YES completion:^{
        
    }];
    return YES;
}

-(void)myMovieFinishedCallback:(NSNotification*)aNotification {
    [self dismissMoviePlayerViewControllerAnimated];
    MPMoviePlayerController* theMovie = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Email

- (void)email {
    MFMailComposeViewController * compose = [[MFMailComposeViewController alloc] init];
    [compose setSubject:@"Gif Image"];
    [compose setMessageBody:@"I have kindly attached a GIF image to this E-mail. I made this GIF using ANGif, an open source Objective-C library for exporting animated GIFs." isHTML:NO];
    [compose addAttachmentData:self.data mimeType:@"image/gif" fileName:@"image.gif"];
    [compose setMailComposeDelegate:self];
    [self presentViewController:compose animated:YES completion:^{
//        [SVProgressHUD dismiss];
        
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Messages

- (void)sendMMS:(NSString*)file {
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    NSArray *recipents = @[@"syedharishussain@gmail.com"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:nil];
    
    if([MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)] && [MFMessageComposeViewController canSendAttachments]) {
        NSString* uti = (NSString*)kUTTypeMessage;
        [messageController addAttachmentData:self.data typeIdentifier:uti filename:@"QuickSnap.gif"];
    }
    
    [self presentViewController:messageController animated:YES completion:^{
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Alertview delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        switch (buttonIndex) {
            case 0:
                [self email];
                break;
            case 1:
                [self sendMMS:@""];
                break;
                
            default:
                break;
        }
    }
}

@end
