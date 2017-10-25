//
//  ViewController.m
//  音频采集播放(c711编解码)
//
//  Created by 乔乐 on 2017/9/11.
//  Copyright © 2017年 乔乐. All rights reserved.
//

#import "ViewController.h"
#import "ql_baseButton.h"
#import "PCMDataPlayer.h"
#import "PCMAudioRecorder.h"
#import "TEST.h"//g711编解码
@interface ViewController ()<PCMAudioRecorderDelegate>
@property(nonatomic,strong)PCMAudioRecorder * pcmRecorder;
@property(nonatomic,strong)PCMDataPlayer * pcmPlayer;
@property(nonatomic,assign)BOOL silence;//是否静音状态
@property(nonatomic,assign)BOOL loudly;//麦克风是否外放
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loudly = 1;
    
    _pcmRecorder = [[PCMAudioRecorder alloc]init];
    _pcmRecorder.delegate = self;
    
    _pcmPlayer = [[PCMDataPlayer alloc]init];
    
    ql_baseButton * recoder = [[ql_baseButton alloc]init_with_frame:CGRectMake(50, 100, 40, 20) and_name:@"录制"];
    recoder.block = ^(ql_baseButton *btn)
    {
        [_pcmRecorder startRecordWith:self.loudly];
    };
    
    ql_baseButton * silence = [[ql_baseButton alloc]init_with_frame:CGRectMake(50, 200, 40, 20) and_name:@"静音"];
    silence.block = ^(ql_baseButton *btn)
    {
        self.silence = !self.silence;
    };
    
    ql_baseButton * loud =  [[ql_baseButton alloc]init_with_frame:CGRectMake(150, 200, 40, 20) and_name:@"扩音"];
    loud.block = ^(ql_baseButton *btn)
    {
        self.loudly = !self.loudly;
        if (self.loudly)
        {
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        }else
        {
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        }
    };
    [self.view addSubview:recoder];
    [self.view addSubview:silence];
    [self.view addSubview:loud];
}

- (void)DidGetAudioData:(void *const)buffer size:(int)dataSize andPts:(long long)pts
{
    if (self.silence)
    {
        return;
    }
    //pcmu 编码
    unsigned char requestBuf[dataSize / 2];
    G711Encoder(buffer, requestBuf, (int)dataSize / 2, 1);
    //解码
    short decodeBuf[dataSize];
    G711Decode(decodeBuf, requestBuf,dataSize);
    //播放
    [self.pcmPlayer play:decodeBuf length:dataSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
