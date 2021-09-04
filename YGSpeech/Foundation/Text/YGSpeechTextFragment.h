//
//  YGSpeechTextFragment.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import "YGSpeechText.h"
#import "YGSpeechTextSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface YGSpeechTextFragment : YGSpeechText
- (instancetype)initWithSource:(id<YGSpeechTextSource>)source range:(NSRange)range;
- (id<YGSpeechTextSource>)source;
@end

NS_ASSUME_NONNULL_END
