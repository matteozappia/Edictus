//
//  ViewController.m
//  EdictusOBJC
//
//  Created by Matteo Zappia on 08/03/2020.
//  Copyright © 2020 Matteo Zappia. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *lightImageView;
@property (strong, nonatomic) IBOutlet UIImageView *darkImageView;

@end

@implementation ViewController {
    UIImagePickerController *picker;
    BOOL isDark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE d MMMM"];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    self.currentDateLabel.text = [[dateFormatter stringFromDate:[NSDate date]] uppercaseString];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Date"] == YES){
    [_currentDateLabel setHidden: NO];
    }else{
    [_currentDateLabel setHidden: YES];
    }
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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //creating Edictus Folder in Media
    if (![fileManager fileExistsAtPath:@"/Library/WallpaperLoader"]){
        NSURL *newDir = [NSURL fileURLWithPath:@"/Library/WallpaperLoader"];
        [fileManager createDirectoryAtURL:newDir withIntermediateDirectories:YES attributes: nil error:nil];
    }
    NSArray *files = [fileManager contentsOfDirectoryAtPath:@"/var/mobile/Media/Edictus/" error:nil];
    for (NSString *file in files) {
        [fileManager moveItemAtPath:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:file]
                    toPath:[@"/Library/WallpaperLoader/" stringByAppendingPathComponent:file]
                     error:nil];
    }
    printf("Successfully moved a folder\n");
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (isDark){
        _darkImageView.image = image;
        _darkThumbnail.image = image;
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [imageData writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Dark.png"] atomically:YES];
    } else {
        _lightImageView.image = image;
        _lightThumbnail.image = image;
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [imageData writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Light.png"] atomically:YES];
    }
    [self createWallpaperplist];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)lightButtonPressed:(id)sender {
    isDark = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)darkButtonPressed:(id)sender {
    isDark = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (UIImage *) imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
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
      
        NSFileManager *fileManager = [NSFileManager defaultManager];
           
        NSString *mediaEdictus = @"/var/mobile/Media/Edictus/";
        NSString *wallpaperNameInMedia = [NSString stringWithFormat: @"%@%@", mediaEdictus, wallpaperName];
        NSLog(@"%@", wallpaperNameInMedia);
           //creating Edictus Folder in Media
           if (![fileManager fileExistsAtPath:wallpaperNameInMedia]){
               NSLog(@"Moving Files to wallpapername folder");
               NSURL *newDir = [NSURL fileURLWithPath:wallpaperNameInMedia];
               [fileManager createDirectoryAtURL:newDir withIntermediateDirectories:YES attributes: nil error:nil];
               
               // CREATE THUMBNAIL
               
               UIImage *thumbnailImage = [self imageWithView:[self thumbnailView]];
               NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(thumbnailImage, 1.0)];
               [imageData writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Thumbnail.jpg"] atomically:YES];
               
               // Get all files at /var/mobile/Media/Edictus/
               NSArray *files = [fileManager contentsOfDirectoryAtPath:mediaEdictus error:nil];
               NSArray *jpgThumb = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"]];
               NSArray *pngFiles = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.png'"]];
               NSArray *plistFiles = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.plist'"]];
               // Move all files to bundle created
               for (NSString *file in jpgThumb) {
                   [fileManager moveItemAtPath:[mediaEdictus stringByAppendingPathComponent:file]
                               toPath:[wallpaperNameInMedia stringByAppendingPathComponent:file]
                                error:nil];
                   
                // [self copyChangeToMedia];
               }
               for (NSString *file in pngFiles) {
                   [fileManager moveItemAtPath:[mediaEdictus stringByAppendingPathComponent:file]
                               toPath:[wallpaperNameInMedia stringByAppendingPathComponent:file]
                                error:nil];
                   
                // [self copyChangeToMedia];
               }
               for (NSString *file in plistFiles) {
                   [fileManager moveItemAtPath:[mediaEdictus stringByAppendingPathComponent:file]
                               toPath:[wallpaperNameInMedia stringByAppendingPathComponent:file]
                                error:nil];
                   
                // [self copyChangeToMedia];
               }
               [self copyChangeToMedia];
           }
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertVC addAction:action];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:true completion:nil];
    
}


@end
