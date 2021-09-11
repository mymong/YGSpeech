//
//  YGSpeechText.m
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import "YGSpeechText.h"
#import "YGSpeechTextSource.h"

@implementation YGSpeechText {
#ifdef DEBUG
    NSString *_string;
#endif
}

- (instancetype)initWithSource:(YGSpeechTextSource *)source range:(NSRange)range {
    NSParameterAssert(source);
    NSParameterAssert(NSNotFound != range.location);
    NSParameterAssert(NSMaxRange(range) <= [source length]);
    if (self = [super init]) {
        _source = source;
        _range = range;
#ifdef DEBUG
        _string = [source stringWithRange:range];
#endif
    }
    return self;
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
