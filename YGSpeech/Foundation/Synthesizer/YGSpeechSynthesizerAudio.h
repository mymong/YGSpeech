//
//  YGSpeechSynthesizerAudio.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const YGSpeechSynthesizerAudioTypeMP3;
FOUNDATION_EXPORT NSString * const YGSpeechSynthesizerAudioTypeWAV;

@interface YGSpeechSynthesizerAudio : NSObject
@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) NSString *type;
- (instancetype)initWithData:(NSData *)data type:(NSString *)type;
+ (NSData *)wavDataByConvertingPcmData:(NSData *)pcm sampleRate:(uint64_t)sampleRate channels:(uint64_t)channels;
@end

NS_ASSUME_NONNULL_END
