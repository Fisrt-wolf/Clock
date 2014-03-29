//
//  PlayMusicCtl.m
//  Clock
//
//  Created by apple on 14-2-27.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MusicCtl.h"

@implementation MusicCtl

- (id)init:(NSString *)musicName
{
    if (self == [super init]) {
        NSString * tMusicPath = [[NSBundle mainBundle] pathForResource:musicName ofType:@"mp3"];
        NSURL * tFileURL = [NSURL fileURLWithPath:tMusicPath];
        self._Mp3 = [[[AVAudioPlayer alloc] initWithContentsOfURL:tFileURL error:nil] autorelease];
        self._Mp3.numberOfLoops = 0;//播放次数 0为1次 1为两次
        self._Mp3.volume = 1;
    }
    return self;
}

- (void)playMusic
{
    if (self._Mp3) {
        [self._Mp3 play];//播放音乐
    }
}


- (void)stopPlay
{
    if (self._Mp3) {
        [self._Mp3 stop];
    }
}

@end
