//
//  YGSpeechTextSplitter.m
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import "YGSpeechTextSplitter.h"

@interface YGSpeechTextPart ()
- (instancetype)initWithSplitter:(YGSpeechTextSplitter *)splitter source:(YGSpeechTextSource *)source range:(NSRange)range;
@end

@implementation YGSpeechTextSplitter {
    NSArray<YGSpeechText *> *_clauses;
    NSArray<YGSpeechText *> *_sentences;
    NSArray<YGSpeechText *> *_paragraphs;
}

- (instancetype)initWithSource:(YGSpeechTextSource *)source {
    NSParameterAssert(source);
    if (self = [super init]) {
        _source = source;
    }
    return self;
}

#pragma mark segments

- (NSArray<YGSpeechText *> *)clauses {
    if (!_clauses) {
        _clauses = [self clausesWithSource:[self source]];
    }
    return _clauses;
}

- (NSArray<YGSpeechText *> *)sentences {
    if (!_sentences) {
        _sentences = [self sentencesWithClauses:[self clauses]];
    }
    return _sentences;
}

- (NSArray<YGSpeechText *> *)paragraphs {
    if (!_paragraphs) {
        _paragraphs = [self paragraphsWithSentences:[self sentences]];
    }
    return _paragraphs;
}

#pragma mark hit range

- (NSArray<YGSpeechText *> *)clausesHitRange:(NSRange)range {
    return [self segmentsHitRange:range fromSegments:[self clauses]];
}

- (NSArray<YGSpeechText *> *)sentencesHitRange:(NSRange)range {
    return [self segmentsHitRange:range fromSegments:[self sentences]];
}

- (NSArray<YGSpeechText *> *)paragraphsHitRange:(NSRange)range {
    return [self segmentsHitRange:range fromSegments:[self paragraphs]];
}

- (NSArray<YGSpeechText *> *)segmentsHitRange:(NSRange)range fromSegments:(NSArray<YGSpeechText *> *)texts {
    NSMutableArray *array = [NSMutableArray new];
    for (YGSpeechText *text in texts) {
        NSRange textRange = [text range];
        if (textRange.location >= NSMaxRange(range)) {
            break;
        }
        if (NSMaxRange(textRange) > range.location) {
            [array addObject:text];
        }
    }
    return array;
}

#pragma mark hit location

- (nullable YGSpeechText *)clauseHitLocation:(NSUInteger)location {
    return [self segmentHitLocation:location fromSegments:[self clauses]];
}

- (nullable YGSpeechText *)sentenceHitLocation:(NSUInteger)location {
    return [self segmentHitLocation:location fromSegments:[self sentences]];
}

- (nullable YGSpeechText *)paragraphHitLocation:(NSUInteger)location {
    return [self segmentHitLocation:location fromSegments:[self paragraphs]];
}

- (nullable YGSpeechText *)segmentHitLocation:(NSUInteger)location fromSegments:(NSArray<YGSpeechText *> *)texts {
    for (YGSpeechText *text in texts) {
        NSRange range = [text range];
        if (location >= range.location && location < NSMaxRange(range)) {
            return text;
        }
    }
    return nil;
}

#pragma mark split

