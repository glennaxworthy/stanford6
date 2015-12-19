//
//  Photo+Flickr.m
//  Project6
//
//  Created by Glenn Axworthy on 11/13/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "Photo+Flickr.h"
#import "Photographer+Flickr.h"
#import "Region+Flickr.h"
#import "FlickrFetcher.h"

@implementation Photo (Flickr)

+ (Photo *)createFromFlickr:(NSDictionary *)flickrPhoto inContext:(NSManagedObjectContext *)context {
    Photo *photo = nil;

    // ensure photoId is unique - why?
    NSString *photoId = [flickrPhoto objectForKey:FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"photoId = %@", photoId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *photos = [context executeFetchRequest:request error:&error];
    
    if (!photos) {
        NSLog(@"Photo createFromFlickr: failed fetch request: %@", error);
    } else if ([photos count] > 0) {
        NSLog(@"Photo createFromFlickr: duplicate photoId!");
    } else {
        // create photo and add to database
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.photoId = photoId;
        photo.title = [flickrPhoto objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle = [flickrPhoto valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher URLforPhoto:flickrPhoto format:FlickrPhotoFormatLarge] absoluteString];
        photo.thumbnailURL = [[FlickrFetcher URLforPhoto:flickrPhoto format:FlickrPhotoFormatSquare] absoluteString];
        photo.photographer = [Photographer createFromFlickr:flickrPhoto inContext:context];
        photo.region = [Region createFromFlickr:flickrPhoto inContext:context];

        // query number of photographers with photo(s) of region
        request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
        request.predicate = [NSPredicate predicateWithFormat:@"ANY photos.region.placeId LIKE %@", photo.region.placeId];
        NSArray *photographers = [context executeFetchRequest:request error:nil];
        photo.region.photogs = [NSNumber numberWithLong:[photographers count]];
    }

    return photo;
}

- (NSData *)loadThumbnail {
    if (!self.thumbnailData) {
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:self.thumbnailURL];
        self.thumbnailData = [NSData dataWithContentsOfURL:url options:0 error:&error];
    }

    return self.thumbnailData;
}

@end
