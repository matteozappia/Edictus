//
//  ViewController.h
//  EdictusOBJC
//
//  Created by Matteo Zappia on 08/03/2020.
//  Copyright © 2020 Matteo Zappia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lightThumbnail;
@property (strong, nonatomic) IBOutlet UIImageView *darkThumbnail;
@property (strong, nonatomic) IBOutlet UIView *thumbnailView;

@end

