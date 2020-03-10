//
//  LiveViewController.m
//  EdictusOBJC
//
//  Created by Matteo Zappia on 09/03/2020.
//  Copyright © 2020 Matteo Zappia. All rights reserved.
//

#import "LiveViewController.h"

@interface LiveViewController ()
@property (strong, nonatomic) IBOutlet UILabel *currentDateLabel;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE d MMMM"];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    self.currentDateLabel.text = [[dateFormatter stringFromDate:[NSDate date]] uppercaseString];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
