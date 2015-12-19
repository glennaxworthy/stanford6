//
//  Region+Flickr.h
//  Project6
//
//  Created by Glenn Axworthy on 11/13/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "Region.h"

@interface Region (Flickr)

+ (Region *)createFromFlickr:(NSDictionary *)flickrPhoto inContext:(NSManagedObjectContext *) context;

@end
