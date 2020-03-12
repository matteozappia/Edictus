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
    [self createWallpaperplist];
    // Do any additional setup after loading the view.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE d MMMM"];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    self.currentDateLabel.text = [[dateFormatter stringFromDate:[NSDate date]] uppercaseString];
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    
    
}


-(void) createWallpaperplist{
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    
    //creating Edictus Folder in Media
    if ([fileManager fileExistsAtPath:@"/var/mobile/Media/Edictus"]){
        //nothing
        NSLog(@"Edictus folder already exists in Media");
   }else{
       NSLog(@"Creating Edictus folder in Media");
       NSURL *newDir = [NSURL fileURLWithPath:@"/var/mobile/Media/Edictus"];
       [fileManager createDirectoryAtURL: newDir withIntermediateDirectories:YES attributes: nil error:nil];
    }
    
    // get file URL from bundle
    NSURL *fileFromBundle = [[NSBundle mainBundle]URLForResource:@"Wallpaper" withExtension:@"plist"];
        
    // destination URL
    NSURL *destinationURL = [NSURL fileURLWithPath:@"/var/mobile/Media/Edictus"];
        
    // copy it over

    if ([fileManager fileExistsAtPath: destinationURL.absoluteString]){
        //nothing.
        NSLog(@"file already exists");
    }else{
        [[NSFileManager defaultManager]copyItemAtURL:fileFromBundle toURL:destinationURL error:nil];
       NSLog(@"Wallpaper.plist is now in /var/mobile/Media/Edictus/");
    }
    
}


// function to copy the completed bundle folder from media to wallpaperloader
- (void)copyChangeToMedia {
    NSURL *oldURL = [NSURL fileURLWithPath:@"/var/mobile/Media/Edictus/"];
    NSURL *newURL = [NSURL fileURLWithPath:@"/Library/WallpaperLoader"];
    [[NSFileManager defaultManager] copyItemAtPath:oldURL toPath:newURL error:nil];
    printf("Successfully moved a folder\n");
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(nonnull UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey,id> *)editingInfo
{
    if (!isDark){
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

- (IBAction)createButtonPressed:(id)sender {
    
    // create alert, textField.text will be the bundle name
    UIAlertController *alertVC= [UIAlertController alertControllerWithTitle:@"Wallpaper Title" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
      {
        textField.placeholder=@"Choose your wallpaper's name";
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
      }
    }];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      NSLog(@"Save Tapped");
      NSString *wallpaperName=alertVC.textFields[0].text;
      NSLog(@"%@",wallpaperName);
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
}];
    [alertVC addAction:action];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:true completion:nil];
    
    //
    
}


@end
