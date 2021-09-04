//
//  YGSpeechTextItem.m
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import "YGSpeechTextItem.h"
#import "YGSpeechTextSplitter.h"

@implementation YGSpeechTextItem {
    YGSpeechTextSplitter *_splitter;
    id<YGSpeechTextSource> _source;
    NSRange _range;
#ifdef DEBUG
    NSString *_string;
#endif
}

- (instancetype)initWithSplitter:(YGSpeechTextSplitter *)splitter source:(id<YGSpeechTextSource>)source range:(NSRange)range {
    NSParameterAssert(splitter);
    NSParameterAssert(source);
    NSParameterAssert(NSNotFound != range.location);
    if (self = [super init]) {
        _splitter = splitter;
        _source = source;
        _range = range;
#ifdef DEBUG
        _string = [source stringWithRange:range];
#endif
    }
    return self;
}

- (id<YGSpeechTextSource>)source {
    return _source;
}

- (NSArray<YGSpeechText *> *)clauses {
    if (_splitter) {
        return [_splitter clausesHitRange:_range];
    }
    return @[];
}

- (NSArray<YGSpeechText *> *)sentences {
    if (_splitter) {
        return [_splitter sentencesHitRange:_range];
    }
    return @[];
}

- (NSArray<YGSpeechText *> *)paragraphs {
    if (_splitter) {
        return [_splitter paragraphsHitRange:_range];
    }
    return @[];
}

#pragma mark YGSpeechText

- (NSRange)range {
    return _range;
}

- (NSUInteger)length {
    return _range.length;
}

- (NSString *)string {
    if (_source) {
        return [_source stringWithRange:_range];
    }
    return @"";
}

- (NSString *)speechString {
    if (_source) {
        return [_source speechStringWithRange:_range];
    }
    return @"";
}

@end
