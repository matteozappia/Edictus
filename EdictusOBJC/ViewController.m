//
//  ViewController.m
//  EdictusOBJC
//
//  Created by Matteo Zappia on 08/03/2020.
//  Copyright © 2020 Matteo Zappia. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *lightImageView;
@property (strong, nonatomic) IBOutlet UIImageView *darkImageView;
@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *reverseButton;
@property (strong, nonatomic) IBOutlet UIButton *lockLight;
@property (strong, nonatomic) IBOutlet UIButton *lockDark;

@end

@implementation ViewController {
    UIImagePickerController *picker;
    BOOL isDark;
    BOOL isLightLocked;
    BOOL isDarkLocked;
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
    // IMPORTANT : Create Edictus Folder in Media for the first time.
    [self createFirstTimeMedia];
    [self fetchLockedImages];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"didIWelcomed"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * EdictusNew = [storyboard instantiateViewControllerWithIdentifier:@"EdictusNew"] ;
        [self presentViewController:EdictusNew animated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didIWelcomed"];
    }
}

-(void)fetchLockedImages {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Media/EdictusLocked/Light.png"]){
        NSData* data = [NSData dataWithContentsOfFile:@"/var/mobile/Media/EdictusLocked/Light.png"  options:0 error:nil];
        UIImage *image = [UIImage imageWithData:data];
        _lightImageView.image = image;
        _lightThumbnail.image = image;
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(_lightImageView.image)];
        [imageData writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Light.png"] atomically:YES];
        [[self lockLight] setUserInteractionEnabled:YES];
        [[self lockLight] setHidden:NO];
        [[self lockLight] setImage:[UIImage systemImageNamed:@"lock"] forState:UIControlStateSelected];
        [[self lockLight] setSelected:YES];
        isLightLocked = YES;
        [[self reverseButton] setUserInteractionEnabled:YES];
        [[self reverseButton] setHidden:NO];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Media/EdictusLocked/Dark.png"]){
        NSData* data = [NSData dataWithContentsOfFile:@"/var/mobile/Media/EdictusLocked/Dark.png"  options:0 error:nil];
        UIImage *image = [UIImage imageWithData:data];
        _darkImageView.image = image;
        _darkThumbnail.image = image;
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(_darkImageView.image)];
        [imageData writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Dark.png"] atomically:YES];
        [[self lockDark] setUserInteractionEnabled:YES];
        [[self lockDark] setHidden:NO];
        [[self lockDark] setImage:[UIImage systemImageNamed:@"lock"] forState:UIControlStateSelected];
        [[self lockDark] setSelected:YES];
        isDarkLocked = YES;
        [[self reverseButton] setUserInteractionEnabled:YES];
        [[self reverseButton] setHidden:NO];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Media/EdictusLocked/Light.png"] && [[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Media/EdictusLocked/Dark.png"]){
        [[self createButton] setUserInteractionEnabled:YES];
        [[self createButton] setAlpha:1.0];
    }
    if (isLightLocked || isDarkLocked) [self createWallpaperplist];
}

- (BOOL)isConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (IBAction)randomWallpapersAction:(id)sender {
    if (isLightLocked && isDarkLocked) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"All images are locked"
                                       message:@"Unlock one or more images to fetch random wallpapers."
                                       preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
           handler:nil];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
   if (![self isConnected]) {
       UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Not Connected"
                                      message:@"You need an active the internet connection in order to fetch random wallpapers."
                                      preferredStyle:UIAlertControllerStyleAlert];

       UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
          handler:^(UIAlertAction * action) {}];

       [alert addAction:defaultAction];
       [self presentViewController:alert animated:YES completion:nil];
       NSLog(@"Device is not connected, can't fetch images.");
   } else {
       [self fetchRandomWallpapers];
       NSLog(@"Device is connected, fetching images...");
   }
}

