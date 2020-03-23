//
//  LiveViewController.m
//  EdictusOBJC
//
//  Created by Matteo Zappia on 09/03/2020.
//  Copyright © 2020 Matteo Zappia. All rights reserved.
//

#import "LiveViewController.h"

@interface LiveViewController ()
{
    AVPlayer *player;
}
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UIView *thumbnailView;
@property (strong, nonatomic) IBOutlet UIButton *selectVideoButton;
@property (strong, nonatomic) IBOutlet UIButton *videoPlayingButton;
@property (strong, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIButton *createButton;
@end

@implementation LiveViewController

NSURL *videoURL;
AVPlayerItem *item;


- (void)viewDidLoad {
    [super viewDidLoad];
    item = [AVPlayerItem playerItemWithURL:videoURL];
    _videoView.layer.cornerRadius = 13.5;
    _videoView.layer.masksToBounds = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE d MMMM"];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    self.currentDateLabel.text = [[dateFormatter stringFromDate:[NSDate date]] uppercaseString];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Date"] == YES){
    [_currentDateLabel setHidden: NO];
    }else{
    [_currentDateLabel setHidden: YES];
    }
    // Do any additional setup after loading the view.
}

- (IBAction)deleteAction:(id)sender {
    [self deleteStuff];
}

-(void)deleteStuff{
    videoURL = nil;
    item = nil;
    [player replaceCurrentItemWithPlayerItem:item];
    [[self videoPlayingButton] setHidden:YES];
    [[self selectVideoButton] setHidden:NO];
    [[self createButton] setUserInteractionEnabled:NO];
    [[self createButton] setAlpha:0.5];
    // just to clean up
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:@"/var/mobile/Media/Edictus/Default.m4v" error:&error];
    [fileManager removeItemAtPath:@"/var/mobile/Media/Edictus/Default.png" error:&error];
    [fileManager removeItemAtPath:@"/var/mobile/Media/Edictus/Wallpaper.plist" error:&error];
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
                                                        "<key>defaultImage</key>\n"
                                                        "<string>Default.png</string>\n"
                                                        "<key>defaultVideo</key>\n"
                                                        "<string>Default.m4v</string>\n"
                                                        "<key>wallpaperType</key>\n"
                                                        "<integer>1</integer>\n"
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


- (IBAction)videoButtonPressed:(id)sender {
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self; // ensure you set the delegate so when a video is chosen the right method can be called

    videoPicker.modalPresentationStyle = UIModalPresentationPopover;
    // This code ensures only videos are shown to the end user
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    videoPicker.videoMaximumDuration = 3;
    videoPicker.allowsEditing = YES;

    videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    [self presentViewController:videoPicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    // This is the NSURL of the video object
    videoURL = [info objectForKey:UIImagePickerControllerMediaURL];

    NSLog(@"VideoURL = %@", videoURL);
    
    item = [AVPlayerItem playerItemWithURL:videoURL];
    player = [AVPlayer playerWithPlayerItem:item];
    player.volume = 0.0;
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = _videoView.layer.bounds;
    
    [_videoView.layer addSublayer:layer];
    [[self videoPlayingButton] setHidden:NO];
    
    [[self selectVideoButton] setHidden:YES];
    
    if (item != nil){
        [[self createButton] setUserInteractionEnabled:YES];
        [[self createButton] setAlpha:1.0];
    }
    NSData *urlData = [NSData dataWithContentsOfURL:videoURL];
    if ( urlData )
    {
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", @"/var/mobile/Media/Edictus/",@"Default.m4v"];
        [urlData writeToFile:filePath atomically:YES];

    }
    
    [self createWallpaperplist];
    
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    [imageGenerator setAppliesPreferredTrackTransform:TRUE];
    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
           [imageData writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Default.png"] atomically:YES];
    _thumbnailImageView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)playButtonPressed:(id)sender {
    [[self videoPlayingButton] setAlpha:0.2];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:videoURL];
    player = [AVPlayer playerWithPlayerItem:item];
    player.volume = 0.0;
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = _videoView.layer.bounds;
    [player play];
    
    [_videoView.layer addSublayer:layer];
    //[[self videoPlayingButton] setHidden:NO];
    [[self videoPlayingButton] setImage: [UIImage systemImageNamed:@"pause.circle.fill"] forState:UIControlStateNormal];
    
    //player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    NSLog(@"videofinished");
    [[self videoPlayingButton] setAlpha:1.0];
    [[self videoPlayingButton] setImage: [UIImage systemImageNamed:@"play.circle.fill"] forState:UIControlStateNormal];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:videoURL];
    player = [AVPlayer playerWithPlayerItem:item];
    player.volume = 0.0;
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = _videoView.layer.bounds;
    [_videoView.layer addSublayer:layer];
    //[[self videoPlayingButton] setHidden:NO];
    [player seekToTime:kCMTimeZero];
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
                  
                  /* NOT NEEDED ATM, WALLPAPERLOADER HAS NO-THUMBNAIL FOR LIVE WALLPAPERS.(BUT WOULD BE USEFUL IN FUTURE) *DO NOT DELETE IT*
                
                  // CREATE THUMBNAIL (FOR DEFAULT.PNG)
                UIImage *thumbnailImage = [self imageWithView:[self thumbnailView]];
                NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(thumbnailImage)];
                [imageData writeToFile:[@"/var/mobile/Media/Edictus/" stringByAppendingPathComponent:@"Default.png"] atomically:YES];
                  */
                  
                  // Get all files at /var/mobile/Media/Edictus/
                  NSArray *files = [fileManager contentsOfDirectoryAtPath:mediaEdictus error:nil];
                  NSArray *mv4Files = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.m4v'"]];
                  NSArray *pngFiles = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.png'"]];
                  NSArray *plistFiles = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.plist'"]];
                  
                  // Move all files to bundle created
                
                  for (NSString *file in mv4Files) {
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
                      [self deleteStuff];
                                              }];

                  UIAlertAction* cancel = [UIAlertAction
                                             actionWithTitle:@"Cancel"
                                             style:UIAlertActionStyleCancel
                                             handler:^(UIAlertAction * action) {
                                                 //Handle no, thanks button
                      [self deleteStuff];
                                             }];

                  //Add your buttons to alert controller

                  [alert addAction:openSettings];
                  [alert addAction:cancel];

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






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
