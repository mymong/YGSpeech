//
//  YGSpeechTextFragment.m
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import "YGSpeechTextFragment.h"

@implementation YGSpeechTextFragment {
    id<YGSpeechTextSource> _source;
    NSRange _range;
#ifdef DEBUG
    NSString *_string;
#endif
}

- (instancetype)initWithSource:(id<YGSpeechTextSource>)source range:(NSRange)range {
    NSParameterAssert(source);
    NSParameterAssert(NSNotFound != range.location);
    if (self = [super init]) {
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
