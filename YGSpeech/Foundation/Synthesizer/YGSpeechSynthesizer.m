//
//  YGSpeechSynthesizer.m
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/5.
//

#import "YGSpeechSynthesizer.h"

NSString * const YGSpeechSynthesizerSampleRate8K = @"8000";
NSString * const YGSpeechSynthesizerSampleRate16K = @"16000";
NSString * const YGSpeechSynthesizerSampleRate24K = @"24000";

@implementation YGSpeechSynthesizer

- (instancetype)initWithVoice:(NSDictionary *)voice descriptor:(id<YGSpeechSynthesizerDescriptor>)descriptor {
    NSParameterAssert(voice);
    NSParameterAssert(descriptor);
    NSParameterAssert([voice[@"vender"] isEqualToString:[descriptor vender]]);
    if (self = [super init]) {
        _voice = voice;
        _descriptor = descriptor;
    }
    return self;
}

- (nullable id<YGSpeechSynthesizerTask>)synthesize:(NSString *)text completion:(void (^)(YGSpeechSynthesizerAudio *_Nullable audio, NSError *_Nullable error))completion {
    NSData *data = [YGSpeechSynthesizerAudio wavDataByConvertingPcmData:[NSData new] sampleRate:[YGSpeechSynthesizerSampleRate16K integerValue] channels:1];
    YGSpeechSynthesizerAudio *audio = [[YGSpeechSynthesizerAudio alloc] initWithData:data type:YGSpeechSynthesizerAudioTypeWAV];
    !completion?:completion(audio, nil);
    return nil;
}

@end

@implementation YGSpeechSynthesizer (Factory)

NSMutableArray *g_synthesizerDescriptors;

+ (NSArray<id<YGSpeechSynthesizerDescriptor>> *)descriptors {
    return g_synthesizerDescriptors;
}

+ (void)registerDescriptor:(id<YGSpeechSynthesizerDescriptor>)descriptor {
    NSParameterAssert(descriptor);
    if (descriptor) {
        if (!g_synthesizerDescriptors) {
            g_synthesizerDescriptors = [NSMutableArray new];
        }
        [g_synthesizerDescriptors addObject:descriptor];
    }
}

+ (nullable id<YGSpeechSynthesizerDescriptor>)descriptorForVender:(NSString *)vender {
    NSParameterAssert(vender);
    if (!vender || 0 == vender.length) {
        return nil;
    }
    id<YGSpeechSynthesizerDescriptor> descriptor = nil;
    for (id<YGSpeechSynthesizerDescriptor> obj in g_synthesizerDescriptors) {
        if ([obj.vender isEqualToString:vender]) {
            descriptor = obj;
            break;
        }
    }
    return descriptor;
}

+ (nullable YGSpeechSynthesizer *)synthesizerWithVoice:(NSDictionary *)voice {
    NSParameterAssert(voice);
    if (!voice) {
        return nil;
    }
    NSString *vender = voice[@"vender"];
    NSParameterAssert([vender isKindOfClass:NSString.class]);
    id<YGSpeechSynthesizerDescriptor> descriptor = [self descriptorForVender:vender];
    NSParameterAssert(descriptor);
    if (!descriptor) {
        return nil;
    }
    return [descriptor synthesizerWithVoice:voice];
}

@end
