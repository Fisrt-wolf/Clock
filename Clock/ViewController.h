//
//  ViewController.h
//  Clock
//
//  Created by apple on 14-2-23.
//  Copyright (c) 2014年 apple. All rights reserved.
//


#define RepeatArray     @"repeatArray"
#define MusicFilePath   @"musicFilePath"
#define ClockTime       @"clockTime"

#import <UIKit/UIKit.h>
#import "AddClockCtl.h"
@class MusicCtl;
@interface ViewController : UIViewController<UITableViewDataSource,UITabBarDelegate,AddClockCtlDelegate>
{
    
}
@property(strong,nonatomic)IBOutlet     UITableView     *_tableView;
@property(copy,nonatomic)NSMutableArray     * array;
@property(retain,nonatomic)NSMutableArray   * _clocksArray;
@property (strong, nonatomic) AddClockCtl   *_addClockCtl;
@property(retain)MusicCtl   * _musicCtl;

- (IBAction)exit:(id)sender;

- (void)saveData;

@end
