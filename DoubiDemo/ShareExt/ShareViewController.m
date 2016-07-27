//
//  ShareViewController.m
//  ShareExt
//
//  Created by gaolili on 16/7/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface ShareViewController ()

@end

@implementation ShareViewController

-(void)viewDidLoad{
    [super viewDidLoad];
  
    NSExtensionItem *extensionItem = [self.extensionContext.inputItems firstObject];
    
    __weak __typeof(self) __weak_self = self;
    BOOL isExit = YES;
    for(NSItemProvider *itemProvider in [extensionItem attachments]) {
        if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeFileURL]) {
            isExit = NO;
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeFileURL options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                
                NSURL *URL = (NSURL *)item;
                if ([URL isFileURL] && [__weak_self copyResToAppGroup:URL])
                    [__weak_self openApp ];
                else
                    [self.extensionContext completeRequestReturningItems:nil completionHandler:NULL];
            }];
        }
    }
    if (isExit) [self.extensionContext completeRequestReturningItems:nil completionHandler:NULL];
}


//  在扩展中打开 contaier app 
- (void)openApp {
    NSString *destURLString = @"doubiDemo://";
    UIResponder* responder = self;
    while ((responder = [responder nextResponder]) != nil){
        if([responder respondsToSelector:@selector(openURL:)] == YES){
            [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:destURLString]];
            [self.extensionContext completeRequestReturningItems:nil completionHandler:NULL];
        }
    }
}

// 将文件复制到 app group
- (BOOL) copyResToAppGroup:(NSURL *) sorURL
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *groupURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.DoubiDemo"];
    groupURL = [groupURL URLByAppendingPathComponent:@"upload"];
    
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:groupURL.relativePath isDirectory:&isDir] && !isDir)
        [fileManager createDirectoryAtURL:groupURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *name = [[sorURL lastPathComponent] stringByDeletingPathExtension];
    NSString *ext = [sorURL pathExtension];
    
    groupURL = [groupURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.%@", name, currentDateStr, ext]];
  
    return [fileManager copyItemAtURL:sorURL toURL:groupURL error:&error];
}



- (void)didSelectPost {
    
     // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
     [self.extensionContext completeRequestReturningItems:nil completionHandler:NULL];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
