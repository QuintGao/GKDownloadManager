//
//  GKDownloadModel.m
//  GKDownloadManager
//
//  Created by QuintGao on 2018/4/11.
//  Copyright © 2018年 QuintGao. All rights reserved.
//

#import "GKDownloadModel.h"

@implementation GKDownloadModel

- (NSString *)fileLocalPath {
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", self.fileID, [[self.fileUrl componentsSeparatedByString:@"."] lastObject]];
    
    return [[KDownloadManager downloadDataDir] stringByAppendingPathComponent:fileName];
}

@end
