//
//  WallpapersTableViewController.m
//  EdictusOBJC
//
//  Created by Matteo Zappia on 16/03/2020.
//  Copyright © 2020 Matteo Zappia. All rights reserved.
//

#import "WallpapersTableViewController.h"

@interface WallpapersTableViewController ()

@end

@implementation WallpapersTableViewController

//NSString *LibraryPath = @"/var/mobile/Media/Edictus";
NSString *LibraryPath = @"/Library/WallpaperLoader";
NSArray *dirs ;
NSMutableArray *mutableDirs ;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addThemesFromDirectory];
    UIRefreshControl *refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshController];
    [self.tableView setEditing: YES];
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:LibraryPath error:nil];
    mutableDirs = [dirs mutableCopy];
    NSLog(@"%@", mutableDirs);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)handleRefresh:(id)sender
{
   NSLog (@"Refreshing...");
   // [self.tableView reloadData];
    [UIView transitionWithView: self.tableView
                     duration: 0.10f
                      options: UIViewAnimationOptionTransitionCrossDissolve
                   animations: ^(void)
    {
         [self.tableView reloadData];
    }
                   completion: nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [sender endRefreshing];
    });
    
}

- (void)addThemesFromDirectory {
  //  NSLog(@"%@", dirs);
    };
    
    
    //[[[NSFileManager defaultManager] displayNameAtPath:@"/var/mobile/Media/Edictus"] stringByDeletingPathExtension];




























#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    
    NSInteger numOfSections = 0;
    numOfSections = mutableDirs.count;
    
       if (numOfSections >= 0)
       {
           tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
           tableView.backgroundView = nil;
           return 1;
       }
      
       return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    if (mutableDirs.count == 0){
        
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
                  noDataLabel.text             = @"No Wallpapers Available";
                  noDataLabel.textColor        = [UIColor scrollViewTexturedBackgroundColor];
                  noDataLabel.textAlignment    = NSTextAlignmentCenter;
                  tableView.backgroundView = noDataLabel;
                  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return mutableDirs.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WallpaperCell" forIndexPath:indexPath];
    
    
    
    // Configure the cell...
    //NSString * stringToDisplay = [dirs componentsJoinedByString:@"\n"];
    int i;
    for (i=0;i<=((sizeof(mutableDirs)/sizeof(int)));i++){
        cell.textLabel.text = [[mutableDirs objectAtIndex:indexPath.row] capitalizedString];
    }
    return cell;
    
    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0){
    if (mutableDirs.count == 0){
        return @"";
    }else{
        return @"Delete Wallpapers";
    }
    }
 
    return @"";
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString *cellN = [mutableDirs objectAtIndex: indexPath.row];
        NSString *path = [@"/Library/WallpaperLoader/" stringByAppendingString:cellN];
        
        pid_t pid;
        const char* args[] = {"edictusroot", "rm", "-rf", [path cStringUsingEncoding:NSUTF8StringEncoding], NULL};
        posix_spawn(&pid, "/usr/bin/edictusroot", NULL, NULL, (char* const*)args, NULL);
        [self fuckOffPreferences];
        [mutableDirs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        
        
        
        
    }
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
}

-(void)fuckOffPreferences {
    pid_t pid;
    const char* args[] = {"killall", "Preferences", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
