//
//  ViewController.m
//  Clock
//
//  Created by apple on 14-2-23.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "ViewController.h"
#import "AddClockCtl.h"
#include <AVFoundation/AVFoundation.h>
#import "DataSave.h"

static NSString * const kRootClockDate = @"RootClockDate";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.array = [NSMutableArray arrayWithObjects:@"Add Clock", nil];
    self._addClockCtl = [[AddClockCtl alloc] initWithNibName:@"AddClock" bundle:nil];
    self._addClockCtl.delegate = self;
    self._clocksArray = [NSMutableArray array];

    self._clocksArray = [NSMutableArray arrayWithArray:[self getClockData]];
    

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._clocksArray count]+1;
}

//内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        
    }
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"Add.png"];
        cell.textLabel.text = self.array[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }else{
        NSDictionary * tDic = self._clocksArray[indexPath.row-1];
        cell.textLabel.text = [self clockCellTxt:[tDic objectForKey:ClockTime]];
        cell.detailTextLabel.text = [self._addClockCtl getRepeatDetailStrWithInteger:[[tDic objectForKey:RepeatArray] integerValue]];
    }
    
    return cell;
}

//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.view addSubview:self._addClockCtl.view];
    }else{
        UIAlertView * tAlertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Are you want to delete it !" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        NSInteger inter = [tAlertView show];
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"clock";
}

- (void)clockInfo:(NSInteger)repeatInter musicName:(NSString *)musicName clockTime:(NSDate *)clockTime
{
    [self setClocksDic:repeatInter musicName:musicName clockTime:clockTime];
}

- (void)setClocksDic:(NSInteger)repeatInter musicName:(NSString *)musicName clockTime:(NSDate *)clockTime
{
    NSDictionary * tClockDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInteger:repeatInter],RepeatArray,
                                musicName,MusicFilePath,
                                clockTime,ClockTime,nil];

    [self._clocksArray addObject:tClockDic];
    [self saveData];
    [self setClockWithDic:tClockDic];
    [self._tableView reloadData];
    
}

#pragma mark -
#pragma mark Date

- (NSDateComponents *)getDateComponents:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    return comps;
}

- (int)getYearWithDate:(NSDate *)date
{
    NSDateComponents * tComps = [self getDateComponents:date];
    return [tComps year];
}

- (int)getDayWithDate:(NSDate *)date
{
    NSDateComponents * tComps = [self getDateComponents:date];
    return [tComps day];
}

- (int)getMonthWithDate:(NSDate *)date
{
    NSDateComponents * tComps = [self getDateComponents:date];
    return [tComps month];
}

- (int)getHourWithDate:(NSDate *)date
{
    NSDateComponents * tComps = [self getDateComponents:date];
    return [tComps hour];
}

- (int)getMinuteWithDate:(NSDate *)date
{
    NSDateComponents * tComps = [self getDateComponents:date];
    return [tComps minute];
}


- (NSInteger)getWeekdayWithDate:(NSDate *)date
{
    NSDateComponents * tComps = [self getDateComponents:date];
    return [tComps weekday];
}


- (NSInteger)getWeekWithDate:(NSDate *)date
{
    NSDateComponents * tComps = [self getDateComponents:date];
    return [tComps week];
}

- (NSString *)clockCellTxt:(NSDate *)date
{
    NSString * tClockCellTxt = @"AM";
    int hour = [self getHourWithDate:date];
    int min  = [self getMinuteWithDate:date];
    if (hour >= 12) {
        tClockCellTxt = @"PM";
    }
    NSString * tHourStr = @"";
    if (hour < 10) {
        tHourStr = [NSString stringWithFormat:@"0%d",hour];
    }else{
        tHourStr = [NSString stringWithFormat:@"%d",hour];
    }
    
    NSString * tMinStr = @"";
    if (min < 10) {
        tMinStr = [NSString stringWithFormat:@"0%d",min];
    }else{
        tMinStr = [NSString stringWithFormat:@"%d",min];
    }
    
    tClockCellTxt = [NSString stringWithFormat:@"%@ %@:%@",tClockCellTxt,tHourStr,tMinStr];
    return tClockCellTxt;
}

- (IBAction)exit:(id)sender
{
    [self saveData];
    exit(0);
}

- (void)playMusic
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    AVPlayer * player = [AVPlayer playerWithURL:[NSURL URLWithString:@"/Users/apple/Desktop/Test.mp3"]];
    [player play];

}

#pragma mark -
#pragma mark clock
- (void)setClockWithTime:(NSDate *)date repeat:(BOOL)repeat musicName:(NSString *)musicName
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        notification.fireDate=date;
        notification.repeatInterval=repeat?kCFCalendarUnitWeekday:0;//repeat?HUGE_VALF:0;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber=1; //应用的红色数字
        notification.soundName= musicName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        notification.alertBody=@"通知内容";//提示信息 弹出提示框
        notification.alertAction = @"打开";  //提示框按钮
        
        //notification.userInfo = infoDict; //添加额外的信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    [notification release];
}


- (void)setClockWithDic:(NSDictionary *)dic
{
    NSDate      * tDate = [dic objectForKey:ClockTime];
    NSInteger    tRepeatInteger = [[dic objectForKey:RepeatArray] integerValue];
    NSString    * tMusicName = [dic objectForKey:MusicFilePath];
    
    NSInteger  tWeekDay = [self getWeekdayWithDate:tDate];
    NSInteger  tRepeatWeekDay = 0;

    for (int index = 0; index < 7; index++) {
        NSDate * clockDate = tDate;
        if ([self._addClockCtl getN:index integer:tRepeatInteger]) {
            if (index + 1 >= tWeekDay) {
                tRepeatWeekDay = index - tWeekDay + 2;
            }else{
                tRepeatWeekDay = index + 8 - tWeekDay;
            }
            
            clockDate = [tDate dateByAddingTimeInterval:tRepeatWeekDay*24*60*60];
            
            [self setClockWithTime:clockDate repeat:TRUE musicName:tMusicName];
        }
    }
}

#pragma mark -
#pragma mark Data
- (NSString *)dataFilePath
{
    NSArray * tPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * tDocumentsDirectory = [tPaths objectAtIndex:0];
    return [tDocumentsDirectory stringByAppendingPathComponent:@"data.plist"];
}

- (void)saveData
{
    NSString * tFilePath = [self dataFilePath];
    
    [[[NSArray alloc ]initWithArray:self._clocksArray] writeToFile:tFilePath atomically:YES];
    
}

- (NSArray *)getClockData
{
    NSLog(@"get data");
    NSString    * tFilePath = [self dataFilePath];
    NSArray * arry = [NSArray arrayWithContentsOfFile:tFilePath];
    return  arry;

}
@end
