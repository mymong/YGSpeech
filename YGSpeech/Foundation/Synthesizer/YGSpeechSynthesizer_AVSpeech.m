//
//  YGSpeechSynthesizer_AVSpeech.m
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/5.
//

#import "YGSpeechSynthesizer_AVSpeech.h"
#import <AVFoundation/AVFoundation.h>

@interface YGSpeechSynthesizer_AVSpeech ()
@property (nonatomic, readonly) AVSpeechSynthesizer *synthesizer;
@end

@implementation YGSpeechSynthesizer_AVSpeech

- (instancetype)initWithVoice:(NSDictionary *)voice descriptor:(id<YGSpeechSynthesizerDescriptor>)descriptor {
    if (self = [super initWithVoice:voice descriptor:descriptor]) {
        _synthesizer = [AVSpeechSynthesizer new];
    }
    return self;
}

- (nullable id<YGSpeechSynthesizerTask>)synthesize:(NSString *)text completion:(void (^)(YGSpeechSynthesizerAudio * _Nullable, NSError * _Nullable))completion {
    
    float rate = AVSpeechUtteranceDefaultSpeechRate;
    NSString *language = @"zh-CN";
    
    NSString *str = self.voice[@"rate"];
    if (str && str.length > 0) {
        rate = [str floatValue];
        if (rate < AVSpeechUtteranceMinimumSpeechRate) {
            rate = AVSpeechUtteranceMinimumSpeechRate;
        }
        if (rate > AVSpeechUtteranceMaximumSpeechRate) {
            rate = AVSpeechUtteranceMaximumSpeechRate;
        }
    }
    
    str = self.voice[@"language"];
    if (str && str.length > 0) {
        language = str;
    }
    
    [self synthesizer:self.synthesizer synthesize:text language:language rate:rate completion:^(NSData *pcmData, AVAudioFormat *format) {
        uint64_t sampleRate = format ? format.sampleRate : [YGSpeechSynthesizerSampleRate16K integerValue];
        uint64_t channels = format ? format.channelCount : 1;
        NSData *wavData = [YGSpeechSynthesizerAudio wavDataByConvertingPcmData:pcmData sampleRate:sampleRate channels:channels];
        YGSpeechSynthesizerAudio *audio = [[YGSpeechSynthesizerAudio alloc] initWithData:wavData type:YGSpeechSynthesizerAudioTypeWAV];
        !completion?:completion(audio, nil);
    }];
    
    return nil;
}

- (void)synthesizer:(AVSpeechSynthesizer *)synthesizer synthesize:(NSString *)text language:(NSString *)language rate:(float)rate completion:(void (^)(NSData *pcmData, AVAudioFormat *format))completion {
    NSMutableData *pcmData = [NSMutableData new];
    __block AVAudioFormat *format = nil;
    
    if (!synthesizer || !text || 0 == text.length) {
        !completion?:completion(pcmData, nil);
        return;
    }
    
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:language];
    if (!voice) {
        voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    }
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.voice = voice;
    utterance.rate = rate;
    
    if (@available(iOS 13.0, *)) {
        [synthesizer writeUtterance:utterance toBufferCallback:^(AVAudioBuffer * _Nonnull buffer) {
            if (![buffer isKindOfClass:AVAudioPCMBuffer.class]) {
                !completion?:completion(pcmData, nil);
                return;
            }
            
            AVAudioPCMBuffer *pcmBuffer = (AVAudioPCMBuffer *)buffer;
            if (!format) {
                format = pcmBuffer.format;
            }
            if (pcmBuffer.frameLength == 0) {
                !completion?:completion(pcmData, format);
                return;
            }
            
            const AudioBufferList *list = pcmBuffer.audioBufferList;
            for (UInt32 i = 0; i < list->mNumberBuffers; i ++) {
                const AudioBuffer *buf = list->mBuffers + i;
                [pcmData appendBytes:buf->mData length:buf->mDataByteSize];
            }
        }];
    } else {
        !completion?:completion(pcmData, nil);
    }
}

@end

@implementation YGSpeechSynthesizerDescriptor_AVSpeech

+ (void)load {
    [YGSpeechSynthesizer registerDescriptor:[self new]];
}

- (NSString *)vender {
    return @"avspeech";
}

- (NSArray<NSDictionary *> *)allVoices {
    return @[
        @{ @"vender": self.vender,
           @"language": @"zh-CN",
           @"rate": @"0.5",
        },
    ];
}

- (YGSpeechSynthesizer *)synthesizerWithVoice:(NSDictionary *)voice {
    NSString *vender = voice[@"vender"];
    if (!vender || ![vender isEqualToString:self.vender]) {
        return nil;
    }
    return [[YGSpeechSynthesizer_AVSpeech alloc] initWithVoice:voice descriptor:self];
}

@end
