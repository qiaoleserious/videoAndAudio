//
//  voiceButton.m
//  来电铃声
//
//  Created by 乔乐 on 2017/9/13.
//  Copyright © 2017年 乔乐. All rights reserved.
//

#import "voiceButton.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation voiceButton

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [super touchesBegan:touches withEvent:event];
    [self play_sound];
}

- (void)play_sound
{
    AudioServicesPlaySystemSound(1105);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
