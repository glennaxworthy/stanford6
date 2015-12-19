//
//  RegionTableViewController.m
//  Project6
//
//  Created by Glenn Axworthy on 11/13/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "RegionTableViewController.h"
#import "AppDelegate.h"
#import "PhotosTableViewController.h"
#import "Region+Flickr.h"

@interface RegionTableViewController ()

@property (strong, nonatomic) UIManagedDocument *document;

@end

@implementation RegionTableViewController

- (void)installFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"photogs" ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    [request setFetchBatchSize: 50];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:self.document.managedObjectContext
                                                                            sectionNameKeyPath:nil                                                                                     cacheName:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    PhotosTableViewController *controller = segue.destinationViewController;
    controller.region = region;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate loadDocument:^(UIManagedDocument *document, BOOL loaded) {
        self.document = document;
        [self installFetchedResultsController];
        if (!loaded)
            [delegate fetchFlickrData:document];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.fetchedResultsController = nil;
}

#pragma mark - table view data source protocol

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Region Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    
    Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = region.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ photographers, %u photos",
                                 region.photogs, [region.photos count]];
    return cell;
}

#pragma mark - fetched results controller delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.refreshControl endRefreshing];
    [super controllerDidChangeContent:(NSFetchedResultsController *) controller];
}

@end
