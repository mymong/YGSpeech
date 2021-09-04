//
//  YGSpeechTextItem.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import "YGSpeechText.h"
#import "YGSpeechTextSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface YGSpeechTextItem : YGSpeechText
- (id<YGSpeechTextSource>)source;
- (NSArray<YGSpeechText *> *)clauses;
- (NSArray<YGSpeechText *> *)sentences;
- (NSArray<YGSpeechText *> *)paragraphs;
@end

NS_ASSUME_NONNULL_END
