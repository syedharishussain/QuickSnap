//
//  Utils.h
//  GIFTool
//
//  Created by Haris on 5/24/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

#define KEY_FPS             @"key_fps"
#define KEY_SEGMENT         @"key_segment"
#define KEY_INCREMENT       @"key_increment"

+ (void)removeAllFilesFromNSTemporaryDirectory;
+ (void)removeAllFilesFromNSDocumentDirectory;
+ (void)removeFileFromNSDocumentDirectory:(NSString*)fileName;
+ (NSString*)generateFileNameWithExtension:(NSString *)extensionString;
+ (NSArray*)NSDocumentDirfiles;
+ (BOOL)NSStringIsEmpty:(NSString *)string;
+ (BOOL)NSStringIsValidEmail:(NSString *)string;
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

+ (NSString*)userID;
+ (void)setUserID:(NSString*)userID;

+ (NSString*)email;
+ (void)setEmail:(NSString*)email;

+ (BOOL)isLoggedIn;
+ (void)setLoggedIn:(BOOL)loggedIn;

+ (void)setFPS:(NSDictionary *)fps;
+ (NSDictionary *)FPS;

+ (void)clearUserData;

@end

