//
//  AppDelegate.h
//  Project6
//
//  Created by Glenn Axworthy on 11/13/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)fetchFlickrData:(UIManagedDocument *)document;
- (void)loadDocument:(void (^)(UIManagedDocument *document, BOOL loaded))completion;

@end

