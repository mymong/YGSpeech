//
//  YGSpeechSynthesizerDescriptor.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/5.
//

#import <Foundation/Foundation.h>

@class YGSpeechSynthesizer;

NS_ASSUME_NONNULL_BEGIN

@protocol YGSpeechSynthesizerDescriptor <NSObject>
- (NSString *)vender;
- (NSArray<NSDictionary *> *)allVoices;
- (YGSpeechSynthesizer *)synthesizerWithVoice:(NSDictionary *)voice;
@end

NS_ASSUME_NONNULL_END
