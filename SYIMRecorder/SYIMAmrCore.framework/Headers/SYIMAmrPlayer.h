/**
 * This file is part of the SYIMAmrCore Framework.
 * (c) Ree Sun <ree.sun.cn@hotmail.com || 1507602555@qq.com>
 *
 * For more information, please view SYIMRecorder (https://github.com/reesun1130/SYIMRecorder)
 */

#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioToolbox.h>

typedef NS_ENUM(NSUInteger, SYAmrPlayerState) {
    SYAmrPlayerStateStop = 0,
    SYAmrPlayerStatePrepare,
    SYAmrPlayerStatePlaying,
    SYAmrPlayerStatePause,
};
@protocol SYAmrPlayerDelegate;

@interface SYIMAmrPlayer : NSObject

@property (nonatomic, weak) id <SYAmrPlayerDelegate> delegate;
@property (nonatomic, readonly) SYAmrPlayerState state;/**播放状态*/

/**
 * 音频文件地址
 */
@property (nonatomic, copy, readonly) NSString *amrPath;

/**
 *  初始化播放器
 *
 *  @param path 音频文件存放路径
 *
 *  @return SYIMAmrPlayer
 */
- (id)initWithPath:(NSString *)path;

//播放控制
- (int)prepare;
- (int)play;
- (void)stop;
- (void)pause;
- (void)resume;

@end

@protocol SYAmrPlayerDelegate <NSObject>

@optional

//监测播放状态请使用这些代理
- (void)syAmrPlayerDidStarted:(SYIMAmrPlayer *)player;
- (void)syAmrPlayerDidEnded:(SYIMAmrPlayer *)player;
- (void)syAmrPlayerDidPaused:(SYIMAmrPlayer *)player;
- (void)syAmrPlayerDidResumed:(SYIMAmrPlayer *)player;
- (void)syAmrPlayerDidFail:(SYIMAmrPlayer *)player;

@end
