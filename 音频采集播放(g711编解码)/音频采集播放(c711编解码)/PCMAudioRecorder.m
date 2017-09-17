//
//  PCMAudioRecorder.m
//  AVSamplePlayer
//
//  Created by bingcai on 16/8/23.
//  Copyright © 2016年 sharetronic. All rights reserved.
//

#import "PCMAudioRecorder.h"

#define kDefaultBufferDurationSeconds 0.02   //调整这个值使得录音的缓冲区大小为2048bytes
#define kDefaultSampleRate 8000   //定义采样率为8000

@implementation PCMAudioRecorder
{
    AudioStreamBasicDescription _audioDescription;
    AudioQueueRef               _audioQueue;
    AudioQueueBufferRef         _audioQueueBuffers[QUEUE_BUFFER_SIZE];
}

static void AQInputCallback (
                             void * __nullable               inUserData,
                             AudioQueueRef                   inAQ,
                             AudioQueueBufferRef             inBuffer,
                             const AudioTimeStamp *          inStartTime,
                             UInt32                          inNumberPacketDescriptions,
                             const AudioStreamPacketDescription * __nullable inPacketDescs)
{
    PCMAudioRecorder *recorder = (__bridge PCMAudioRecorder *)inUserData;
    if (inNumberPacketDescriptions > 0)
    {
        [recorder processAudioBuffer:inBuffer];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //采样率
        _audioDescription.mSampleRate = kDefaultSampleRate;
        //编码格式
        _audioDescription.mFormatID = kAudioFormatLinearPCM;
        _audioDescription.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        //每包的帧数
        _audioDescription.mFramesPerPacket = 1;
        //声道
        _audioDescription.mChannelsPerFrame = 1;
        //
        _audioDescription.mBitsPerChannel = 16;
        //每包的字节数
        _audioDescription.mBytesPerPacket = (_audioDescription.mBitsPerChannel / 8) * _audioDescription.mChannelsPerFrame;
        //每帧的字节数
        _audioDescription.mBytesPerFrame = _audioDescription.mBytesPerPacket;
        
        AudioQueueNewInput(&_audioDescription, AQInputCallback, (__bridge void * _Nullable)(self), nil, 0, 0, &_audioQueue);
        //计算估算的缓存区大小
        int frames = (int)ceil(kDefaultBufferDurationSeconds * _audioDescription.mSampleRate); //返回大于或者等于指定表达式的最小整数
        int bufferSize = frames *_audioDescription.mBytesPerFrame;  //缓冲区大小在这里设置，这个很重要，在这里设置的缓冲区有多大，那么在回调函数的时候得到的inbuffer的大小就是多大。
        bufferSize = 2048;  //必须是80的倍数
        for (int i = 0; i < QUEUE_BUFFER_SIZE; i ++)
        {
            //为这个音频队列分配缓冲区
            AudioQueueAllocateBuffer(_audioQueue, bufferSize, &_audioQueueBuffers[i]);
            
            AudioQueueEnqueueBuffer(_audioQueue, _audioQueueBuffers[i], 0, NULL);
        }
    }
    return self;
}

- (void)startRecordWith:(BOOL)isSpeaker
{
    if (isSpeaker)
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    }
    else
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];}
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        OSStatus status = AudioQueueStart(_audioQueue, NULL);
    if (status  != noErr)
    {
        NSLog(@"AudioQueueStart Error: %d", (int)status);
    }
    self.isrecording = YES;
}

- (void)start
{
    OSStatus status = AudioQueueStart(_audioQueue, NULL);
    if (status  != noErr)
    {
        NSLog(@"AudioQueueStart Error: %d", (int)status);
    }
    self.isrecording = YES;
}

- (void) stopRecord
{
    self.isrecording = NO;
    AudioQueueStop(_audioQueue, true);
    AudioQueueDispose(_audioQueue, false);//移除缓冲区,true代表立即结束录制，false代表将缓冲区处理完再结束
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    _audioQueue = nil;
}
- (void)dealloc
{
    if (_audioQueue != nil)
    {
        AudioQueueStop(_audioQueue,true);
    }
    _audioQueue = nil;
    printf("recoder dealloc...");
}

- (void)processAudioBuffer:(AudioQueueBufferRef)buffer
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    long startTime = [defaults integerForKey:@"startTime"];
    self.timeScale = ([[NSDate date] timeIntervalSince1970]*1000*1000-startTime)*0.008;
    if ([self.delegate respondsToSelector:@selector(DidGetAudioData:size:andPts:)])
    {
        [self.delegate DidGetAudioData:buffer->mAudioData size:buffer->mAudioDataByteSize andPts:self.timeScale];
    }
    if (self.isrecording)
    {
        AudioQueueEnqueueBuffer(_audioQueue, buffer, 0, NULL);
    }
}

@end
