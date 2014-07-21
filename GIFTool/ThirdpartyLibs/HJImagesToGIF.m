//
//  HJImagesToGIF.m
//  HJImagesToGIF
//
//  Created by Harrison Jackson on 8/6/13.
//  Copyright (c) 2013 Harrison Jackson. All rights reserved.
//

#import "HJImagesToGIF.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import "Utils.h"
#import "SVProgressHUD.h"

@implementation HJImagesToGIF

+(void)saveGIFFromImages:(NSArray*)images toPath:(NSString *)path WithCallbackBlock:(void (^)(void))callbackBlock{
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    
    float delayFactor = ((NSNumber*)[Utils FPS][KEY_FPS]).floatValue;
    
    float delay = 1.0/delayFactor;

    NSDictionary *prep = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:delay] forKey:(NSString *) kCGImagePropertyGIFDelayTime] forKey:(NSString *) kCGImagePropertyGIFDictionary];
    
//    static NSUInteger kFrameCount = 16;
    
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    
    CGImageDestinationRef dst = CGImageDestinationCreateWithURL(url, kUTTypeGIF, [images count], nil);
    CGImageDestinationSetProperties(dst, (__bridge CFDictionaryRef)fileProperties);
    
    for (int i=0;i<[images count];i++)
    {
        //load anImage from array
        UIImage * anImage = [images objectAtIndex:i];
        
        CGImageDestinationAddImage(dst, anImage.CGImage,(__bridge CFDictionaryRef)(prep));
        
    }
    
    bool fileSave = CGImageDestinationFinalize(dst);
    CFRelease(dst);
    if(fileSave) {
        NSLog(@"animated GIF file created at %@", path);
    }else{
        NSLog(@"error: no animated GIF file created at %@", path);
    }
}
+(void)saveGIFToPhotoAlbumFromImages:(NSArray*)images WithCallbackBlock:(void (^)(void))callbackBlock{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *tempPath = [docDir stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"hj_temp.gif"]];

    [HJImagesToGIF saveGIFFromImages:images toPath:tempPath WithCallbackBlock:callbackBlock];
//    UIImage * gif_image = [UIImage imageWithContentsOfFile:tempPath];
//    UIImageWriteToSavedPhotosAlbum(gif_image, self, nil, nil);
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempPath]];
    data = [NSData dataWithContentsOfFile:tempPath];
    
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"Error Saving GIF to Photo Album: %@", error);
        } else {
            // TODO: success handling
            NSLog(@"GIF Saved to %@", assetURL);
        }
    }];
}

+ (void)saveGIFToPhotoAlbumFromImages:(NSArray *)images success:(void (^)(NSString *filePath))success {
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

    NSString *tempPath = [docDir stringByAppendingPathComponent:
                          [Utils generateFileNameWithExtension:@".gif"]];
    
    [HJImagesToGIF saveGIFFromImages:images toPath:tempPath WithCallbackBlock:nil];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSData *data = [NSData dataWithContentsOfFile:tempPath];
    
    [SVProgressHUD dismiss];
    
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"Error Saving GIF to Photo Album: %@", error);
        } else {
            // TODO: success handling
            NSLog(@"GIF Saved to %@", assetURL);
            
            success(tempPath);
        }
    }];

}



@end
