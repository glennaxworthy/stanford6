//
//  Region+Flickr.m
//  Project6
//
//  Created by Glenn Axworthy on 11/13/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "Region+Flickr.h"
#import "FlickrFetcher.h"

@implementation Region (Flickr)

+ (Region *)createFromFlickr:(NSDictionary *)flickrPhoto inContext:(NSManagedObjectContext *)context {
    Region *region = nil;

    NSError *error = nil;
    NSString *placeId = [flickrPhoto objectForKey:FLICKR_PLACE_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = [NSPredicate predicateWithFormat:@"placeId = %@", placeId];
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!results) {
        NSLog(@"Region createFromFlickr: failed fetch request: %@", error);
    } else if ([results count] == 0) {
        region = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:context];
        NSURL *placeURL = [FlickrFetcher URLforInformationAboutPlace:placeId];
        NSData *json = [NSData dataWithContentsOfURL:placeURL options:0 error:&error];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
        
        NSString *name = nil;
        if ([placeId isEqualToString:[dictionary valueForKeyPath:FLICKR_PLACE_REGION_PLACE_ID]])
            name = [dictionary valueForKeyPath:FLICKR_PLACE_REGION_NAME];
        else if ([placeId isEqualToString:[dictionary valueForKeyPath:FLICKR_PLACE_COUNTRY_PLACE_ID]])
            name = [dictionary valueForKeyPath:FLICKR_PLACE_COUNTRY_NAME];
        else if ([placeId isEqualToString:[dictionary valueForKeyPath:FLICKR_PLACE_LOCALITY_PLACE_ID]])
            name = [dictionary valueForKeyPath:FLICKR_PLACE_LOCALITY_NAME];
        else if ([placeId isEqualToString:[dictionary valueForKeyPath:FLICKR_PLACE_COUNTY_PLACE_ID]])
            name = [dictionary valueForKeyPath:FLICKR_PLACE_COUNTY_NAME];
        else if ([placeId isEqualToString:[dictionary valueForKeyPath:FLICKR_PLACE_NEIGHBORHOOD_PLACE_ID]])
            name = [dictionary valueForKeyPath:FLICKR_PLACE_NEIGHBORHOOD_NAME];
        else
            name = [NSString stringWithFormat:@"placeId=%@", placeId];

        NSLog(@"Region createFromFlickr: '%@'", name);
        
        region.name = name;
        region.placeId = placeId;
    } else {
        region = [results lastObject]; // region already exists
    }
    
    return region;
}

@end