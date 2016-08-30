//
//  ViewController.m
//  SYIMRecorder
//
//  Created by Ree Sun on 16/8/30.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "ViewController.h"
#import <SYIMAmrCore/SYIMAmrCore.h>

@interface ViewController () <SYAmrRecorderDelegate, SYAmrPlayerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageMeters;
@property (nonatomic, weak) IBOutlet UIButton *btnRecorder;

@property (nonatomic, strong) SYIMAmrRecorder *amrRecorder;//录音机
@property (nonatomic, strong) SYIMAmrPlayer *amrPlayer;//播放机

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

//更新录音meters(音量大小，插上耳机的话meters值会变得很小，自己判断)
- (void)updateMeters:(float)meters {
    UIImage *prossImage = [UIImage imageNamed:@"RecordingSignal001"];
    
    if (meters >= .8) {
        prossImage = [UIImage imageNamed:@"RecordingSignal008"];
    }
    else if (meters >= .7) {
        prossImage = [UIImage imageNamed:@"RecordingSignal007"];
    }
    else if (meters >= .6) {
        prossImage = [UIImage imageNamed:@"RecordingSignal006"];
    }
    else if (meters >= .5) {
        prossImage = [UIImage imageNamed:@"RecordingSignal005"];
    }
    else if (meters >= .4) {
        prossImage = [UIImage imageNamed:@"RecordingSignal004"];
    }
    else if (meters >= .3) {
        prossImage = [UIImage imageNamed:@"RecordingSignal003"];
    }
    else if (meters >= .2) {
        prossImage = [UIImage imageNamed:@"RecordingSignal002"];
    }
    else if (meters >= .1) {
        prossImage = [UIImage imageNamed:@"RecordingSignal001"];
    }
    self.imageMeters.image = prossImage;
    
    //时间
    [self.btnRecorder setTitle:[NSString stringWithFormat:@"时长：%lds",_amrRecorder.recordFrames] forState:UIControlStateNormal];
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

#pragma mark - amr file cache

- (NSString *)generateCacheFilePath:(NSString *)dirName fileName:(NSString *)fileName {
    NSString *filePath = [[self generateCacheDirPath:dirName] stringByAppendingPathComponent:fileName];
    return filePath;
}

- (NSString *)generateCacheDirPath:(NSString *)dirName {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *dirPath = [cachesPath stringByAppendingPathComponent:dirName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL isExists = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!(isExists && isDir))
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return dirPath;
}

@end
