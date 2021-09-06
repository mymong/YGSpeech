//
//  YGSpeechSynthesizerTask.h
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YGSpeechSynthesizerTask <NSObject>
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
