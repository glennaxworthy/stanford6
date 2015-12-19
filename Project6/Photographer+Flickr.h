//
//  Photographer+Flickr.h
//  Project6
//
//  Created by Glenn Axworthy on 11/13/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Flickr)

+ (Photographer *)createFromFlickr:(NSDictionary *)flickrPhoto inContext:(NSManagedObjectContext *)context;

@end
