//
//  Photographer+Flickr.m
//  Project6
//
//  Created by Glenn Axworthy on 11/13/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "Photographer+Flickr.h"
#import "FlickrFetcher.h"

@implementation Photographer (Flickr)

+ (Photographer *)createFromFlickr:(NSDictionary *)flickrPhoto inContext:(NSManagedObjectContext *)context {
    Photographer *photographer = nil;
    NSString *name = [flickrPhoto objectForKey:FLICKR_PHOTO_OWNER];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!results) {
        NSLog(@"failed fetch request: %@", error);
    } else if ([results count] == 0) {
        photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer" inManagedObjectContext:context];
        photographer.name = name;
    } else {
        photographer = [results lastObject];
    }
    
    return photographer;
}

@end
