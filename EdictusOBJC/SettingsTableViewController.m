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
@property (strong, nonatomic) UILabel *datelabel;
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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Date"] == YES){
        [dateLabel setHidden: NO];
    }else{
        [dateLabel setHidden: YES];
    }
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    if (switchControl.on){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Date"];
       [self performSegueWithIdentifier: @"Initial" sender: self];

       // [_datelabel setHidden:NO];
      //  [self presentViewController:self animated:true completion:nil];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Date"];
        [self performSegueWithIdentifier: @"Initial" sender: self];

    //    [_datelabel setHidden:YES];
    //    [self presentViewController:self animated:true completion:nil];
    }
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
            return 2;
        case 1:
            return 2;
        case 2:
            return 4;
            
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.textLabel.textAlignment = NSTextAlignmentCenter;
    [footer.textLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium]];
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section   {
    NSString *message = @"";

       if (section == 2) {
           message = @"\nmade with 💛 in Italy";
       }

       return message;
    }



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
   if (indexPath.section == 0) {
        //general
               switch (indexPath.row) {
                   case 0:{
                        cell.imageView.image = [UIImage systemImageNamed: @"trash"];
                        cell.imageView.tintColor = [UIColor systemYellowColor];
                        cell.textLabel.text = @"Delete Wallpapers";
                       [cell.textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
                        cell.detailTextLabel.text = @"Easily delete wallpapers you created";
                       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        break;
                   }
                   case 1:{
                       [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                       cell.imageView.image = [UIImage systemImageNamed: @"calendar"];
                       cell.textLabel.text = @"Enable Date in NavBar";
                       [cell.textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
                       cell.detailTextLabel.text = @"" ;
                     UISwitch *onoffSwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
                       [onoffSwitch setOn: [[NSUserDefaults standardUserDefaults] boolForKey:@"Date"]];
                       [onoffSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                       onoffSwitch.onTintColor = [UIColor systemYellowColor];
                       cell.accessoryView = onoffSwitch;
                       break;
               }
                    default:
                        break;
                }
       
   }else if (indexPath.section == 1){
       //feedback
       switch (indexPath.row) {
       case 0:
               cell.textLabel.text = @"Report a Bug";
               [cell.textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
               cell.detailTextLabel.text = @"NOTE: Device specs will be included";
               cell.imageView.image = [UIImage systemImageNamed:@"ant"];
           break;
       case 1:
               cell.textLabel.text = @"Donate Me";
               [cell.textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
               cell.detailTextLabel.text = @"If you want to support me click here 💘";
               cell.imageView.image = [UIImage systemImageNamed:@"dollarsign.circle"];
           break;
           
       default:
           break;
       }
       
   }else{
       //credits
       // NSData * aboutzephPic = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"https://avatars.io/twitter/aboutzeph"]];
       // NSData * iospeterdevPic = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"https://avatars.io/twitter/iospeterdev"]];
       //  NSData * xeviksPic = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"https://avatars.io/twitter/Xeviks"]];
       // NSData * stackoverflowPic = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"https://avatars.io/twitter/stackoverflow"]];

       
       switch (indexPath.row) {
           case 0:{
               cell.textLabel.text = @"Matteo Zappia";
               cell.detailTextLabel.text = @"@aboutzeph";
               [cell.textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
               cell.imageView.image = [UIImage imageNamed:@"aboutzeph"];
               CGSize destinationSize = CGSizeMake(35, 35);
                                   UIGraphicsBeginImageContextWithOptions(destinationSize, NO, 0.0f)

;
                                   [cell.imageView.image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
                                   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                                   UIGraphicsEndImageContext();
               cell.imageView.image = newImage;
               [cell layoutIfNeeded];
               cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
               cell.imageView.layer.cornerRadius =  cell.imageView.frame.size.width / 2;
               cell.imageView.clipsToBounds = YES;
               break;
           }
           case 1:{
               cell.textLabel.text = @"Soongyu Kwon";
               cell.detailTextLabel.text = @"@iospeterdev";
               [cell.textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
               cell.imageView.image = [UIImage imageNamed:@"peterdev"];
               CGSize destinationSize = CGSizeMake(35, 35);
                                                 UIGraphicsBeginImageContextWithOptions(destinationSize, NO, 0.0f);
                                                 [cell.imageView.image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
                                                 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                                                 UIGraphicsEndImageContext();
                             cell.imageView.image = newImage;
               [cell layoutIfNeeded];
               cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
               cell.imageView.layer.cornerRadius =  cell.imageView.frame.size.width / 2;
               cell.imageView.clipsToBounds = YES;
               break;
           }
           case 2:{
               cell.textLabel.text = @"Luis E.";
               cell.detailTextLabel.text = @"@Xeviks";
               [cell.textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
               cell.imageView.image = [UIImage imageNamed:@"xeviks"];
               CGSize destinationSize = CGSizeMake(35, 35);
                                                 UIGraphicsBeginImageContextWithOptions(destinationSize, NO, 0.0f);
                                                 [cell.imageView.image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
                                                 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                                                 UIGraphicsEndImageContext();
                             cell.imageView.image = newImage;
               [cell layoutIfNeeded];
               cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
               cell.imageView.layer.cornerRadius =  cell.imageView.frame.size.width / 2;
               cell.imageView.clipsToBounds = YES;
               break;
           }
           case 3:{
               cell.textLabel.text = @"Stack Overflow";
               cell.detailTextLabel.text = @"@stackoverflow";
               [cell.textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
               cell.imageView.image = [UIImage imageNamed:@"stackoverflow"];
               CGSize destinationSize = CGSizeMake(35, 35);
                                                 UIGraphicsBeginImageContextWithOptions(destinationSize, NO, 0.0f);
                                                 [cell.imageView.image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
                                                 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                                                 UIGraphicsEndImageContext();
                             cell.imageView.image = newImage;
               [cell layoutIfNeeded];
               cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
               cell.imageView.layer.cornerRadius =  cell.imageView.frame.size.width / 2;
               cell.imageView.clipsToBounds = YES;
               break;
           }
           default:{
               break;
           }
       }
   }
    

    return cell;
            
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"General";
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
    
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
                [self performSegueWithIdentifier: @"DeletedWallpapersSegue" sender: self];
        }else{
               //none
        }
    }
    
    if (indexPath.section == 1) {
        //feedback
        switch (indexPath.row) {
            case 0:
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/matteozappia/EdictusBugTracker/issues/new?assignees=&labels=bug&template=bug-report.md&title=%5BBUG%5D"] options:@{} completionHandler:nil];
                break;
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://paypal.me/matteozappia"] options:@{} completionHandler:nil];
                break;
                
            default:
                break;
        }
        
    }
    
    if (indexPath.section == 2) {
        //credits
        
        switch (indexPath.row) {
            case 0:
                //opentwittermaybe?
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.twitter.com/aboutzeph"] options:@{} completionHandler:nil];
                break;
            case 1:
                //opentwittermaybe?
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.twitter.com/iospeterdev"] options:@{} completionHandler:nil];
                break;
            case 2:
                //opentwittermaybe?
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.twitter.com/xeviks"] options:@{} completionHandler:nil];
                break;
            case 3:
                //memetime
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.youtube.com/watch?v=dQw4w9WgXcQ"] options:@{} completionHandler:nil];
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
