//
//  Photo+Flickr.h
//  Project6
//
//  Created by Glenn Axworthy on 11/13/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)createFromFlickr:(NSDictionary *)flickrPhoto inContext:(NSManagedObjectContext *)context;
- (NSData *)loadThumbnail;

@end
