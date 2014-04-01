//
//  AddClockCtl.h
//  Clock
//
//  Created by apple on 14-2-23.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddClockCtlDelegate
- (void)clockInfo:(NSInteger)repeatInter musicName:(NSString *)musicName clockTime:(NSDate *)clockTime;
@end
enum{
    None,
    RepeatType,
    MusicType
};
typedef NSInteger TableViewType;

@interface AddClockCtl : UIViewController
{
    TableViewType _showType;
    id<AddClockCtlDelegate>  _delegate;

}
@property(retain,nonatomic)id <AddClockCtlDelegate> delegate;
@property(strong,nonatomic)IBOutlet UIDatePicker    * _dataPicker;
@property(strong,nonatomic)IBOutlet UITableView     *_tableView;
@property(copy,nonatomic)NSArray    * _array;
@property(copy,nonatomic)NSArray    * _musicArray;
@property(copy,nonatomic)NSArray    * _repeatArray;
@property(copy,nonatomic)NSMutableArray *_showArray;
@property(copy,nonatomic)NSString   * _repeatDetailStr;
@property(copy,nonatomic)NSString   * _musicName;
@property(copy,nonatomic)NSDate     * _date;
@property(nonatomic)int             _repeatInteger;

@property(copy,nonatomic)NSMutableArray *_repeatSelectArray;
@property(copy,nonatomic)NSIndexPath    *_musicIndexPath;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

- (NSString *)getRepeatDetailStr:(NSArray *)selectArray;
- (NSString *)getRepeatDetailStrWithInteger:(NSInteger)integer;
- (BOOL)getN:(int)N integer:(int)integer;
@end
