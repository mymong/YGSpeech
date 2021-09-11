//
//  YGSpeechTextSplitter.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import "YGSpeechTextSource.h"
#import "YGSpeechTextPart.h"

NS_ASSUME_NONNULL_BEGIN

@interface YGSpeechTextSplitter : NSObject

- (instancetype)initWithSource:(YGSpeechTextSource *)source;
@property (nonatomic, readonly) YGSpeechTextSource * source;

@property (nonatomic, readonly) NSArray<YGSpeechText *> *clauses;
@property (nonatomic, readonly) NSArray<YGSpeechText *> *sentences;
@property (nonatomic, readonly) NSArray<YGSpeechText *> *paragraphs;

- (NSArray<YGSpeechText *> *)clausesHitRange:(NSRange)range;
- (NSArray<YGSpeechText *> *)sentencesHitRange:(NSRange)range;
- (NSArray<YGSpeechText *> *)paragraphsHitRange:(NSRange)range;

- (nullable YGSpeechText *)clauseHitLocation:(NSUInteger)location;
- (nullable YGSpeechText *)sentenceHitLocation:(NSUInteger)location;
- (nullable YGSpeechText *)paragraphHitLocation:(NSUInteger)location;

- (nullable YGSpeechTextPart *)textPartFromLocation:(NSUInteger)location maxLength:(NSUInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
