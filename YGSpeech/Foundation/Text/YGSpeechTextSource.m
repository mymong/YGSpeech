//
//  YGSpeechTextSource.m
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/8.
//

#import "YGSpeechTextSource.h"

@implementation YGSpeechTextSource {
    id _string; // NSString or NSAttributedString
}

- (instancetype)initWithString:(NSString *)string {
    if (self = [super init]) {
        _string = [string isKindOfClass:NSString.class] ? string : @"";
    }
    return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)string {
    if (self = [super init]) {
        _string = [string isKindOfClass:NSAttributedString.class] ? string : @"";
    }
    return self;
}

- (NSUInteger)length {
    return [_string length];
}

- (NSString *)string {
    if ([_string isKindOfClass:NSAttributedString.class]) {
        return [((NSAttributedString *)_string) string];
    } else {
        return _string;
    }
}

- (NSString *)stringWithRange:(NSRange)range {
    NSString *string = [self string];
    NSUInteger length = string.length;
    
    if (0 == range.location && range.length == length) {
        return string;
    }
    
    if (0 == range.length) {
        return @"";
    }
    
    if (range.location >= length) {
        NSAssert(NO, @"Invalid parameter range.location");
        string = @"";
    }
    else if (NSMaxRange(range) > length) {
        NSAssert(NO, @"Invalid parameter range.location + range.length");
        string = [string substringFromIndex:range.location];
    }
    else {
        string = [string substringWithRange:range];
    }
    
    if (range.length > string.length) {
        NSMutableString *mstr = [string mutableCopy];
        for (NSUInteger i = string.length; i < range.length; i ++) {
            [mstr appendString:@" "];
        }
        string = mstr;
    }
    
    return string;
}

- (NSString *)speechStringWithRange:(NSRange)range {
    NSString *string = [self stringWithRange:range];
    return [self speechStringWithString:string];
}

#pragma mark Private

- (NSString *)speechStringWithString:(NSString *)string {
    //将 “换行符” 全部替换为句号
    NSArray *comps = [string componentsSeparatedByCharactersInSet:NSCharacterSet.newlineCharacterSet];
    string = [comps componentsJoinedByString:@"。"];
    
    //将 “占位符” 全部替换为逗号
    comps = [string componentsSeparatedByString:@"\U0000fffc"];
    string = [comps componentsJoinedByString:@"，"];
    
    return string;
}

@end
