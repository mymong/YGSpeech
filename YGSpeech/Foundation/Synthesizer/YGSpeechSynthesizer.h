//
//  YGSpeechSynthesizer.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/5.
//

#import <Foundation/Foundation.h>
#import "YGSpeechSynthesizerAudio.h"
#import "YGSpeechSynthesizerDescriptor.h"
#import "YGSpeechSynthesizerTask.h"

NS_ASSUME_NONNULL_BEGIN

// SampleRate
FOUNDATION_EXPORT NSString * const YGSpeechSynthesizerSampleRate8K;
FOUNDATION_EXPORT NSString * const YGSpeechSynthesizerSampleRate16K;
FOUNDATION_EXPORT NSString * const YGSpeechSynthesizerSampleRate24K;

@interface YGSpeechSynthesizer : NSObject
@property (nonatomic, readonly) NSDictionary *voice;
@property (nonatomic, readonly) id<YGSpeechSynthesizerDescriptor> descriptor;
- (instancetype)initWithVoice:(NSDictionary *)voice descriptor:(id<YGSpeechSynthesizerDescriptor>)descriptor;
- (nullable id<YGSpeechSynthesizerTask>)synthesize:(NSString *)text completion:(void (^)(YGSpeechSynthesizerAudio *_Nullable audio, NSError *_Nullable error))completion;
@end

@interface YGSpeechSynthesizer (Factory)
+ (NSArray<id<YGSpeechSynthesizerDescriptor>> *)descriptors;
+ (void)registerDescriptor:(id<YGSpeechSynthesizerDescriptor>)descriptor;
+ (nullable id<YGSpeechSynthesizerDescriptor>)descriptorForVender:(NSString *)vender;
+ (nullable YGSpeechSynthesizer *)synthesizerWithVoice:(NSDictionary *)voice;
@end

NS_ASSUME_NONNULL_END
