/**
 * This file is part of the SYIMAmrCore Framework.
 * (c) Ree Sun <ree.sun.cn@hotmail.com || 1507602555@qq.com>
 *
 * For more information, please view SYIMRecorder (https://github.com/reesun1130/SYIMRecorder)
 */

#import <Foundation/Foundation.h>

@protocol SYAmrRecorderDelegate;

/**
 *  采用opencore本地做wav->amr格式互转
 *
 *  采样率8khz、单声道(默认左)、录制格式pcm
 *
 *  输出文件：amr，iOS&ANDROID通用
 *  输出文件大小：1s 3/5k,1min 3/5*60k 36-40k
 */
@interface SYIMAmrRecorder : NSObject

@property (nonatomic, weak) id <SYAmrRecorderDelegate> delegate;

/**
 *  是否正在录制
 */
@property (nonatomic, readonly) BOOL isRecording;

/**
 *  是否结束录制
 */
@property (nonatomic, readonly) BOOL isRecordEnd;

/**
 *  是否结束取消录制
 */
@property (nonatomic, readonly) BOOL isRecordCancled;

/**
 * 限制最长时间（每帧20ms，一秒［1000ms］50帧）(单位：s，默认：60s == 1min)
 */
@property (nonatomic, setter=setTheMaxRecordFrames:) NSUInteger maxRecordFrames;

/**
 * 限制最短时间 (单位：s，默认：1s)
 */
@property (nonatomic, setter=setTheMinRecordFrames:) NSUInteger minRecordFrames;

/**
 * 要保存的音频文件地址
 */
@property (nonatomic, copy, readonly) NSString *mPath;

/**
 * 当前录制时间 (单位：s)
 */
@property (nonatomic, readonly) NSUInteger recordFrames;

/**
 *  开始录制
 *
 *  @param path 要保存的音频文件地址（这个本地路径一定要是提前创建出来的）
 *
 *  @return 是否成功开始录制
 */
- (BOOL)sy_startRecordWithPath:(NSString *)path;

/**
 *  停止录制
 */
- (void)sy_stopRecord;

/**
 *  取消录制
 */
- (void)sy_cancleRecord;

/**
 *  录制时间太长
 *
 *  @return 是否录制时间太长 最长时间maxRecordFrames
 */
- (BOOL)sy_isRecordTooLong;

/**
 *  录制时间太短
 *
 *  @return 是否录制时间太长 最短时间minRecordFrames
 */
- (BOOL)sy_isRecordTooShort;

@end

@protocol SYAmrRecorderDelegate <NSObject>

@optional

/**
 *  动态更新音量波动
 *
 *  @param recorder SYAmrRecorderModel
 *  @param meters   波动大小(0-1)
 */
- (void)syAmrRecorder:(SYIMAmrRecorder *)recorder didUpdateMeters:(float)meters;

//监测录音状态请使用这些代理
- (void)syAmrRecorderDidStart:(SYIMAmrRecorder *)recorder;
- (void)syAmrRecorderDidStop:(SYIMAmrRecorder *)recorder;
- (void)syAmrRecorderDidCancled:(SYIMAmrRecorder *)recorder;
- (void)syAmrRecorderDidFail:(SYIMAmrRecorder *)recorder;

@end