-(void)fetchRandomWallpapers {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Fetching..."
                                 message:@"Searching the best wallpapers for you 👀"
                                 preferredStyle:UIAlertControllerStyleAlert];
     
    [self presentViewController:alert animated:YES completion:^{
        NSString *picsumURL = [NSString stringWithFormat:@"https://picsum.photos/%.0f/%.0f", [UIScreen mainScreen].bounds.size.width*3, [UIScreen mainScreen].bounds.size.height*3];
        NSLog(@"%@", picsumURL);
        
        if (!self->isLightLocked) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picsumURL]]];
            self->_lightImageView.image = image;
            self->_lightThumbnail.image = image;
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
            [imageData writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Light.png"] atomically:YES];
        }
        
        if (!self->isDarkLocked) {
            UIImage *imageForDark = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picsumURL]]];
            self->_darkImageView.image = imageForDark;
            self->_darkThumbnail.image = imageForDark;
            NSData *imageDataForDark = [NSData dataWithData:UIImagePNGRepresentation(imageForDark)];
            [imageDataForDark writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Dark.png"] atomically:YES];
        }
        
        [self createWallpaperplist];
        if (self->_lightImageView.image != nil && self->_darkImageView.image != nil){
            [[self createButton] setUserInteractionEnabled:YES];
            [[self createButton] setAlpha:1.0];
            [[self reverseButton] setUserInteractionEnabled:YES];
            [[self reverseButton] setHidden:NO];
            [[self lockLight] setUserInteractionEnabled:YES];
            [[self lockLight] setHidden:NO];
            [[self lockDark] setUserInteractionEnabled:YES];
            [[self lockDark] setHidden:NO];
        }
    }];
    
    [alert dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reverseImagesAction:(id)sender {
    if (isLightLocked || isDarkLocked) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot reverse"
                                       message:@"One or more images are locked. Unlock images to reverse."
                                       preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {}];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    UIImage *image1 = _lightImageView.image;
    UIImage *image2 = _darkImageView.image;
    
    BOOL lightUserInteractionCached = self.lockLight.userInteractionEnabled;
    BOOL lightHiddenCached = self.lockLight.hidden;
    
    BOOL darkUserInteractionCached = self.lockDark.userInteractionEnabled;
    BOOL darkHiddenCached = self.lockDark.hidden;
    
    if (!isLightLocked && !isDarkLocked){
        _lightImageView.image = image2;
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(_lightImageView.image)];
        [imageData writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Light.png"] atomically:YES];
        _darkImageView.image = image1;
        NSData *imageData2 = [NSData dataWithData:UIImagePNGRepresentation(_darkImageView.image)];
        [imageData2 writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Dark.png"] atomically:YES];
        [[self lockLight] setUserInteractionEnabled:darkUserInteractionCached];
        [[self lockLight] setHidden:darkHiddenCached];
        
        [[self lockDark] setUserInteractionEnabled:lightUserInteractionCached];
        [[self lockDark] setHidden:lightHiddenCached];
    }
}


    
-(void)createFirstTimeMedia{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:@"/var/mobile/Media/Edictus"]){
        NSLog(@"Creating Edictus folder in Media");
        NSURL *newDir = [NSURL fileURLWithPath:@"/var/mobile/Media/Edictus"];
        [fileManager createDirectoryAtURL:newDir withIntermediateDirectories:YES attributes: nil error:nil];
    }
    if (![fileManager fileExistsAtPath:@"/var/mobile/Media/EdictusLocked"]){
        NSLog(@"Creating EdictusLocked folder in Media");
        NSURL *newDir = [NSURL fileURLWithPath:@"/var/mobile/Media/EdictusLocked"];
        [fileManager createDirectoryAtURL:newDir withIntermediateDirectories:YES attributes: nil error:nil];
    }
}

