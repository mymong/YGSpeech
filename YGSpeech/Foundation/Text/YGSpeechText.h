//
//  YGSpeechText.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import <Foundation/Foundation.h>

@class YGSpeechTextSource;

NS_ASSUME_NONNULL_BEGIN

@interface YGSpeechText : NSObject
- (instancetype)initWithSource:(YGSpeechTextSource *)source range:(NSRange)range;
@property (nonatomic, readonly) YGSpeechTextSource * source;
@property (nonatomic, readonly) NSRange range; // range in source
- (NSUInteger)length; // text length
- (NSString *)string; // origin string
- (NSString *)speechString; // string to synthesize
@end

NS_ASSUME_NONNULL_END
