//
//  AddClockCtl.m
//  Clock
//
//  Created by apple on 14-2-23.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "AddClockCtl.h"

@interface AddClockCtl ()

@end

@implementation AddClockCtl
@synthesize delegate = _delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self._array         = [NSArray arrayWithObjects:@"Repeat",@"Music", nil];
        self._repeatArray   = [NSArray arrayWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
        self._musicArray    = [NSArray arrayWithObjects:@"music",@"music2", nil];
        self._showArray     = [NSMutableArray arrayWithArray:self._array];
        self._musicName     = @"";
        _showType = None;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    
    if (_showType == None && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellStyleValue2;
        cell.detailTextLabel.text = self._repeatDetailStr;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = @"";
    }
    
    cell.textLabel.text = self._showArray[indexPath.row];
    
    return cell;
}


//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showType == RepeatType || _showType == MusicType) {
        return;
    }
    if (indexPath.row == 0) {
        _showType = RepeatType;
        [self setShowArray:self._repeatArray];
        [self._tableView reloadData];
    }else if (indexPath.row == 1){
        _showType = MusicType;
        [self setShowArray:self._musicArray];
        [self._tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_showType == RepeatType) {
        self._tableView.allowsMultipleSelection = true;
    }else{
        self._tableView.allowsMultipleSelection = false;
    }
    return [self._showArray count];
}

- (IBAction)cancel:(id)sender
{
    if (_showType == None) {
        [self.view removeFromSuperview];
    }else if (_showType == MusicType || _showType == RepeatType) {
        _showType = None;
        [self setShowArray:self._array];
        [self._tableView reloadData];
    }
    
}


- (IBAction)save:(id)sender
{
    
    if (_showType == None) {
        [_delegate clockInfo:self._repeatSelectArray musicName:self._musicName clockTime:self._dataPicker.date];
        [self.view removeFromSuperview];
    }
    
    if(_showType == RepeatType)
    {
        self._repeatSelectArray = [NSMutableArray arrayWithArray:[self._tableView indexPathsForSelectedRows]];
        [self getRepeatDetailStr:self._repeatSelectArray];
        self._date = self._dataPicker.date;
    }
    
    if (_showType == MusicType) {
        NSArray * tArray = [self._tableView indexPathsForSelectedRows];
        if ([tArray count] > 0) {
            self._musicIndexPath = [tArray objectAtIndex:0];
            [self getMusicName:self._musicIndexPath];
        }
    }
    
    if (_showType == MusicType || _showType == RepeatType) {
        _showType = None;
        [self setShowArray:__array];
        [self._tableView reloadData];
    }
    
}

- (NSMutableArray *)setShowArray:(NSArray *)array
{
    self._showArray = [NSMutableArray arrayWithArray:array];
    return self._showArray;
}

- (NSString *)getRepeatDetailStr:(NSArray *)selectArray
{
    self._repeatDetailStr = @"";
    
    if ([selectArray count] == 7) {
        self._repeatDetailStr = @"Every Day";
        return self._repeatDetailStr;
    }
    
    for (NSIndexPath *index in selectArray) {

        NSInteger integer = [index indexAtPosition:1];
        switch (integer) {
            case 0:
                self._repeatDetailStr = [NSString stringWithFormat:@"Mon %@",self._repeatDetailStr];
                break;
            case 1:
                self._repeatDetailStr = [NSString stringWithFormat:@"Tue %@",self._repeatDetailStr];
                break;
            case 2:
                self._repeatDetailStr = [NSString stringWithFormat:@"Wed %@",self._repeatDetailStr];
                break;
            case 3:
                self._repeatDetailStr = [NSString stringWithFormat:@"Thu %@",self._repeatDetailStr];
                break;
            case 4:
                self._repeatDetailStr = [NSString stringWithFormat:@"Fri %@",self._repeatDetailStr];
                break;
            case 5:
                self._repeatDetailStr = [NSString stringWithFormat:@"Sta %@",self._repeatDetailStr];
                break;
            case 6:
                self._repeatDetailStr = [NSString stringWithFormat:@"Sun %@",self._repeatDetailStr];
                break;
                
            default:
                break;
        }
    }
    return self._repeatDetailStr;
}


- (NSString *)getMusicName:(NSIndexPath *)musicIndexPath
{
    if ([musicIndexPath length] <= 0) {
        return @"Frist";
    }
    switch ([musicIndexPath indexAtPosition:1]) {
        case 0:
            self._musicName = @"Frist";
            break;
        case 1:
            self._musicName = @"Second";
            break;
            
        default:
            break;
    }
    return self._musicName;
}
@end
