//
//  GIFManager.h
//  QuickSnap
//
//  Created by Haris on 7/17/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GIFManagerProtocol <NSObject>

- (void)fileDownloaded;

@end

@interface GIFManager : NSObject

@property (nonatomic, assign) BOOL isAllFilesDownloaded;
@property (nonatomic, retain) NSMutableDictionary *files;
@property (nonatomic, retain) id <GIFManagerProtocol> delegate;

+ (GIFManager *)shared;

- (void)uploadGIF:(NSString*)path;
- (void)getList;
- (void)checkLocalFiles;
- (void)deleteGIF:(NSString*)path;

@end

@interface File : NSObject

@property(nonatomic,retain) NSString * Id;
@property(nonatomic,retain) NSString * fileName;
@property(nonatomic,retain) NSString * fileNameOriginal;
@property(nonatomic,retain) NSString * gifsCreated;
@property(nonatomic,retain) NSString * url;

+ (id) objectWithDictionary:(NSDictionary*)dictionary;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
