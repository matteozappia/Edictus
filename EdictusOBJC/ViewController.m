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
    BOOL isDark;
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


-(void)createWallpaperplist{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //creating Edictus Folder in Media
    if (![fileManager fileExistsAtPath:@"/var/mobile/Media/Edictus"]){
        NSLog(@"Creating Edictus folder in Media");
        NSURL *newDir = [NSURL fileURLWithPath:@"/var/mobile/Media/Edictus"];
        [fileManager createDirectoryAtURL:newDir withIntermediateDirectories:YES attributes: nil error:nil];
    }

    if (![fileManager fileExistsAtPath: [NSURL fileURLWithPath:@"/var/mobile/Media/Edictus"].absoluteString]){
        NSString *wallpaperPlist = [NSString stringWithFormat:@"<?xml version=""1.0"" encoding=""UTF-8""?>\n"
                                                        "<!DOCTYPE plist PUBLIC ""-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"">\n"
                                                        "<plist version=""1.0"">\n"
                                                        "<dict>\n"
                                                        "<key>appearanceAware</key>\n"
                                                        "<true/>\n"
                                                        "<key>darkImage</key>\n"
                                                        "<string>Dark.png</string>\n"
                                                        "<key>defaultImage</key>\n"
                                                        "<string>Light.png</string>\n"
                                                        "<key>thumbnailImage</key>\n"
                                                        "<string>Thumbnail.jpg</string>\n"
                                                        "<key>wallpaperType</key>\n"
                                                        "<integer>0</integer>\n"
                                                        "</dict>\n"
                                                        "</plist>\n"];
        
        [[NSFileManager defaultManager] createFileAtPath:@"/var/mobile/Media/Edictus/Wallpaper.plist" contents:[wallpaperPlist dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    
}


// function to copy the completed bundle folder from media to wallpaperloader
- (void)copyChangeToMedia {
    [[NSFileManager defaultManager] copyItemAtPath:@"/var/mobile/Media/Edictus/" toPath:@"/Library/WallpaperLoader" error:nil];
    printf("Successfully moved a folder\n");
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (isDark){
        _darkImageView.image = image;
    } else {
        _lightImageView.image = image;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)presentImagePickerView {
    //noob
}

- (IBAction)lightButtonPressed:(id)sender {
    isDark = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)darkButtonPressed:(id)sender {
    isDark = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)createButtonPressed:(id)sender {
    
    // create alert, textField.text will be the bundle name
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Wallpaper Title" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
      {
        textField.placeholder = @"Choose your wallpaper's name";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
      }
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      NSLog(@"Save Tapped");
      NSString *wallpaperName = alertVC.textFields[0].text;
      NSLog(@"%@", wallpaperName);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertVC addAction:action];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:true completion:nil];
    
}


@end
