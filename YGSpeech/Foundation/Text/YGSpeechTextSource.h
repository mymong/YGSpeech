//
//  YGSpeechTextSource.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGSpeechTextSource : NSObject
- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithAttributedString:(NSAttributedString *)string;
- (NSUInteger)length;
- (NSString *)string;
- (NSString *)stringWithRange:(NSRange)range;
- (NSString *)speechStringWithRange:(NSRange)range;
@end

NS_ASSUME_NONNULL_END