- (IBAction)lockLightAction:(id)sender {
    if ([sender isSelected]) {
       [sender setImage:[UIImage systemImageNamed:@"lock.open"] forState:UIControlStateNormal];
       [sender setSelected:NO];
        isLightLocked = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager removeItemAtPath:@"/var/mobile/Media/EdictusLocked/Light.png" error:&error];
    } else {
       [sender setImage:[UIImage systemImageNamed:@"lock"] forState:UIControlStateSelected];
       [sender setSelected:YES];
        isLightLocked = YES;
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(_lightImageView.image)];
        [imageData writeToFile:[@"/var/mobile/Media/EdictusLocked/" stringByAppendingPathComponent:@"Light.png"] atomically:YES];
    }
    
}

- (IBAction)lockDarkAction:(id)sender {
     if ([sender isSelected]) {
         [sender setImage:[UIImage systemImageNamed:@"lock.open"] forState:UIControlStateNormal];
         [sender setSelected:NO];
         isDarkLocked = NO;
         NSFileManager *fileManager = [NSFileManager defaultManager];
         NSError *error;
         [fileManager removeItemAtPath:@"/var/mobile/Media/EdictusLocked/Dark.png" error:&error];
       } else {
         [sender setImage:[UIImage systemImageNamed:@"lock"] forState:UIControlStateSelected];
         [sender setSelected:YES];
         isDarkLocked = YES;
         NSData *imageData2 = [NSData dataWithData:UIImagePNGRepresentation(_darkImageView.image)];
         [imageData2 writeToFile:[@"/var/mobile/Media/EdictusLocked/" stringByAppendingPathComponent:@"Dark.png"] atomically:YES];
    }
}


-(void)deleteStuff {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Are you sure to reset selected wallpapers?"
                                   message:@"This will delete all selected images even it is locked."
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        self->_lightImageView.image = nil;
        self->_darkImageView.image = nil;
        [[self createButton] setUserInteractionEnabled:NO];
        [[self createButton] setAlpha:0.5];
        [[self reverseButton] setUserInteractionEnabled:NO];
        [[self reverseButton] setHidden:YES];
        [[self lockLight] setUserInteractionEnabled:NO];
        [[self lockLight] setHidden:YES];
        [[self lockDark] setUserInteractionEnabled:NO];
        [[self lockDark] setHidden:YES];
        self->isLightLocked = NO;
        self->isDarkLocked = NO;
        // just to clean up
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager removeItemAtPath:@"/var/mobile/Media/Edictus/Light.png" error:&error];
        [fileManager removeItemAtPath:@"/var/mobile/Media/Edictus/Dark.png" error:&error];
        [fileManager removeItemAtPath:@"/var/mobile/Media/EdictusLocked/Light.png" error:&error];
        [fileManager removeItemAtPath:@"/var/mobile/Media/EdictusLocked/Dark.png" error:&error];
        [fileManager removeItemAtPath:@"/var/mobile/Media/Edictus/Wallpaper.plist" error:&error];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)deleteStuffWithoutAnAlert {
    _lightImageView.image = nil;
    _darkImageView.image = nil;
    [[self createButton] setUserInteractionEnabled:NO];
    [[self createButton] setAlpha:0.5];
    [[self reverseButton] setUserInteractionEnabled:NO];
    [[self reverseButton] setHidden:YES];
    [[self lockLight] setUserInteractionEnabled:NO];
    [[self lockLight] setHidden:YES];
    [[self lockDark] setUserInteractionEnabled:NO];
    [[self lockDark] setHidden:YES];
    isLightLocked = NO;
    isDarkLocked = NO;
    // just to clean up
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:@"/var/mobile/Media/Edictus/Light.png" error:&error];
    [fileManager removeItemAtPath:@"/var/mobile/Media/Edictus/Dark.png" error:&error];
    [fileManager removeItemAtPath:@"/var/mobile/Media/Edictus/Wallpaper.plist" error:&error];
    
    [self fetchLockedImages];
}

