//
//  ShowGIFViewController.m
//  GIFTool
//
//  Created by Haris on 6/26/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "ShowGIFViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import "OLImageView.h"
#import "Utils.h"
#import "OLImage.h"
#import <MessageUI/MessageUI.h>
#import "GIFManager.h"

@interface ShowGIFViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate>

@end

@implementation ShowGIFViewController

@synthesize toolBarHidden;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleNavigationBar:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    
    [self.imageView setUserInteractionEnabled:YES];
    
    self.imageView.image = [OLImage imageWithData:[NSData dataWithContentsOfFile:self.imagePath]];
    
    UIImage *image = [UIImage imageNamed:@"icon_01"];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    
    if (!self.isMySnaps)
        [self.deleteOutlet setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (IBAction)share:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"share QuickSnap"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Email", @"iMessage", nil]; //@"twitter", nil];
    [actionsheet showInView:self.view];
}

- (IBAction)deleteGIF:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete QuickSnap"
                                                        message:@"Are you sure you want to delete QuickSnap?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Delete",
                              nil];
    alertView.tag = 100;
    [alertView show];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - UIAlertView Delete 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{
            
            break;
        }
        case 1:{ 
            NSLog(@"%@", self.imagePath);
            [[GIFManager shared] deleteGIF:self.imagePath completionHandler:^{
                if ([self.navigationController isNavigationBarHidden])
                    [self.navigationController setNavigationBarHidden:NO animated:YES];
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            break;
        }
      
        default:
            break;
    }

}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{ //email
            [self email];
            break;
        }
        case 1:{ //iMessage
            [self sendMMS:nil];
            break;
        }
//        case 2:{ //Twitter
//            [self shareOnTwitter];
//            break;
//        }
        case 2:{ // cancel
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - Email

- (void)email {
    MFMailComposeViewController * compose = [[MFMailComposeViewController alloc] init];
    [compose setSubject:@"Quick Snap"];
    [compose setMessageBody:@"" isHTML:NO];
    [compose addAttachmentData:[NSData dataWithContentsOfFile:self.imagePath] mimeType:@"image/gif" fileName:@"image.gif"];
    [compose setMailComposeDelegate:self];
    [self presentViewController:compose animated:YES completion:^{
        //        [SVProgressHUD dismiss];
        
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - iMessage

- (void)sendMMS:(NSString*)file {
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    NSArray *recipents = @[];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:nil];
    
    if([MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)] && [MFMessageComposeViewController canSendAttachments]) {
        NSString* uti = (NSString*)kUTTypeMessage;
        [messageController addAttachmentData:[NSData dataWithContentsOfFile:self.imagePath] typeIdentifier:uti filename:@"QuickSnap.gif"];
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

#pragma mark - Share on Twitter

- (void)shareOnTwitter {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"GIF works on twitter?"];
        [tweetSheet addImage:[UIImage imageWithContentsOfFile:self.imagePath]];
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
        }];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Tap gesture selector

- (void)toggleNavigationBar:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.navigationController setNavigationBarHidden:![self.navigationController isNavigationBarHidden] animated:YES];

}

#pragma mark - dealloc

- (void)dealloc {
    self.imageView = nil;
}

@end
