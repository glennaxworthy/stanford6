//
//  Region+CoreDataProperties.h
//  Project6
//
//  Created by Glenn Axworthy on 11/21/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Region.h"

NS_ASSUME_NONNULL_BEGIN

@interface Region (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *photogs;
@property (nullable, nonatomic, retain) NSString *placeId;
@property (nullable, nonatomic, retain) NSSet<Photo *> *photos;

@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet<Photo *> *)values;
- (void)removePhotos:(NSSet<Photo *> *)values;

@end

NS_ASSUME_NONNULL_END
