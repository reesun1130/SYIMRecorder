/**
 * This file is part of the SYIMAmrCore Framework.
 * (c) Ree Sun <ree.sun.cn@hotmail.com || 1507602555@qq.com>
 *
 * For more information, please view SYIMRecorder (https://github.com/reesun1130/SYIMRecorder)
 * SYIMAmrCore模块从SYIMKit拆分出来，提供录音和播放控制功能
 */
#warning 使用时需添加AudioToolbox.framework、AVFoundation.framework，并设置build settings->enable bitcode->no

#import <UIKit/UIKit.h>

//! Project version number for SYIMAmrCore.
FOUNDATION_EXPORT double SYIMAmrCoreVersionNumber;

//! Project version string for SYIMAmrCore.
FOUNDATION_EXPORT const unsigned char SYIMAmrCoreVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SYIMAmrCore/PublicHeader.h>
#import <SYIMAmrCore/SYIMAmrRecorder.h>
#import <SYIMAmrCore/SYIMAmrPlayer.h>
