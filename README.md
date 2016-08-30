# IM Recorder
### SYIMRecorder

* 从SYIMKit拆分出来，提供基础的录音和播放控制功能
* 采用opencore-amr编解码，输出的音频格式为amr
* iOS&amp;Android平台通用

### Introduction

* maxRecordFrames：可设置最短录制时间
* minRecordFrames：可设置最长录制时间
* recordFrames：当前录制时间
* mPath：输出路径
* delegate：- (void)syAmrRecorder:(SYIMAmrRecorder *)recorder didUpdateMeters:(float)meters 动态更新音量波动

### Enjoy IT!

* 将SYIMAmrCore.framework拖入工程，需添加AudioToolbox.framework、AVFoundation.framework
* 设置build settings->enable bitcode->NO

### Example

``` objective-c
   - (IBAction)startRecord:(id)sender {
       if (!_amrRecorder) {
        _amrRecorder = [[SYIMAmrRecorder alloc] init];
        _amrRecorder.delegate = self;
       }
    
       if (_amrRecorder.isRecording) {
         [_amrRecorder sy_stopRecord];
       }
    
    //开始录音
    NSString *localAmr = [self generateCacheFilePath:@"amr" fileName:[NSString stringWithFormat:@"local%.f.amr", [[NSDate date] timeIntervalSince1970] * 1000.0]];
    
    //这个路径一定要创建成功后再初始化录音机
    if (localAmr.length > 0) {
        [_amrRecorder sy_startRecordWithPath:localAmr];
    }
}

- (IBAction)stopRecord:(id)sender {
    [_amrRecorder sy_stopRecord];
}

- (IBAction)playRecord:(id)sender {
    if (_amrPlayer) {
        [_amrPlayer stop];
        _amrPlayer = nil;
    }
    
    //这个路径一定要要是存在的，否则播放失败
    if (_amrRecorder.mPath.length > 0) {
        _amrPlayer = [[SYIMAmrPlayer alloc] initWithPath:_amrRecorder.mPath];
        _amrPlayer.delegate = self;
        [_amrPlayer play];
    }
}

#pragma mark - SYIMAmrRecorderDelegate

- (void)syAmrRecorder:(SYIMAmrRecorder *)recorder didUpdateMeters:(float)meters {
    NSLog(@"meters==%f",meters);
    [self updateMeters:meters];
}

- (void)syAmrRecorderDidStart:(SYIMAmrRecorder *)recorder {
    NSLog(@"syAmrRecorderDidStart");
//    [self showBeginTalkMask];
}

- (void)syAmrRecorderDidFail:(SYIMAmrRecorder *)recorder {
    NSLog(@"syAmrRecorderDidFail");
//    [self showFailTalkMask];
    [self.btnRecorder setTitle:@"点击开始录音" forState:UIControlStateNormal];
}

- (void)syAmrRecorderDidStop:(SYIMAmrRecorder *)recorder {
    NSLog(@"syAmrRecorderDidStop");
    
    if ([recorder sy_isRecordTooShort]) {
//        [self showTooShortTalkMask];
    }
    else if ([recorder sy_isRecordTooLong]) {
//        [self showTooLongTalkMask];
    }
    else {
//        [self hideTalkMask];
    }
    [self.btnRecorder setTitle:@"点击开始录音" forState:UIControlStateNormal];
    NSLog(@"录音时长：%lds",_amrRecorder.recordFrames);
}

#pragma mark - SYIMAmrPlayerDelegate

- (void)syAmrPlayerDidStarted:(SYIMAmrPlayer *)player {
    NSLog(@"syAmrPlayerDidStarted");
}

- (void)syAmrPlayerDidEnded:(SYIMAmrPlayer *)player {
    NSLog(@"syAmrPlayerDidEnded");
}

- (void)syAmrPlayerDidFail:(SYIMAmrPlayer *)player {
    NSLog(@"syAmrPlayerDidFail");
}
``` 

### 效果

![intro png](https://github.com/reesun1130/SYIMRecorder/blob/master/SYIMRecorder/amr.png)
