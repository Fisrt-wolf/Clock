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
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"",ClockTime, nil];
    self.array = [NSArray arrayWithObjects:@"Add Clock", nil];
//    [self.array writeToFile:[self dataFilePath] atomically:YES];
   
    self._addClockCtl = [[AddClockCtl alloc] initWithNibName:@"AddClock" bundle:nil];
    self._addClockCtl.delegate = self;
    self._clocksArray = [NSMutableArray array];

//    self._clocksArray = [NSMutableArray arrayWithArray:[self getClockData]];
    

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[self._clocksArray count]+1);
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
        cell.detailTextLabel.text = [self._addClockCtl getRepeatDetailStr:[tDic objectForKey:RepeatArray]];
    }
    
    return cell;
}



//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.view addSubview:self._addClockCtl.view];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"clock";
}

- (void)clockInfo:(NSArray *)repeatArray musicName:(NSString *)musicName clockTime:(NSDate *)clockTime
{
    [self setClocksDic:repeatArray musicName:musicName clockTime:clockTime];
}

- (void)setClocksDic:(NSArray *)repeatArray musicName:(NSString *)musicName clockTime:(NSDate *)clockTime
{
    NSDictionary * tClockDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                repeatArray,RepeatArray,
                                musicName,MusicFilePath,
                                clockTime,ClockTime,nil];
    tClockDic = nil;
    NSDictionary * ttClockDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSIndexPath alloc] initWithIndex:0],RepeatArray, nil];
    [self._clocksArray addObject:ttClockDic];
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
    
    tClockCellTxt = [NSString stringWithFormat:@"%@ %d:%d",tClockCellTxt,hour,min];
    return tClockCellTxt;
}

- (IBAction)exit:(id)sender
{
    [self saveData];
//    exit(0);
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
    NSArray     * tReapeatArray = [dic objectForKey:RepeatArray];
    NSString    * tMusicName = [dic objectForKey:MusicFilePath];
    
    NSInteger  tWeekDay = [self getWeekdayWithDate:tDate];
    NSInteger  tRepeatWeekDay = 0;

    for (NSIndexPath *index in tReapeatArray) {
        NSDate * clockDate = tDate;
        NSInteger           integer = [index indexAtPosition:1];
        if (integer + 1 >= tWeekDay) {
            tRepeatWeekDay = integer - tWeekDay + 2;
        }else{
            tRepeatWeekDay = integer + 8 - tWeekDay;
        }
        
        clockDate = [tDate dateByAddingTimeInterval:tRepeatWeekDay*24*60*60];
        
        [self setClockWithTime:clockDate repeat:TRUE musicName:tMusicName];
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
//    DataSave * tDataSave = [[DataSave alloc] init];
//    tDataSave.clockDates = self._clocksArray;
//    NSMutableData * tData = [[NSMutableData alloc] init];
//    NSKeyedArchiver * tArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:tData];
//    [tArchiver encodeObject:tDataSave forKey:kRootClockDate];
//    [tArchiver finishEncoding];
    
    [[[NSArray alloc ]initWithArray:self._clocksArray] writeToFile:[self dataFilePath] atomically:YES];
    NSArray * arr = [NSArray arrayWithContentsOfFile:[self dataFilePath]];
    NSLog(@"%@",[arr objectAtIndex:0]);
    return;
    NSArray * tSaveArray = [NSArray arrayWithArray:self._clocksArray];
    [tSaveArray writeToFile:[self dataFilePath] atomically:YES];

    NSArray * a = [NSArray arrayWithContentsOfFile:[self dataFilePath]];
   // [tData writeToFile:tFilePath atomically:YES];
    
}

- (NSArray *)getClockData
{
    NSLog(@"get data");
    NSString    * tFilePath = [self dataFilePath];
//    NSData      * tData = [[NSMutableData alloc] initWithContentsOfFile:tFilePath];
//    NSKeyedUnarchiver * tUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:tData];
//    DataSave * tDataSave = [tUnarchiver decodeObjectForKey:kRootClockDate];
//    [tUnarchiver finishDecoding];
    NSArray * arry = [NSArray arrayWithContentsOfFile:tFilePath];
    return  arry;
//    if (!tDataSave.clockDates) {
//        return [NSArray array];
//    }
//    
//    return tDataSave.clockDates;
}
@end
