//
//  AppDelegate.m
//  GIFTool
//
//  Created by Haris on 5/11/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "AppDelegate.h"
#import "GIFManager.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    [IMGSession authenticatedSessionWithClientID:@"59330fa14b59648"
//                                          secret:@"9db9d249d45049f00bd91310415738270d502c2e"
//                                        authType:IMGCodeAuth
//                                    withDelegate:self];
    
    [IMGSession anonymousSessionWithClientID:@"59330fa14b59648" withDelegate:self];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [[GIFManager shared] getList];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - IMGSessionDelegate

//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    
//    //app must register url scheme which starts the app at this endpoint with the url containing the code
//    
//    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    for (NSString *param in [[url query] componentsSeparatedByString:@"&"]) {
//        NSArray *elts = [param componentsSeparatedByString:@"="];
//        if([elts count] < 2) continue;
//        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
//    }
//    
//    NSString * pinCode = params[@"code"];
//    
//    if(!pinCode){
//        NSLog(@"error: %@", params[@"error"]);
//        
////        self.continueHandler = nil;
//        
//        UIAlertView * a = [[UIAlertView alloc] initWithTitle:@"error" message:@"Access was denied by Imgur" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Try Again",nil];
//        [a show];
//        
//        return NO;
//    }
//    
//    [[IMGSession sharedInstance] authenticateWithCode:pinCode];
//    
////    if(_continueHandler)
////        self.continueHandler();
//    
//    
//    return YES;
//}

//-(void)imgurSessionNeedsExternalWebview:(NSURL *)url completion:(void (^)())completion{
//    
//    //open imgur website to authenticate with callback url in safari
//    [[UIApplication sharedApplication] openURL:url];
//    
//    //save the completion block for later use when imgur responds with url callback
//}

@end
