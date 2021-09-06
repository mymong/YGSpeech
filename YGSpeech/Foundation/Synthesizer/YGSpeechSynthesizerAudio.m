//
//  YGSpeechSynthesizerAudio.m
//  YGSpeech
//
//  Created by Guang Yang on 2021/9/5.
//

#import "YGSpeechSynthesizerAudio.h"

NSString * const YGSpeechSynthesizerAudioTypeMP3 = @"mp3";
NSString * const YGSpeechSynthesizerAudioTypeWAV = @"wav";

@implementation YGSpeechSynthesizerAudio

- (instancetype)initWithData:(NSData *)data type:(NSString *)type {
    NSParameterAssert(data);
    NSParameterAssert(type);
    if (self = [super init]) {
        _data = data;
        _type = type;
    }
    return self;
}

+ (NSData *)wavDataByConvertingPcmData:(NSData *)pcmData sampleRate:(uint64_t)sampleRate channels:(uint64_t)channels {
    uint64_t pcmDataLen = pcmData ? pcmData.length : 0;
    uint64_t wavDataLen = pcmDataLen + 44;
    uint64_t bitsPerChannel = 16;
    uint64_t byteRate = sampleRate * channels * (bitsPerChannel >> 3);
    
    uint8_t header[44];
    // RIFF/WAVE header
    header[0] = 'R';
    header[1] = 'I';
    header[2] = 'F';
    header[3] = 'F';
    header[4] = (uint8_t)(wavDataLen & 0xff);
    header[5] = (uint8_t)((wavDataLen >> 8) & 0xff);
    header[6] = (uint8_t)((wavDataLen >> 16) & 0xff);
    header[7] = (uint8_t)((wavDataLen >> 24) & 0xff);
    header[8] = 'W';
    header[9] = 'A';
    header[10] = 'V';
    header[11] = 'E';
    // 'fmt' chunk
    header[12] = 'f';
    header[13] = 'm';
    header[14] = 't';
    header[15] = ' ';
    // 4 bytes, size of 'fmt' chunk
    header[16] = 16;
    header[17] = 0;
    header[18] = 0;
    header[19] = 0;
    // format
    header[20] = 1; // framesPerPacket, pcm格式为1
    header[21] = 0;
    // channels
    header[22] = (uint8_t)channels;
    header[23] = 0;
    // sampleRate
    header[24] = (uint8_t)(sampleRate & 0xff);
    header[25] = (uint8_t)((sampleRate >> 8) & 0xff);
    header[26] = (uint8_t)((sampleRate >> 16) & 0xff);
    header[27] = (uint8_t)((sampleRate >> 24) & 0xff);
    // byteRate
    header[28] = (uint8_t)(byteRate & 0xff);
    header[29] = (uint8_t)((byteRate >> 8) & 0xff);
    header[30] = (uint8_t)((byteRate >> 16) & 0xff);
    header[31] = (uint8_t)((byteRate >> 24) & 0xff);
    // block align
    header[32] = channels * (bitsPerChannel >> 3); // bytesPerFrame
    header[33] = 0;
    // bits per sample
    header[34] = bitsPerChannel;
    header[35] = 0;
    // data
    header[36] = 'd';
    header[37] = 'a';
    header[38] = 't';
    header[39] = 'a';
    header[40] = (uint8_t)(pcmDataLen & 0xff);
    header[41] = (uint8_t)((pcmDataLen >> 8) & 0xff);
    header[42] = (uint8_t)((pcmDataLen >> 16) & 0xff);
    header[43] = (uint8_t)((pcmDataLen >> 24) & 0xff);
    
    NSMutableData *wavData = [NSMutableData new];
    [wavData appendBytes:header length:44];
    if (pcmData) {
        [wavData appendData:pcmData];
    }
    return wavData;
}

@end
