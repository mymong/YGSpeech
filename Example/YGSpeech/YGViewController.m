//
//  YGViewController.m
//  YGSpeech
//
//  Created by mymong on 09/04/2021.
//  Copyright (c) 2021 mymong. All rights reserved.
//

#import "YGViewController.h"
#import "YGSpeechSynthesizer.h"
#import <AVFoundation/AVFoundation.h>

@interface YGViewController ()
@property YGSpeechSynthesizer *synthesizer;
@property AVAudioPlayer *player;
@end

@implementation YGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    self.synthesizer = [YGSpeechSynthesizer synthesizerWithVoice:YGSpeechSynthesizer.descriptors.firstObject.allVoices.firstObject];
    [self.synthesizer synthesize:@"用谅解、宽恕的目光和心理看人、待人。人就会觉得葱笼的世界里,春意盎然,到处充满温暖。" completion:^(YGSpeechSynthesizerAudio * _Nullable audio, NSError * _Nullable error) {
        self.player = [[AVAudioPlayer alloc] initWithData:audio.data error:NULL];
        [self.player play];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
