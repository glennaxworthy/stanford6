//
//  AppDelegate.m
//  Project6
//
//  Created by Glenn Axworthy on 11/13/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "AppDelegate.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIManagedDocument *document;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)fetchFlickrData:(UIManagedDocument *)document {
    dispatch_queue_t queue = dispatch_queue_create("fetchFlickrData", NULL);
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
        NSData *json = [NSData dataWithContentsOfURL:url options:0 error:&error];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
        NSArray *flickrPhotos = [dictionary valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        
        NSManagedObjectContext *context = document.managedObjectContext;
        [context performBlock:^ {
            for (NSDictionary *flickrPhoto in flickrPhotos) {
                [Photo createFromFlickr:flickrPhoto inContext:context];
            }
        }];
    });
}

- (void)loadDocument:(void (^)(UIManagedDocument *document, BOOL loaded))completion {
    if (self.document) {
        completion(self.document, YES);
        return;
    }

    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                         inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Flickr Photo document"];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    if (!self.document) {
        NSLog(@"unable to create UIManagedDocument");
        completion(NULL, NO);
        return;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL succes) {
            completion(self.document, NO);
        }];
    }
    else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            completion(self.document, YES);
        }];
    } else {
        completion(self.document, YES);
    }
}

@end
