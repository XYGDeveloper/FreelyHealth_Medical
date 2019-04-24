//
//  GifView.m
//  Jianshu
//
//  Created by 黄雄彪 on 16/7/13.
//  Copyright © 2016年 sihan. All rights reserved.
//

#import "GifView.h"
#import <QuartzCore/QuartzCore.h>


@implementation GifView

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)filePath
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (!filePath) {
            return nil;
        }
        NSDictionary *gifLoopCount = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
        
        gifProperties = [NSDictionary dictionaryWithObject:gifLoopCount forKey:(NSString *)kCGImagePropertyGIFDictionary];
        
        gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:filePath], (CFDictionaryRef)gifProperties);
        if (!gif) {
            return nil;
        }
        count =CGImageSourceGetCount(gif);
//        =================
        //定义一个变量记录gif播放一轮的时间
        float allTime=0;
        //存放所有图片
        NSMutableArray * imageArray = [[NSMutableArray alloc]init];
        //存放每一帧播放的时间
        NSMutableArray * timeArray = [[NSMutableArray alloc]init];
        //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
        NSMutableArray * widthArray = [[NSMutableArray alloc]init];
        //存放每张图片的高度
        NSMutableArray * heightArray = [[NSMutableArray alloc]init];
        //遍历
        for (size_t i=0; i<count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(gif, i, NULL);
            [imageArray addObject:(__bridge UIImage *)(image)];
            CGImageRelease(image);
            //获取图片信息
            NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(gif, i, NULL);
            CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
            CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
            [widthArray addObject:[NSNumber numberWithFloat:width]];
            [heightArray addObject:[NSNumber numberWithFloat:height]];
            NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
            CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFUnclampedDelayTime]floatValue];
            NSLog(@"%f",time);
            allTime+=time;
            [timeArray addObject:[NSNumber numberWithFloat:time]];
        }
//        =================
        //调节帧速度
        NSLog(@"%f==%f==%ld",allTime/count,allTime,count);
        timer = [NSTimer scheduledTimerWithTimeInterval:allTime/count target:self selector:@selector(play) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [timer fire];
    }
    return self;
}

-(void)play
{
    index ++;
    index = index%count;
    CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
    self.layer.contents = (__bridge id)ref;
    CFRelease(ref);
}

- (void)dealloc
{
    NSLog(@"dealloc");
    CFRelease(gif);
}

- (void)stopGif
{
    [timer invalidate];
    timer = nil;
}

@end
