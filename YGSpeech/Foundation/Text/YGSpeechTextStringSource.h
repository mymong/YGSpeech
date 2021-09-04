//
//  YGSpeechTextStringSource.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import "YGSpeechTextSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface YGSpeechTextStringSource : YGSpeechText <YGSpeechTextSource>
- (instancetype)initWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
