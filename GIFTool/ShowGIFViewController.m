//
//  ShowGIFViewController.m
//  GIFTool
//
//  Created by Haris on 6/26/14.
//  Copyright (c) 2014 HarisHussain. All rights reserved.
//

#import "ShowGIFViewController.h"
#import "OLImageView.h"
#import "Utils.h"
#import "OLImage.h"
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GIFManager.h"

@interface ShowGIFViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation ShowGIFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = [OLImage imageWithData:[NSData dataWithContentsOfFile:self.imagePath]];
    
    UIImage *image = [UIImage imageNamed:@"icon_01"];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)share:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"share QuickSnap"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"iMessage", nil];
    [actionsheet showInView:self.view];
}

- (IBAction)deleteGIF:(id)sender {
    NSLog(@"%@", self.imagePath);
    [[GIFManager shared] deleteGIF:self.imagePath];
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

@end
