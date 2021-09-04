//
//  YGSpeechTextSource.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/4.
//

#import "YGSpeechText.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YGSpeechTextSource <NSObject>
- (NSUInteger)length;
- (NSString *)stringWithRange:(NSRange)range;
- (NSString *)speechStringWithRange:(NSRange)range;
@end

NS_ASSUME_NONNULL_END
