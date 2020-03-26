//
//  EdictusNewViewController.m
//  EdictusOBJC
//
//  Created by Matteo Zappia on 26/03/2020.
//  Copyright © 2020 Matteo Zappia. All rights reserved.
//

#import "EdictusNewViewController.h"

@interface EdictusNewViewController ()

@end

@implementation EdictusNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalInPresentation = YES;
    // Do any additional setup after loading the view.
}
- (IBAction)continueButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
