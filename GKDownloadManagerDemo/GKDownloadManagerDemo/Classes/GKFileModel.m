//
//  GKFileModel.m
//  GKDownloadManagerDemo
//
//  Created by aystfm on 2018/4/12.
//  Copyright © 2018年 QuintGao. All rights reserved.
//

#import "GKFileModel.h"

@implementation GKFileModel

// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"file_id" : @"id"
             };
}

- (NSString *)file_url {
    if (self.songLink) {
        return self.songLink;
    }else if (self.video_uri) {
        return self.video_uri;
    }
    return nil;
}

@end
