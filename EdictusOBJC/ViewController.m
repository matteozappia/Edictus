//
//  ViewController.m
//  EdictusOBJC
//
//  Created by Matteo Zappia on 08/03/2020.
//  Copyright © 2020 Matteo Zappia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lightImageView;
@property (strong, nonatomic) IBOutlet UIImageView *darkImageView;

@end

@implementation ViewController {
    UIImagePickerController *picker;
    BOOL *isDark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE d MMMM"];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    self.currentDateLabel.text = [[dateFormatter stringFromDate:[NSDate date]] uppercaseString];
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(nonnull UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey,id> *)editingInfo
{
    //Get Image URL from Library
    if (isDark == false){
    _lightImageView.image = image;
    }else{
        _darkImageView.image = image;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
}


- (IBAction)lightButtonPressed:(id)sender {
    [self presentModalViewController:picker animated:YES];
    isDark = false;
}

- (IBAction)darkButtonPressed:(id)sender {
     [self presentModalViewController:picker animated:YES];
    isDark = true;
}

@end
