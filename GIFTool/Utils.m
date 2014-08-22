//
//  Utils.m
//  GIFTool
//
//  Created by Haris on 5/24/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "Utils.h"
#import "GIFManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation Utils

+ (void)removeAllFilesFromNSTemporaryDirectory {
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}


+ (void)removeAllFilesFromNSDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    for (NSString *file in filePathsArray) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], file] error:NULL];
    }
}

+ (void)removeFileFromNSDocumentDirectory:(NSString*)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", filePath]];
    NSError *error;
    [fileManager removeItemAtPath:filePath error:&error];
    if (!error) {
        NSLog(@"file removed");
    } else {
        NSLog(@"Could Not Delet File at:%@ due to error:%@", filePath, error);
    }
}

+ (NSString*)generateFileNameWithExtension:(NSString *)extensionString
{
    // Extenstion string is like @".png"
    
    NSDate *time = [NSDate date];
    NSDateFormatter* df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MM-yyyy-hh-mm-ss"];
    NSString *timeString = [df stringFromDate:time];
    NSString *fileName = [NSString stringWithFormat:@"File-%@%@", timeString, extensionString];
    
    return fileName;
}

+ (NSArray*)NSDocumentDirfiles {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    NSMutableArray *array = [NSMutableArray new];
    
    [filePathsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [array addObject:[documentsDirectory stringByAppendingPathComponent:obj]];
    }];
    
//    NSLog(@"files array %@", array);
    
    return array;
}

+ (NSString *)filenameFromPath:(NSString *)filePath {
    return [[filePath componentsSeparatedByString:@"/"] lastObject];
}

+ (BOOL)NSStringIsEmpty:(NSString *)string {
    return [string isKindOfClass:[NSNull class]] || !string || [string isEqualToString:@""] || string.length <= 0;
}

+ (BOOL)NSStringIsValidEmail:(NSString *)string {
    BOOL        stricterFilter        = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString    *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString    *laxString            = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString    *emailRegex           = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest            = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    [[[UIAlertView alloc]
      initWithTitle:title message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
}

+ (UIImage*)watermarkImage:(UIImage *)image {
    UIImage *backgroundImage = image;
    UIImage *watermarkImage = [UIImage imageNamed:@"icon_01.png"];
    
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    [watermarkImage drawInRect:CGRectMake(backgroundImage.size.width - watermarkImage.size.width, backgroundImage.size.height - watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)createThumbnail:(UIImage *)originalImage withSize:(CGSize)size {
    UIImage *origImage = originalImage;
    CGSize destinationSize = size;
    UIGraphicsBeginImageContext(destinationSize);
    [origImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)saveToPhotoAlbum:(NSString*)path {
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
        NSMutableData *gifData = [NSMutableData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1.gif" ofType:nil]];
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:path];
        NSMutableData *gif89 = [NSMutableData dataWithData:[gifData subdataWithRange:NSMakeRange(0, 6)]];
        [data replaceBytesInRange:NSMakeRange(0, 6) withBytes:gif89.bytes];
        
//        [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
//            if (error) {
//                NSLog(@"Error Saving GIF to Photo Album: %@", error);
//            } else {
//                // TODO: success handling
//                NSLog(@"GIF Saved to %@", assetURL);
//            }
//        }];
    
    [library saveImageData:data toAlbum:@"QuickSnap" metadata:nil completion:^(NSURL *assetURL, NSError *error) {
//        NSLog(@"GIF Saved to %@", assetURL);
    } failure:^(NSError *error) {
         NSLog(@"Error Saving GIF to Photo Album: %@", error);
    }];
    
}

+ (NSString*)userID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
}
+ (void)setUserID:(NSString*)userID {
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)email {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
}
+ (void)setEmail:(NSString*)email {
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (BOOL)isLoggedIn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"];
}
+ (void)setLoggedIn:(BOOL)loggedIn {
    [[NSUserDefaults standardUserDefaults] setBool:loggedIn forKey:@"isLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearUserData {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedIn"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"shouldSaveToPhotoAlbum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableSet *set = [GIFManager shared].downloadtasks;
    
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSURLSessionDataTask* task = obj;
        [task cancel];
    }];
    
    [[GIFManager shared].downloadtasks removeAllObjects];
    
    [GIFManager shared].files = [NSMutableDictionary new];
    
    [Utils removeAllFilesFromNSDocumentDirectory];
}

+ (void)setFPS:(NSDictionary *)fps {
    [[NSUserDefaults standardUserDefaults] setObject:fps forKey:@"fps"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)FPS {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"fps"];
}

+ (BOOL)shouldSaveToPhotoAlbum {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldSaveToPhotoAlbum"];
}
+ (void)setSaveToPhotoAlbum:(BOOL)shouldSave {
    [[NSUserDefaults standardUserDefaults] setBool:shouldSave forKey:@"shouldSaveToPhotoAlbum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
