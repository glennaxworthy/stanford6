//
//  Photo+CoreDataProperties.h
//  Project6
//
//  Created by Glenn Axworthy on 11/21/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *displayTime;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *photoId;
@property (nullable, nonatomic, retain) NSString *subtitle;
@property (nullable, nonatomic, retain) NSData *thumbnailData;
@property (nullable, nonatomic, retain) NSString *thumbnailURL;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) Photographer *photographer;
@property (nullable, nonatomic, retain) Region *region;

@end

NS_ASSUME_NONNULL_END