- (nullable YGSpeechTextPart *)textPartFromLocation:(NSUInteger)location maxLength:(NSUInteger)maxLength {
    NSRange partRange = NSMakeRange(0, 0);
    for (YGSpeechText *clause in [self clauses]) {
        
        NSRange range = [clause range];
        if (location < range.location) {
            return nil;
        }
        
        //当不是从小句第一个字符开始的话，有可能导致剩下的字符可能全是符号不能发出声音，有的合成引擎无法处理不发音的文本！
        //因此我们需要检查一下，如果剩余的都是符号则忽略该小句。
        if (location > range.location) {
            NSString *speechString = [clause speechString];
            speechString = [speechString stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
            if (0 ==  speechString.length) {
                continue; //不发音，忽略
            }
        }
        
        //如果即将超出限制
        if (range.length + partRange.length > maxLength) {
            
            //如果已经提取有内容了，则返回之
            if (partRange.length > 0) {
                break; //避免硬拆句
            }
            
            //当不是从小句的最后一个字符结束的话，可能前面的字符全是符号不能发出声音，有的合成引擎无法处理不发音的文本！
            //因此我们需要检查一下，如果剩余的都是符号则忽略该小句。
            NSString *speechString = [_source speechStringWithRange:NSMakeRange(range.location, maxLength)];
            [speechString stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
            if (0 == speechString.length) {
                location = range.location + maxLength;
                continue; //不发音，忽略
            }
            
            //硬拆句
            partRange.location = range.location;
            partRange.length = maxLength;
            break;
        }
        
        if (0 == partRange.length) {
            partRange = range;
        } else {
            partRange.length = NSMaxRange(range) - partRange.location;
        }
    }
    
    if (partRange.length > 0) {
        return [[YGSpeechTextPart alloc] initWithSplitter:self source:_source range:partRange];
    }
    return nil;
}

#pragma mark Private

- (NSArray<YGSpeechText *> *)clausesWithSource:(YGSpeechTextSource *)source {
    NSParameterAssert(source);
    if (!source) {
        return @[];
    }
    
    NSString *string = [source speechStringWithRange:NSMakeRange(0, [source length])];
    
    NSCharacterSet *clauseEndCharacterSet = [self clauseEndCharacterSet];
    NSCharacterSet *silentCharacterSet = [self silentCharacterSet];
    
    NSMutableArray<NSString *> *texts = [NSMutableArray new];
    if (string.length > 0) {
        NSUInteger location = 0;
        NSString *text = @"";
        BOOL hasValidChars = NO; //包含有效字符（非符号）
        while (TRUE) {
            NSString *next = [self substringFromString:string startAtIndex:location endWithCharactersInSet:clauseEndCharacterSet];
            if (0 == next.length) {
                if (text.length > 0) {
                    [texts addObject:text];
                }
                break;
            }
            if (1 == next.length) {
                //只有分隔符本身，追加到上个文本
                text = [text stringByAppendingString:next];
            }
            else if (0 == [next stringByTrimmingCharactersInSet:silentCharacterSet].length) {
                //都是些标点符号，追加到上个文本
                text = [text stringByAppendingString:next];
            }
            else {
                if (hasValidChars) {
                    [texts addObject:text];
                    text = next;
                }
                else {
                    text = [text stringByAppendingString:next];
                    hasValidChars = YES;
                }
            }
            location += next.length;
        }
    }
    
    NSMutableArray<YGSpeechText *> *clauses = [NSMutableArray new];
    NSUInteger location = 0;
    for (NSString *text in texts) {
        NSRange range = NSMakeRange(location, text.length);
        YGSpeechText *clause = [[YGSpeechText alloc] initWithSource:source range:range];
        [clauses addObject:clause];
        location += text.length;
    }
    
    return clauses;
}

- (NSArray<YGSpeechText *> *)sentencesWithClauses:(NSArray<YGSpeechText *> *)texts {
    NSMutableArray<YGSpeechText *> *sentences = [NSMutableArray new];
    
    NSRange range = NSMakeRange(0, 0);
    for (YGSpeechText *text in texts) {
        if (0 == range.location) {
            range = [text range];
        } else {
            range.length = NSMaxRange([text range]) - range.location;
        }
        if ([self hasSentenceEndCharactersWithText:text]) {
            YGSpeechText *sentence = [[YGSpeechText alloc] initWithSource:_source range:range];
            [sentences addObject:sentence];
            range = NSMakeRange(0, 0);
        }
    }
    
    if (range.length > 0) {
        YGSpeechText *sentence = [[YGSpeechText alloc] initWithSource:_source range:range];
        [sentences addObject:sentence];
    }
    
    return sentences;
}

- (NSArray<YGSpeechText *> *)paragraphsWithSentences:(NSArray<YGSpeechText *> *)texts {
    NSMutableArray<YGSpeechText *> *paragraphs = [NSMutableArray new];
    
    NSRange range = NSMakeRange(0, 0);
    for (YGSpeechText *text in texts) {
        if (0 == range.location) {
            range = [text range];
        } else {
            range.length = NSMaxRange([text range]) - range.location;
        }
        if ([self hasParagraphEndCharactersWithText:text]) {
            YGSpeechText *paragraph = [[YGSpeechText alloc] initWithSource:_source range:range];
            [paragraphs addObject:paragraph];
            range = NSMakeRange(0, 0);
        }
    }
    
    if (range.length > 0) {
        YGSpeechText *paragraph = [[YGSpeechText alloc] initWithSource:_source range:range];
        [paragraphs addObject:paragraph];
    }
    
    return paragraphs;
}

- (NSCharacterSet *)clauseEndCharacterSet {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet newlineCharacterSet];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"\U0000fffc"]];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@",.:;!?"]];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"，。：；！？”"]];
    return characterSet;
}

- (NSCharacterSet *)silentCharacterSet {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet punctuationCharacterSet];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"\U0000fffc"]];
    return characterSet;
}

- (NSCharacterSet *)sentenceEndCharacterSet {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet newlineCharacterSet];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"!?"]];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"。！？"]];
    return characterSet;
}

- (NSString *)substringFromString:(NSString *)string startAtIndex:(NSUInteger)index endWithCharactersInSet:(NSCharacterSet *)characters {
    NSUInteger total = string.length;
    if (index >= total) {
        return @"";
    }
    
    NSRange range = [string rangeOfCharacterFromSet:characters options:0 range:NSMakeRange(index, total - index)];
    if (NSNotFound == range.location) {
        return [string substringFromIndex:index];
    }
    
    return [string substringWithRange:NSMakeRange(index, NSMaxRange(range) - index)];
}

- (BOOL)hasSentenceEndCharactersWithText:(YGSpeechText *)text {
    NSString *string = [text string];
    NSRange range = [string rangeOfCharacterFromSet:[self sentenceEndCharacterSet]];
    if (range.length > 0) {
        return YES;
    }
    range = [string rangeOfString:@". "];
    if (range.length > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)hasParagraphEndCharactersWithText:(YGSpeechText *)text {
    NSString *string = [text string];
    NSRange range = [string rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
    if (range.length > 0) {
        return YES;
    }
    return NO;
}

@end
