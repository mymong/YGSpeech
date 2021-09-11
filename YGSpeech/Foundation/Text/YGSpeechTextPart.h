//
//  YGSpeechTextPart.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import "YGSpeechText.h"

NS_ASSUME_NONNULL_BEGIN

@interface YGSpeechTextPart : YGSpeechText
- (NSArray<YGSpeechText *> *)clauses;
- (NSArray<YGSpeechText *> *)sentences;
- (NSArray<YGSpeechText *> *)paragraphs;
@end

NS_ASSUME_NONNULL_END