- (IBAction)deleteAction:(id)sender {
    [self deleteStuff];
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
- (void)copyChangeToMediaWithThisWallpaperPath:(NSString *)wallpaperName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //creating Edictus Folder in Media
    if (![fileManager fileExistsAtPath:@"/Library/WallpaperLoader"]){
        pid_t pid;
        const char* args[] = {"edictusroot", "mkdir", "/Library/WallpaperLoader", NULL};
        posix_spawn(&pid, "/usr/bin/edictusroot", NULL, NULL, (char* const*)args, NULL);
    }
    pid_t pid;
    const char* args[] = {"edictusroot", "mv", [wallpaperName cStringUsingEncoding:NSUTF8StringEncoding], "/Library/WallpaperLoader/", NULL};
    posix_spawn(&pid, "/usr/bin/edictusroot", NULL, NULL, (char* const*)args, NULL);
    [self fuckOffPreferences];
    printf("Successfully moved a folder\n");
}

-(void)fuckOffPreferences {
    pid_t pid;
    const char* args[] = {"killall", "Preferences", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (isDark){
        _darkImageView.image = image;
        _darkThumbnail.image = image;
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [imageData writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Dark.png"] atomically:YES];
        [[self reverseButton] setUserInteractionEnabled:YES];
        [[self reverseButton] setHidden:NO];
        [[self lockDark] setUserInteractionEnabled:YES];
        [[self lockDark] setHidden:NO];
    } else {
        _lightImageView.image = image;
        _lightThumbnail.image = image;
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [imageData writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Light.png"] atomically:YES];
        [[self reverseButton] setUserInteractionEnabled:YES];
        [[self reverseButton] setHidden:NO];
        [[self lockLight] setUserInteractionEnabled:YES];
        [[self lockLight] setHidden:NO];
    }
    [self createWallpaperplist];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (_lightImageView.image != nil && _darkImageView.image != nil){
        [[self createButton] setUserInteractionEnabled:YES];
        [[self createButton] setAlpha:1.0];
    }
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
        NSString *wallpaperNameInLibrary = [NSString stringWithFormat: @"%@%@", @"/Library/WallpaperLoader/",wallpaperName];
           if (![fileManager fileExistsAtPath: wallpaperNameInLibrary]){
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
                   
               }
               for (NSString *file in pngFiles) {
                   [fileManager moveItemAtPath:[mediaEdictus stringByAppendingPathComponent:file]
                               toPath:[wallpaperNameInMedia stringByAppendingPathComponent:file]
                                error:nil];
                   
               }
               for (NSString *file in plistFiles) {
                   [fileManager moveItemAtPath:[mediaEdictus stringByAppendingPathComponent:file]
                               toPath:[wallpaperNameInMedia stringByAppendingPathComponent:file]
                                error:nil];
                   
               }
               [self copyChangeToMediaWithThisWallpaperPath:wallpaperNameInMedia];
               
               UIAlertController * alert = [UIAlertController
                                            alertControllerWithTitle:@"Wallpaper Created"
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleAlert];

               //Add Buttons

               UIAlertAction* openSettings = [UIAlertAction
                                           actionWithTitle:@"Open Settings"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                                              // Open Wallpaper Settings
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"App-Prefs:Wallpaper"] options:@{} completionHandler:nil];
                   [self deleteStuffWithoutAnAlert];
                                           }];

               UIAlertAction* cancel = [UIAlertAction
                                          actionWithTitle:@"Cancel"
                                          style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action) {
                                              //Handle no, thanks button
                   [self deleteStuffWithoutAnAlert];
                                          }];

               //Add your buttons to alert controller

               [alert addAction:openSettings];
               [alert addAction:cancel];

               [self presentViewController:alert animated:YES completion:nil];
           }else{
               UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Wallpaper already exists"
                                              message:@"A Wallpaper with this name already exists, please change it in order to save it."
                                              preferredStyle:UIAlertControllerStyleAlert];

               UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction * action) {}];

               [alert addAction:defaultAction];
               [self presentViewController:alert animated:YES completion:nil];
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
