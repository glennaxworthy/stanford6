//
//  PhotosTableTableViewController.m
//  Project6
//
//  Created by Glenn Axworthy on 11/20/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "ImageViewController.h"
#import "Photo+Flickr.h"
#import "Region+Flickr.h"

@interface PhotosTableViewController ()

@property (strong, nonatomic) NSArray *photos;

@end

@implementation PhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSSortDescriptor *sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    self.photos = [self.region.photos sortedArrayUsingDescriptors:@[sortByTitle]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];

    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    cell.imageView.image = [UIImage imageWithData:[photo loadThumbnail]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ImageViewController *controller = segue.destinationViewController;
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    controller.photo = photo;
    controller.title = photo.title;

    // record the display time of the photo
    photo.displayTime = [NSNumber numberWithLong:time(NULL)];
    [photo.managedObjectContext save:nil]; // persist change
}

@end