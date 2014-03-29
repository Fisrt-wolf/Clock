//
//  PlayMusicCtl.h
//  Clock
//
//  Created by apple on 14-2-27.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicCtl : NSObject<AVAudioPlayerDelegate>

@property (retain) AVAudioPlayer * _Mp3;

- (id)init:(NSString *)musicName;
- (void)playMusic;
- (void)stopPlay;

@end
