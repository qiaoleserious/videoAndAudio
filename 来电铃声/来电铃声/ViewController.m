//
//  ViewController.m
//  来电铃声
//
//  Created by 乔乐 on 2017/9/12.
//  Copyright © 2017年 乔乐. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "voiceButton.h"
@interface ViewController ()
@property(nonatomic,strong)NSTimer * voice_timer;
@property(nonatomic,strong)NSTimer * vibrate_timer;
@end

@implementation ViewController
SystemSoundID sound = kSystemSoundID_Vibrate;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self set_music];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn setTitle:@"来电声音" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    voiceButton * btn1 = [[voiceButton alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    [btn1 setTitle:@"按键音" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor blackColor];
    [btn1 addTarget:self action:@selector(btn1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

- (void)set_music
{
    //使用自定义铃声
    NSString *path = [[NSBundle mainBundle] pathForResource:@"call_ring2"ofType:@"wav"];
    //需将音频资源copy到项目<br>
    if (path)
    {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
        if (error != kAudioServicesNoError)
        {
            sound = 0;
        }
    }

}
- (void)btn1
{
    [_voice_timer invalidate];
    [_vibrate_timer invalidate];
    AudioServicesDisposeSystemSoundID(sound);
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
}


- (void)btn
{
     AudioServicesPlaySystemSound(sound);//播放声音
    _voice_timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(voice) userInfo:nil repeats:YES];
    _vibrate_timer = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(vibrate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_voice_timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop]addTimer:_vibrate_timer forMode:NSRunLoopCommonModes];
}

- (void)voice
{
    AudioServicesPlaySystemSound(sound);//播放声音
}

- (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//静音模式下震动
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
