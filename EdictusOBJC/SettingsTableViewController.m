//
//  SettingsTableViewController.m
//  EdictusOBJC
//
//  Created by Matteo Zappia on 08/03/2020.
//  Copyright © 2020 Matteo Zappia. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()
@property (strong, nonatomic) IBOutlet UILabel *socialLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, -68, 343, 18)];
    //[myLabel setBackgroundColor:[UIColor clearColor]];
    dateLabel.textColor = [UIColor scrollViewTexturedBackgroundColor];
    [dateLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightBold]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE d MMMM"];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    dateLabel.text = [[dateFormatter stringFromDate:[NSDate date]] uppercaseString];
    [[self view] addSubview:dateLabel];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 2;
        case 2:
            return 3;
            
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
   if (indexPath.section == 0) {
        //social
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Twitter";
                    cell.textLabel.textColor = [UIColor systemTealColor];
                    cell.detailTextLabel.text = @"@aboutzeph";
                    break;
                case 1:
                    cell.textLabel.text = @"GitHub";
                    cell.textLabel.textColor = [UIColor labelColor];
                    cell.detailTextLabel.text = @"@matteozappia";
                    break;
                case 2:
                    cell.textLabel.text = @"Reddit";
                    cell.textLabel.textColor = [UIColor systemOrangeColor];
                    cell.detailTextLabel.text = @"@zapreme";
                    break;
                default:
                    break;
            }
    
   }else if (indexPath.section == 1) {
       //feedback
       switch (indexPath.row) {
           case 0:
               cell.textLabel.text = @"Report a Bug";
               cell.detailTextLabel.text = @"note: add your device information please";
               break;
           case 1:
               cell.textLabel.text = @"Donate Me";
               cell.detailTextLabel.text = @"if you want to support me click here💘";
               break;
               
           default:
               break;
       }
       
   }else{
       //credits
       
       switch (indexPath.row) {
           case 0:
               cell.textLabel.text = @"Matteo Zappia";
               cell.detailTextLabel.text = @"@aboutzeph";
               break;
           case 1:
               cell.textLabel.text = @"Soongyu Kwon";
               cell.detailTextLabel.text = @"@iospeterdev";
               break;
           case 2:
               cell.textLabel.text = @"Stack Overflow";
               cell.detailTextLabel.text = @"@stackoverflow";
               break;
           default:
               break;
       }
   }
    
    

    return cell;
            
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Social";
        case 1:
            return @"Feedback";
        case 2:
            return @"Credits";
            
        default:
            break;
    }
    
    return @"";
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
         //social
             switch (indexPath.row) {
                 case 0:
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.twitter.com/aboutzeph"] options:@{} completionHandler:nil];
                     break;
                 case 1:
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.github.com/matteozappia"] options:@{} completionHandler:nil];
                     break;
                 case 2:
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.reddit.com/user/zapreme"] options:@{} completionHandler:nil];
                     break;
                 default:
                     break;
             }
     
    }else if (indexPath.section == 1) {
        //feedback
        switch (indexPath.row) {
            case 0:
                //mailto with device infos here, will do it later
                break;
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://paypal.me/matteozappia"] options:@{} completionHandler:nil];
                break;
                
            default:
                break;
        }
        
    }else{
        //credits
        
        switch (indexPath.row) {
            case 0:
                //nothing atm
                break;
            case 1:
                //opentwittermaybe?
                break;
            case 2:
                //memetime
                break;
                
            default:
                break;
        }
    }
    
    
    //just deselect at the moment, no social link or stuff like that
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
