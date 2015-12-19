//
//  HistoryTableViewController.m
//  Project6
//
//  Created by Glenn Axworthy on 11/21/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "AppDelegate.h"
#import "ImageViewController.h"
#import "Photo+Flickr.h"

@interface HistoryTableViewController ()

@property (strong, nonatomic) NSArray *photos;

@end

@implementation HistoryTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate loadDocument:^(UIManagedDocument *document, BOOL loaded) {
        if (!loaded)
            [delegate fetchFlickrData:document];

        NSError *error = nil;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"displayTime" ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"displayTime > 0"];
        self.photos = [document.managedObjectContext executeFetchRequest:request error:&error];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"History Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    cell.imageView.image = [UIImage imageWithData:[photo loadThumbnail]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ImageViewController *controller = segue.destinationViewController;
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    controller.photo = photo;
    controller.title = photo.title;
}

@end
