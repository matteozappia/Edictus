//
//  WallpapersTableViewController.h
//  EdictusOBJC
//
//  Created by Matteo Zappia on 16/03/2020.
//  Copyright © 2020 Matteo Zappia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <spawn.h>

NS_ASSUME_NONNULL_BEGIN

@interface WallpapersTableViewController : UITableViewController
@property (nonatomic, copy, readwrite) NSArray* dirs;
@end

NS_ASSUME_NONNULL_END
