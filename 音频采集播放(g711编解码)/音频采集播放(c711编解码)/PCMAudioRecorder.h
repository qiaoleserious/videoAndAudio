//
//  PCMAudioRecorder.h
//  AVSamplePlayer
//
//  Created by bingcai on 16/8/23.
//  Copyright © 2016年 sharetronic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define QUEUE_BUFFER_SIZE 3//队列缓冲个数
//#define MIN_SIZE_PER_FRAME 2048//每帧最小数据长度

@protocol PCMAudioRecorderDelegate <NSObject>

- (void)DidGetAudioData:(void * const)buffer size:(int)dataSize andPts:(long long)pts;

@end

@interface PCMAudioRecorder : NSObject

@property(nonatomic, weak) id<PCMAudioRecorderDelegate> delegate;
@property(nonatomic,assign) BOOL isrecording;
@property(nonatomic,assign)unsigned int timeScale;
- (void)stopRecord;
- (void)startRecordWith:(BOOL)isSpeaker;
- (void)start;
@end
