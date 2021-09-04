//
//  YGSpeechTextSplitter.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import "YGSpeechTextSource.h"
#import "YGSpeechTextItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface YGSpeechTextSplitter : NSObject
@property (nonatomic, readonly) id<YGSpeechTextSource> source;
- (instancetype)initWithSource:(id<YGSpeechTextSource>)source;
@property (nonatomic, readonly) NSArray<YGSpeechText *> *clauses;
@property (nonatomic, readonly) NSArray<YGSpeechText *> *sentences;
@property (nonatomic, readonly) NSArray<YGSpeechText *> *paragraphs;
- (NSArray<YGSpeechText *> *)clausesHitRange:(NSRange)range;
- (NSArray<YGSpeechText *> *)sentencesHitRange:(NSRange)range;
- (NSArray<YGSpeechText *> *)paragraphsHitRange:(NSRange)range;
- (nullable YGSpeechTextItem *)itemFromLocation:(NSUInteger)location capacity:(NSUInteger)capacity;
@end

NS_ASSUME_NONNULL_END
