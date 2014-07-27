//
//  CreateGIF.m
//  GIFTool
//
//  Created by Haris on 6/26/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

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

@implementation CreateGIF

@synthesize generator, composition;

#pragma mark - Convert Video to Images

- (void)convertVideoToImages:(NSString*)path {    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    
    //setting up generator & compositor
    self.generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    
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
    
    int increment = ((NSNumber*)[Utils FPS][KEY_INCREMENT]).intValue;
    
    // *** Fetch First 200 frames only ***
    for (int i=0; i<totalFrames; i+=increment) {
        NSValue * time = [NSValue valueWithCMTime:CMTimeMakeWithSeconds(i*frameDuration, composition.frameDuration.timescale)];
        [times addObject:time];
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
            [self.filePathArray addObject:[Utils watermarkImage:[UIImage imageWithContentsOfFile:filePath]]];
            if (imageCount >= times.count) {
                [self convertImageArrayToGIF:path];
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

- (void)updateStatusWithFrame:(NSString *)msg
{
    NSLog(@"%@", msg);
}

#pragma mark - Convert Images to GIF

- (void)convertImageArrayToGIF:(NSString*)videoPath {
    NSLog(@"---------GIF CREATION STARTED----------");
//    [SVProgressHUD showWithStatus:@"Creating GIF.."];
    [HJImagesToGIF saveGIFToPhotoAlbumFromImages:self.filePathArray success:^(NSString *filePath) {
//        [SVProgressHUD dismiss];
        self.data = [NSData dataWithContentsOfFile:filePath];
        self.videoPath = videoPath;
        
        [Utils removeFileFromNSDocumentDirectory:self.videoPath];
        [GIFManager shared].isAllFilesDownloaded = NO;
        [self.delegate GIFCreationComplete:filePath];
    }];
}


@end
