//
//  CreateGIF.h
//  GIFTool
//
//  Created by Haris on 6/26/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "Utils.h"

@protocol CreateGIFProtocol <NSObject>

- (void)GIFCreationComplete:(NSString*)path;

@end

@interface CreateGIF : NSObject 

@property (nonatomic, retain) id<CreateGIFProtocol>delegate;

@property (nonatomic, retain) NSMutableArray *filePathArray;

@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSString *videoPath;

@property (nonatomic, retain) AVAssetImageGenerator *generator;
@property (nonatomic, retain) AVVideoComposition *composition;

- (void)convertVideoToImages:(NSString*)path;

@end
